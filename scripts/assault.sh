#!/bin/bash
# Tactical Assault Pattern - Rapid iterative implementation waves
# Usage: ./scripts/assault.sh [wave-name]

set -e

WAVE_NAME="${1:-wave1}"
ASSAULT_DIR=".assault"
WAVE_FILE="$ASSAULT_DIR/$WAVE_NAME.txt"
STATUS_FILE="$ASSAULT_DIR/$WAVE_NAME-status.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Ensure assault directory exists
mkdir -p "$ASSAULT_DIR"

# =============================================================================
# COMMAND FUNCTIONS
# =============================================================================

cmd_plan() {
    echo -e "${CYAN}📋 Planning assault wave: $WAVE_NAME${NC}"
    echo ""
    echo "Create assault wave file: $WAVE_FILE"
    echo ""
    echo "Format (one task per line):"
    echo "  Implement ComponentA from design/component_a.aiuml"
    echo "  Implement ComponentB from design/component_b.aiuml"
    echo "  Write tests for ComponentA"
    echo ""

    if [ -f "$WAVE_FILE" ]; then
        echo -e "${YELLOW}⚠️  Wave file already exists${NC}"
        echo "Contents:"
        cat -n "$WAVE_FILE"
        echo ""
        read -p "Overwrite? (y/N): " confirm
        if [[ ! $confirm =~ ^[Yy]$ ]]; then
            echo "Cancelled"
            exit 0
        fi
    fi

    echo "# Assault wave: $WAVE_NAME" > "$WAVE_FILE"
    echo "# One task per line (non-comment lines will be executed)" >> "$WAVE_FILE"
    echo "# Example: Implement StorageManager from design/storage_manager.aiuml" >> "$WAVE_FILE"
    echo "" >> "$WAVE_FILE"

    echo -e "${GREEN}✅ Created wave file: $WAVE_FILE${NC}"
    echo "Edit this file to define your assault wave tasks"
}

