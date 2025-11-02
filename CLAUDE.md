# CLAUDE.md - Autonomous Development Project

## Project Context

This is an **autonomous development supervisor** that enables continuous coding during unavailable hours (sleep, work) using Cline CLI + z.ai coding plan.

**Core Problem**: Jeremy has 16-18 hours/day unavailable (8 hours sleep + 8 hours work), limiting coding to 4-6 hours/day. z.ai coding plan could be used 24/7.

**Solution**: Autonomous supervisor that processes task queue during configured hours using Cline CLI's built-in autonomous mode.

**Ethical Framework**:
- 8-10 hours/day max (matches realistic human usage)
- Night shift: 8 hours (10 PM - 6 AM while sleeping)
- Optional day shift: 2 hours (while at work)
- NOT gaming the system - filling availability gaps with same quota usage

## What's Been Done

### Windows Session (Previous)
- ✅ Created project structure
- ✅ Implemented `autonomous_supervisor.py` (332 lines)
- ✅ Created `task_queue.txt` template
- ✅ Created `AUTONOMOUS_DEVELOPMENT.md` (440 lines complete docs)
- ✅ Created `README.md` (quick start guide)
- ✅ Created `.gitignore`
- ✅ Initialized git repo and committed
- ❌ **Blocked**: Cline CLI install failed (Windows not supported, WSL path issues)

### Discovery
- **Cline CLI**: Open source (Apache 2.0), on z.ai approved tools list
- **Autonomous mode**: `--yolo --oneshot` flags (designed feature, not hack)
- **Platform**: macOS and Linux only (NOT Windows)
- **Requirements**: Node.js >= 20.0.0

## Current Status

**Location**: Windows machine (D:\Claude_Workspace_2\Projects\autonomous_dev\)
**Next Step**: Switch to Mac for Cline CLI installation and testing
**Reason**: Native macOS support, clean install, no WSL complications

## Key Files

### autonomous_supervisor.py
**Purpose**: Main autonomous development supervisor
**Key features**:
- Time-windowed execution (configurable hours)
- Task queue processing (FIFO)
- State persistence (.autonomous_state.json)
- Progress logging (autonomous_progress.log)
- Cline CLI integration (`cline task new --yolo --oneshot`)

**Configuration**:
```python
NIGHT_START = dt_time(22, 0)   # 10:00 PM
NIGHT_END = dt_time(6, 0)      # 6:00 AM
# 8 hours autonomous work per night
```

### task_queue.txt
**Purpose**: Task queue (one task per line, FIFO processing)
**Format**:
```
# One task per line
Implement StorageManager from forge.aiuml/design/components/storage.aiuml
Write unit tests for StorageManager
Run validation and fix any BLOCKED methods
```

### AUTONOMOUS_DEVELOPMENT.md
**Purpose**: Complete documentation (440 lines)
**Sections**:
- Quick Start (5 minutes)
- Configuration guide
- Capacity planning (Pro vs Max plan)
- Ethical use guidelines
- Integration with forge workflow
- FAQ and troubleshooting

### README.md
**Purpose**: Quick start guide for GitHub
**Highlights**:
- Problem statement (limited availability)
- Solution overview (autonomous supervisor)
- 5-minute quick start
- Ethical design (ToS compliant)

## Next Steps (On Mac)

### 1. Get Project Files on Mac
Either:
- Clone from git (if pushed): `git clone <repo_url>`
- Copy files from Windows to Mac
- Or just install Cline CLI on Mac first, project files can come later

### 2. Install Cline CLI (Should Work Natively)
```bash
# Check Node.js version (need >= 20.0.0)
node --version

# If too old, install latest Node
# (use nvm or download from nodejs.org)

# Install Cline CLI
npm install -g cline

# Verify installation
cline --version
```

### 3. Configure z.ai Authentication
```bash
# Set up z.ai API key
cline auth zai YOUR_ZAI_API_KEY

# (Get API key from z.ai account settings)
```

### 4. Run Initial Test
```bash
# Simple test task
echo "Create a hello world Python function that prints 'Hello from autonomous dev!'" > test_task.txt

# Run with Cline autonomous mode
cline task new --yolo --oneshot "$(cat test_task.txt)"

# Or test the supervisor (if in that directory)
python autonomous_supervisor.py
```

### 5. Validate Approach
- Check if task completes successfully
- Review output/logs
- Verify ethical usage (time windows working)
- Test task queue processing
- Monitor z.ai quota usage

## Two-Plan Architecture (Future)

**Plan 1** ($15/month Pro): Interactive development (Jeremy's day work)
**Plan 2** ($15/month Pro): Autonomous supervisor (night work)
**Total**: $30/month (same as Max plan, cleaner separation)

Benefits:
- Zero quota conflicts
- Clean separation of concerns
- Actually MORE ethical (independent usage tracking)

## Integration with AIUML Forge

This autonomous system is designed to work with the aiuml-forge refactoring:

**Workflow**:
1. Design component in AIUML with pseudos (Jeremy + Claude interactive)
2. Queue implementation tasks for autonomous supervisor
3. Supervisor processes queue overnight (Cline + z.ai GLM-4.6)
4. Morning: Review results, validate, iterate

**Why GLM-4.6 Works**:
- Already proved itself (implemented forge: 116/116 methods correctly)
- Near parity with Sonnet 4 (48.6% win rate)
- 9x cheaper than Sonnet 4
- AIUML designs + pseudos provide enough guidance

## Important Notes

**DO**:
- Use on Mac (native support)
- Configure time windows to match availability gaps
- Start with simple tasks to validate approach
- Monitor z.ai quota usage
- Review autonomous work each morning

**DON'T**:
- Try to force Windows install (not supported)
- Exceed 10 hours/day (ethical limit)
- Queue complex decision-making tasks (needs human)
- Skip validation of autonomous outputs

## Ethical Commitment

This tool uses Cline CLI's autonomous mode **as designed**. It respects z.ai's ToS by:
- Using approved tool (Cline CLI on approved list)
- Within fair use limits (10 hours/day = realistic human usage)
- Transparent usage (not hiding automation)
- Filling availability gaps, not gaming quota

**If you have concerns about usage patterns, contact z.ai support or adjust configuration.**

## Repository Status

```
Current branch: master
Recent commit: "Initial autonomous development supervisor implementation"
Status: Clean working directory
Location (Windows): D:\Claude_Workspace_2\Projects\autonomous_dev\
```

## Prompt for Next Session

**Hi Claude! I'm continuing work on the autonomous development supervisor.**

**Context**: We created an autonomous task supervisor for overnight development using Cline CLI + z.ai. All files are implemented, but Cline CLI install failed on Windows (not supported).

**Your task**:
1. We're now on Mac (Cline has native macOS support)
2. Install Cline CLI: `npm install -g cline`
3. Configure z.ai authentication
4. Run initial test task to validate the approach
5. Document any issues found

**Key file**: Read this CLAUDE.md for complete context (you're reading it now!)

**Ethical note**: This uses 8-10 hours/day during sleep/work hours - same quota as manual use, just different timing. Fully ToS compliant.

Let's get Cline working and test our autonomous development system!

---

**Last Updated**: 2025-11-02
**Session**: Windows → Mac transition
**Next Step**: Cline CLI installation on Mac
