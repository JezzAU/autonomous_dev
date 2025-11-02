#!/usr/bin/env python3
"""
Autonomous Development Supervisor for aiuml-forge

Fills availability gaps using Cline CLI + z.ai coding plan.
Respects fair use: 10 hours/day max, matching human usage patterns.

Designed for ethical use:
- Only works during unavailable hours (sleep + work)
- Respects z.ai terms of service
- Uses Cline CLI as intended (autonomous mode is a designed feature)
- Stays within reasonable usage limits

Usage:
    python autonomous_supervisor.py

Configuration:
    Edit NIGHT_START, NIGHT_END times below
    Create task_queue.txt with tasks (one per line)
"""

import subprocess
import time
import json
import sys
from datetime import datetime, time as dt_time, timedelta
from pathlib import Path
from typing import List, Optional, Dict

# ============================================================================
# Configuration
# ============================================================================

# Night shift window (while Jeremy sleeps)
NIGHT_START = dt_time(22, 0)   # 10:00 PM
NIGHT_END = dt_time(6, 0)      # 6:00 AM
# Total: 8 hours autonomous work per night

# Optional: Day shift window (while at work)
# Uncomment to add 2 hours during work day (total = 10 hours)
# DAY_START = dt_time(9, 0)    # 9:00 AM
# DAY_END = dt_time(11, 0)     # 11:00 AM
DAY_START = None
DAY_END = None

# Files
TASK_QUEUE_FILE = Path("task_queue.txt")
PROGRESS_LOG_FILE = Path("autonomous_progress.log")
STATE_FILE = Path(".autonomous_state.json")

# Cline CLI configuration
CLINE_TIMEOUT = 3600  # 1 hour max per task
TASK_PAUSE = 30       # 30 seconds between tasks


# ============================================================================
# Time Management
# ============================================================================

def is_night_shift() -> bool:
    """Check if currently in night shift hours"""
    if NIGHT_START is None or NIGHT_END is None:
        return False

    now = datetime.now().time()

    # Handle crossing midnight
    if NIGHT_START > NIGHT_END:
        return now >= NIGHT_START or now <= NIGHT_END
    else:
        return NIGHT_START <= now <= NIGHT_END


def is_day_shift() -> bool:
    """Check if currently in day shift hours"""
    if DAY_START is None or DAY_END is None:
        return False

    now = datetime.now().time()
    return DAY_START <= now <= DAY_END


def is_work_hours() -> bool:
    """Check if currently in any allowed work window"""
    return is_night_shift() or is_day_shift()


def get_current_shift() -> Optional[str]:
    """Get name of current shift"""
    if is_night_shift():
        return "NIGHT"
    elif is_day_shift():
        return "DAY"
    else:
        return None


def time_until_next_shift() -> int:
    """Calculate seconds until next work shift starts"""
    now = datetime.now()
    current_time = now.time()

    # Calculate time until night shift
    if NIGHT_START:
        night_delta = datetime.combine(now.date(), NIGHT_START) - now
        if night_delta.total_seconds() < 0:
            # Night shift is tomorrow
            night_delta += timedelta(days=1)
    else:
        night_delta = None

    # Calculate time until day shift
    if DAY_START:
        day_delta = datetime.combine(now.date(), DAY_START) - now
        if day_delta.total_seconds() < 0:
            # Day shift is tomorrow
            day_delta += timedelta(days=1)
    else:
        day_delta = None

    # Return whichever is sooner
    if night_delta and day_delta:
        return min(night_delta.total_seconds(), day_delta.total_seconds())
    elif night_delta:
        return night_delta.total_seconds()
    elif day_delta:
        return day_delta.total_seconds()
    else:
        return 3600  # Default 1 hour


# ============================================================================
# Task Queue Management
# ============================================================================

def load_task_queue() -> List[str]:
    """Load tasks from queue file"""
    if not TASK_QUEUE_FILE.exists():
        return []

    tasks = []
    for line in TASK_QUEUE_FILE.read_text().strip().split("\n"):
        line = line.strip()
        if line and not line.startswith("#"):
            tasks.append(line)

    return tasks


def save_task_queue(tasks: List[str]):
    """Save remaining tasks to queue file"""
    TASK_QUEUE_FILE.write_text("\n".join(tasks))


def pop_next_task() -> Optional[str]:
    """Remove and return next task from queue"""
    tasks = load_task_queue()
    if not tasks:
        return None

    task = tasks[0]
    save_task_queue(tasks[1:])
    return task


# ============================================================================
# State Management
# ============================================================================

def load_state() -> Dict:
    """Load supervisor state"""
    if not STATE_FILE.exists():
        return {
            "session_start": None,
            "tasks_completed": 0,
            "tasks_failed": 0,
            "total_runtime_hours": 0
        }

    return json.loads(STATE_FILE.read_text())


def save_state(state: Dict):
    """Save supervisor state"""
    STATE_FILE.write_text(json.dumps(state, indent=2))


# ============================================================================
# Logging
# ============================================================================