cmd_launch() {
    echo -e "${CYAN}🚀 LAUNCHING ASSAULT WAVE: $WAVE_NAME${NC}"
    echo ""

    if [ ! -f "$WAVE_FILE" ]; then
        echo -e "${RED}❌ Wave file not found: $WAVE_FILE${NC}"
        echo "Run: ./scripts/assault.sh plan $WAVE_NAME"
        exit 1
    fi

    # Read tasks from wave file (skip comments and empty lines)
    mapfile -t tasks < <(grep -v '^#' "$WAVE_FILE" | grep -v '^[[:space:]]*$')

    if [ ${#tasks[@]} -eq 0 ]; then
        echo -e "${RED}❌ No tasks found in wave file${NC}"
        exit 1
    fi

    echo "Tasks to launch: ${#tasks[@]}"
    echo ""

    # Launch each task as background agent
    task_count=0
    for task in "${tasks[@]}"; do
        task_count=$((task_count + 1))
        echo -e "${BLUE}[$task_count/${#tasks[@]}]${NC} Launching: $task"
        cline "$task. Follow implementer-agent rules." --yolo --oneshot &
        sleep 0.5  # Small delay to avoid overwhelming
    done

    echo ""
    echo -e "${GREEN}✅ Launched ${#tasks[@]} agents${NC}"
    echo -e "${YELLOW}⏳ Agents executing in background...${NC}"
    echo ""
    echo "Monitor: ./scripts/assault.sh monitor $WAVE_NAME"
    echo "Assess:  ./scripts/assault.sh assess $WAVE_NAME"
}

cmd_monitor() {
    echo -e "${CYAN}📊 MONITORING ASSAULT WAVE: $WAVE_NAME${NC}"
    echo ""

    # Show task list
    echo "Current task status:"
    cline task list

    echo ""
    echo -e "${YELLOW}Press Ctrl+C to stop monitoring${NC}"
    echo "Refreshing every 30 seconds..."
    echo ""

    # Continuous monitoring loop
    while true; do
        sleep 30
        clear
        echo -e "${CYAN}📊 MONITORING ASSAULT WAVE: $WAVE_NAME${NC}"
        echo "Last update: $(date '+%H:%M:%S')"
        echo ""
        cline task list
        echo ""
        echo -e "${YELLOW}Refreshing in 30s... (Ctrl+C to stop)${NC}"
    done
}

cmd_assess() {
    echo -e "${CYAN}🔍 ASSAULT WAVE ASSESSMENT: $WAVE_NAME${NC}"
    echo ""

    # Get task list as JSON
    echo "Fetching task results..."
    cline task list --output-format json > "$STATUS_FILE" 2>/dev/null || true

    echo ""
    echo "─────────────────────────────────────────"
    echo -e "${CYAN}BATTLE DAMAGE REPORT${NC}"
    echo "─────────────────────────────────────────"

    # Show human-readable status
    cline task list

    echo ""
    echo "─────────────────────────────────────────"
    echo -e "${CYAN}TACTICAL ASSESSMENT${NC}"
    echo "─────────────────────────────────────────"
    echo ""
    echo -e "${GREEN}✅ SUCCESS${NC}    - Implementation complete, ready for review"
    echo -e "${YELLOW}⚠️  PARTIAL${NC}   - Minor issues, quick fix needed"
    echo -e "${RED}❌ BLOCKED${NC}    - Critical blocker, needs design/attention"
    echo ""
    echo "Next steps:"
    echo "  1. Review each task: cline task view <task-id>"
    echo "  2. Fix blockers (You + Claude)"
    echo "  3. Launch next wave: ./scripts/assault.sh launch wave2"
    echo ""
}

cmd_help() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                    TACTICAL ASSAULT PATTERN                   ║
║              Rapid Iterative Implementation Waves             ║
╚═══════════════════════════════════════════════════════════════╝

USAGE:
  ./scripts/assault.sh <command> [wave-name]

COMMANDS:
  plan [wave]     Create new assault wave plan
  launch [wave]   Launch all agents in wave (fire-and-forget)
  monitor [wave]  Monitor wave progress (real-time)
  assess [wave]   Assess results and identify blockers
  help            Show this help

WORKFLOW:
  ┌─────────────────────────────────────────────────────┐
  │ 1. PLAN     - Define wave tasks (.assault/wave.txt)│
  │ 2. LAUNCH   - Fire all agents (parallel)           │
  │ 3. MONITOR  - Watch progress (optional)            │
  │ 4. ASSESS   - Review results, find blockers        │
  │ 5. FIX      - Address blockers (You + Claude)      │
  │ 6. REPEAT   - Launch wave2 with fixes/tests        │
  └─────────────────────────────────────────────────────┘

EXAMPLES:

  # First wave: Implementation
  ./scripts/assault.sh plan wave1
  # Edit .assault/wave1.txt with implementation tasks
  ./scripts/assault.sh launch wave1

  # Monitor (optional)
  ./scripts/assault.sh monitor wave1

  # Assess after completion
  ./scripts/assault.sh assess wave1

  # Fix blockers, then second wave: Tests
  ./scripts/assault.sh plan wave2
  # Edit .assault/wave2.txt with test tasks
  ./scripts/assault.sh launch wave2
  ./scripts/assault.sh assess wave2

WAVE FILE FORMAT:

  # Lines starting with # are comments
  # One task per line

  Implement ComponentA from design/component_a.aiuml
  Implement ComponentB from design/component_b.aiuml
  Implement ComponentC from design/component_c.aiuml
  Write tests for ComponentA
  Write tests for ComponentB

TACTICAL SCENARIOS:

  SCENARIO 1: Full Feature Implementation
    Wave 1: Implement all components (5-10 agents)
    Wave 2: Write all tests (5-10 agents)
    Wave 3: Documentation (3-5 agents)

  SCENARIO 2: Rapid Prototyping
    Wave 1: Quick implementations (loose specs)
    Assess: Identify what works
    Wave 2: Refine successful patterns

  SCENARIO 3: Bug Fixing Assault
    Wave 1: Fix all known bugs (parallel)
    Assess: Which bugs resolved
    Wave 2: Regression tests for fixes

NOTES:
  - Each wave file stored in .assault/ directory
  - Task status saved in .assault/<wave>-status.json
  - Agents follow implementer-agent rules from .clinerules
  - Zero context cost - all agents run independently

EOF
}

# =============================================================================
# MAIN
# =============================================================================

case "${1:-help}" in
    plan)
        cmd_plan
        ;;
    launch|go)
        cmd_launch
        ;;
    monitor|watch)
        cmd_monitor
        ;;
    assess|report)
        cmd_assess
        ;;
    help|--help|-h)
        cmd_help
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run: ./scripts/assault.sh help"
        exit 1
        ;;
esac