def log(message: str, level: str = "INFO"):
    """Log message to console and file"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_line = f"[{timestamp}] [{level}] {message}"

    print(log_line)

    with open(PROGRESS_LOG_FILE, "a") as f:
        f.write(log_line + "\n")


# ============================================================================
# Task Execution (via Cline CLI)
# ============================================================================

def run_task_with_cline(task_description: str) -> Dict:
    """
    Execute one task using Cline CLI autonomous mode

    Returns:
        dict with 'success', 'output', 'error', 'duration'
    """
    log(f"Starting task: {task_description[:80]}...")

    start_time = datetime.now()

    try:
        # Run Cline CLI in autonomous oneshot mode
        # --yolo = fully autonomous (no prompts)
        # --oneshot = complete task and stop
        result = subprocess.run(
            ["cline", "task", "new", "--yolo", "--oneshot", task_description],
            capture_output=True,
            text=True,
            timeout=CLINE_TIMEOUT
        )

        duration = (datetime.now() - start_time).total_seconds()

        return {
            "success": result.returncode == 0,
            "output": result.stdout,
            "error": result.stderr,
            "duration": duration
        }

    except subprocess.TimeoutExpired:
        duration = CLINE_TIMEOUT
        log(f"Task timed out after {duration}s", "WARNING")

        return {
            "success": False,
            "output": "",
            "error": f"Task exceeded {CLINE_TIMEOUT}s timeout",
            "duration": duration
        }

    except Exception as e:
        duration = (datetime.now() - start_time).total_seconds()
        log(f"Task failed with exception: {e}", "ERROR")

        return {
            "success": False,
            "output": "",
            "error": str(e),
            "duration": duration
        }


# ============================================================================
# Main Supervisor Loop
# ============================================================================

def wait_for_work_hours():
    """Wait until next work shift starts"""
    if is_work_hours():
        return  # Already in work hours

    seconds_until = time_until_next_shift()
    minutes_until = seconds_until / 60
    hours_until = minutes_until / 60

    log(f"Outside work hours. Next shift in {hours_until:.1f} hours", "INFO")

    # Sleep in 5-minute increments (allows manual interrupt)
    while not is_work_hours():
        time.sleep(300)  # 5 minutes


def run_supervisor():
    """Main supervisor loop"""
    log("=" * 80, "INFO")
    log("Autonomous Development Supervisor Starting", "INFO")
    log(f"Night shift: {NIGHT_START} - {NIGHT_END}", "INFO")
    if DAY_START and DAY_END:
        log(f"Day shift: {DAY_START} - {DAY_END}", "INFO")
    log("=" * 80, "INFO")

    state = load_state()
    state["session_start"] = datetime.now().isoformat()
    session_start_time = datetime.now()

    # Wait for work hours if not currently in them
    wait_for_work_hours()

    log(f"Entering {get_current_shift()} shift - starting work", "INFO")

    # Process tasks while in work hours
    while is_work_hours():
        # Get next task
        task = pop_next_task()

        if task is None:
            log("Task queue empty - waiting for more tasks", "INFO")
            time.sleep(60)  # Check every minute for new tasks
            continue

        # Execute task
        shift = get_current_shift()
        log(f"[{shift}] Processing: {task}", "INFO")

        result = run_task_with_cline(task)

        if result["success"]:
            log(f"✅ Completed in {result['duration']:.1f}s", "SUCCESS")
            state["tasks_completed"] += 1
        else:
            log(f"❌ Failed: {result['error']}", "ERROR")
            state["tasks_failed"] += 1

            # Log failure details
            log(f"Error output: {result['error'][:200]}", "ERROR")

        # Update state
        state["total_runtime_hours"] = (datetime.now() - session_start_time).total_seconds() / 3600
        save_state(state)

        # Pause between tasks
        log(f"Pausing {TASK_PAUSE}s before next task...", "INFO")
        time.sleep(TASK_PAUSE)

        # Check if still in work hours
        if not is_work_hours():
            log(f"{shift} shift ended - stopping work", "INFO")
            break

    # Session complete
    log("=" * 80, "INFO")
    log("Session Summary:", "INFO")
    log(f"  Tasks completed: {state['tasks_completed']}", "INFO")
    log(f"  Tasks failed: {state['tasks_failed']}", "INFO")
    log(f"  Runtime: {state['total_runtime_hours']:.2f} hours", "INFO")
    log("=" * 80, "INFO")
    log("Supervisor stopped (work hours ended)", "INFO")


# ============================================================================
# Entry Point
# ============================================================================

def main():
    """Entry point with error handling"""
    try:
        run_supervisor()
    except KeyboardInterrupt:
        log("\nSupervisor interrupted by user (Ctrl+C)", "WARNING")
        sys.exit(0)
    except Exception as e:
        log(f"Supervisor crashed: {e}", "ERROR")
        import traceback
        log(traceback.format_exc(), "ERROR")
        sys.exit(1)


if __name__ == "__main__":
    main()
