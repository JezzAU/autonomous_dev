#!/bin/bash
# AIR SUPPORT - Bug Extermination Protocol
# When you've got a bug infestation, call in the heavy artillery!

set -e

MISSION_DIR=".air-support"
TARGETS_FILE="$MISSION_DIR/targets.txt"
BATTLE_LOG="$MISSION_DIR/battle-log.txt"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

mkdir -p "$MISSION_DIR"

# =============================================================================
# TACTICAL DISPLAYS
# =============================================================================

show_banner() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║        🚁 AIR SUPPORT - BUG EXTERMINATION PROTOCOL 🚁        ║
║                                                               ║
║              "No bug survives contact with agents"            ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
}

show_threat_level() {
    local count=$1
    echo ""
    if [ "$count" -lt 5 ]; then
        echo -e "${GREEN}THREAT LEVEL: LOW${NC} - Surgical strike recommended"
    elif [ "$count" -lt 15 ]; then
        echo -e "${YELLOW}THREAT LEVEL: MODERATE${NC} - Air support authorized"
    else
        echo -e "${RED}THREAT LEVEL: CRITICAL${NC} - CARPET BOMBING ENGAGED"
    fi
    echo ""
}

# =============================================================================
# MISSION COMMANDS
# =============================================================================

cmd_recon() {
    show_banner
    echo -e "${CYAN}📡 RECONNAISSANCE MODE${NC}"
    echo "Scanning for bug targets..."
    echo ""

    if [ -f "$TARGETS_FILE" ]; then
        echo -e "${YELLOW}⚠️  Existing targets detected!${NC}"
        echo ""
        cat -n "$TARGETS_FILE"
        echo ""
        read -p "Clear existing targets and start fresh? (y/N): " confirm
        if [[ ! $confirm =~ ^[Yy]$ ]]; then
            echo "Maintaining existing target list"
            return
        fi
    fi

    cat > "$TARGETS_FILE" << 'TARGETS'
# BUG EXTERMINATION TARGET LIST
# One bug per line. Format: Fix bug #123: Description
#
# PRIORITY LEVELS (optional prefix):
# [P0] Critical - System down
# [P1] High - Major feature broken
# [P2] Medium - Minor feature issues
# [P3] Low - Nice to have fixes
#
# EXAMPLES:
# [P0] Fix bug #101: Null pointer exception in StorageManager.save()
# [P1] Fix bug #102: Race condition causes data loss in CacheLayer
# [P2] Fix bug #103: Type error in ValidationEngine
# Fix bug #104: Typo in error message
#
# ADD YOUR TARGETS BELOW:

TARGETS

    echo -e "${GREEN}✅ Target acquisition file created: $TARGETS_FILE${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Edit $TARGETS_FILE"
    echo "  2. Add your bug targets (one per line)"
    echo "  3. Run: ./scripts/air-support.sh strike"
}

cmd_strike() {
    show_banner
    echo -e "${CYAN}💣 INITIATING AIR STRIKE${NC}"
    echo ""

    if [ ! -f "$TARGETS_FILE" ]; then
        echo -e "${RED}❌ No targets file found!${NC}"
        echo "Run reconnaissance first: ./scripts/air-support.sh recon"
        exit 1
    fi

    # Parse targets (skip comments and empty lines)
    mapfile -t bugs < <(grep -v '^#' "$TARGETS_FILE" | grep -v '^[[:space:]]*$')

    if [ ${#bugs[@]} -eq 0 ]; then
        echo -e "${RED}❌ No targets identified${NC}"
        echo "Edit $TARGETS_FILE and add bug targets"
        exit 1
    fi

    echo -e "${BOLD}TARGET COUNT: ${#bugs[@]} bugs${NC}"
    show_threat_level ${#bugs[@]}

    echo "═══════════════════════════════════════"
    echo -e "${CYAN}MISSION BRIEFING${NC}"
    echo "═══════════════════════════════════════"
    for i in "${!bugs[@]}"; do
        echo -e "${BLUE}[$((i+1))]${NC} ${bugs[$i]}"
    done
    echo ""

    read -p "AUTHORIZE AIR STRIKE? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "Mission aborted"
        exit 0
    fi

    echo ""
    echo -e "${RED}${BOLD}🚨 AIR STRIKE AUTHORIZED 🚨${NC}"
    echo ""
    echo "Deploying agents..."

    # Log mission start
    {
        echo "═══════════════════════════════════════"
        echo "AIR SUPPORT MISSION: $(date)"
        echo "═══════════════════════════════════════"
        echo "Targets: ${#bugs[@]}"
    } > "$BATTLE_LOG"

    # Launch extermination agents
    for i in "${!bugs[@]}"; do
        bug="${bugs[$i]}"
        agent_num=$((i+1))

        echo -e "${MAGENTA}🚁 Agent $agent_num deploying...${NC} $bug"

        # Strip priority tags for cleaner task
        clean_bug=$(echo "$bug" | sed 's/^\[P[0-3]\] //')

        # Launch agent
        cline "$clean_bug. Follow implementer-agent rules. Run tests to verify fix." --yolo --oneshot &

        # Log deployment
        echo "Agent $agent_num: $bug" >> "$BATTLE_LOG"

        sleep 0.5  # Stagger deployment
    done

    echo ""
    echo -e "${GREEN}${BOLD}✅ ${#bugs[@]} EXTERMINATION AGENTS DEPLOYED${NC}"
    echo ""
    echo "═══════════════════════════════════════"
    echo -e "${YELLOW}AGENTS IN FLIGHT - STAND BY${NC}"
    echo "═══════════════════════════════════════"
    echo ""
    echo "Monitor:  ./scripts/air-support.sh sitrep"
    echo "Assess:   ./scripts/air-support.sh damage-report"
    echo ""
}

cmd_sitrep() {
    show_banner
    echo -e "${CYAN}📊 SITUATION REPORT${NC}"
    echo "Last update: $(date '+%H:%M:%S')"
    echo ""
    echo "═══════════════════════════════════════"
    echo -e "${CYAN}ACTIVE OPERATIONS${NC}"
    echo "═══════════════════════════════════════"

    cline task list

    echo ""
    echo -e "${YELLOW}Refreshing... (Ctrl+C to stop)${NC}"
    echo ""

    # Auto-refresh mode
    if [[ "${1}" == "--watch" ]]; then
        while true; do
            sleep 30
            clear
            show_banner
            echo -e "${CYAN}📊 SITUATION REPORT (AUTO-REFRESH)${NC}"
            echo "Last update: $(date '+%H:%M:%S')"
            echo ""
            cline task list
            echo ""
            echo -e "${YELLOW}Next refresh in 30s... (Ctrl+C to stop)${NC}"
        done
    fi
}

cmd_damage_report() {
    show_banner
    echo -e "${CYAN}🎯 BATTLE DAMAGE ASSESSMENT${NC}"
    echo ""

    # Show mission log if exists
    if [ -f "$BATTLE_LOG" ]; then
        echo "═══════════════════════════════════════"
        echo -e "${CYAN}MISSION LOG${NC}"
        echo "═══════════════════════════════════════"
        cat "$BATTLE_LOG"
        echo ""
    fi

    echo "═══════════════════════════════════════"
    echo -e "${CYAN}AGENT STATUS${NC}"
    echo "═══════════════════════════════════════"
    cline task list
    echo ""

    echo "═══════════════════════════════════════"
    echo -e "${CYAN}CASUALTY ASSESSMENT${NC}"
    echo "═══════════════════════════════════════"
    echo ""
    echo -e "${GREEN}✅ CONFIRMED KILLS${NC}  - Bug eliminated, tests passing"
    echo -e "${YELLOW}⚠️  WOUNDED${NC}         - Partial fix, needs cleanup"
    echo -e "${RED}❌ SURVIVED${NC}        - Bug still active, needs heavy weapons"
    echo ""
    echo "Detailed review:"
    echo "  cline task view <task-id>  # Inspect each agent's report"
    echo ""
    echo "Next steps:"
    echo "  1. Review each agent's damage report"
    echo "  2. Survivors → Escalate to You + Claude (Tier 1)"
    echo "  3. Document lessons learned"
    echo "  4. Plan cleanup wave if needed"
    echo ""
}

cmd_carpet_bomb() {
    show_banner
    echo -e "${RED}${BOLD}💣💣💣 CARPET BOMBING MODE 💣💣💣${NC}"
    echo ""
    echo -e "${YELLOW}WARNING: This will launch agents for EVERY bug found in your codebase!${NC}"
    echo ""
    echo "Scanning for bugs..."
    echo ""

    # Look for common bug indicators
    total_agents=0

    # TODO/FIXME/BUG markers
    if command -v rg &> /dev/null; then
        echo "Scanning for TODO/FIXME/BUG markers..."
        bug_count=$(rg -i "TODO|FIXME|BUG|HACK" --type py 2>/dev/null | wc -l || echo "0")
        echo "  Found: $bug_count potential targets"
        total_agents=$((total_agents + bug_count))
    fi

    # Failed tests
    if [ -d "tests" ]; then
        echo "Checking test suite..."
        # This would need actual test runner integration
        echo "  (Manual test review recommended)"
    fi

    echo ""
    echo -e "${RED}${BOLD}ESTIMATED DEPLOYMENT: $total_agents agents${NC}"
    show_threat_level $total_agents

    echo -e "${YELLOW}This is an AGGRESSIVE operation!${NC}"
    echo ""
    read -p "CONFIRM CARPET BOMBING? (type YES): " confirm
    if [[ "$confirm" != "YES" ]]; then
        echo "Mission aborted - wise choice for precision operations"
        echo "Consider: ./scripts/air-support.sh recon"
        exit 0
    fi

    echo ""
    echo -e "${RED}💣 DEPLOYMENT AUTHORIZED 💣${NC}"
    echo "Generating target list from codebase..."

    # Generate targets from codebase markers
    {
        echo "# AUTO-GENERATED TARGETS - Carpet Bombing Mission"
        echo "# Generated: $(date)"
        echo ""
        if command -v rg &> /dev/null; then
            rg -i "TODO|FIXME|BUG|HACK" --type py -n 2>/dev/null | while IFS=: read -r file line content; do
                echo "Fix code marker in $file:$line - $content"
            done
        fi
    } > "$TARGETS_FILE"

    echo -e "${GREEN}✅ Targets acquired and locked${NC}"
    echo ""
    read -p "Proceed with strike? (y/N): " confirm2
    if [[ $confirm2 =~ ^[Yy]$ ]]; then
        cmd_strike
    else
        echo "Targets acquired but strike held"
        echo "Review: $TARGETS_FILE"
        echo "Launch: ./scripts/air-support.sh strike"
    fi
}

cmd_help() {
    show_banner
    cat << 'EOF'

MISSION COMMANDS:
  recon           Scout for targets (create target list)
  strike          Deploy extermination agents (parallel attack)
  sitrep          Situation report (current status)
  damage-report   Battle damage assessment (results)
  carpet-bomb     AGGRESSIVE: Auto-target ALL bugs (use with caution!)
  help            Show this tactical manual

TYPICAL ENGAGEMENT:

  ┌──────────────────────────────────────────────────┐
  │ 1. RECON     - Identify targets                  │
  │ 2. STRIKE    - Deploy parallel agents            │
  │ 3. SITREP    - Monitor operation                 │
  │ 4. DAMAGE    - Assess results                    │
  │ 5. CLEANUP   - Mop up survivors with Tier 1      │
  └──────────────────────────────────────────────────┘

EXAMPLES:

  # Standard bug extermination
  ./scripts/air-support.sh recon
  # Edit .air-support/targets.txt with your bugs
  ./scripts/air-support.sh strike

  # Monitor active operation
  ./scripts/air-support.sh sitrep

  # Assess battle damage
  ./scripts/air-support.sh damage-report

  # Nuclear option (all bugs, all at once)
  ./scripts/air-support.sh carpet-bomb

TARGET FORMAT:

  Edit .air-support/targets.txt:

  [P0] Fix bug #101: Critical null pointer in save()
  [P1] Fix bug #102: Race condition causes data loss
  [P2] Fix bug #103: Type error in validation
  Fix bug #104: Typo in error message

  Priority tags [P0-P3] are optional but helpful for triage.

THREAT LEVELS:

  LOW (1-4 bugs)      - Surgical strike, quick operation
  MODERATE (5-14)     - Air support, parallel deployment
  CRITICAL (15+)      - Carpet bombing, massive assault

AGENT BEHAVIOR:

  - Each agent gets ONE bug to exterminate
  - Agents run in parallel (zero context cost!)
  - Agents follow implementer-agent rules
  - Agents run tests to verify kill
  - Review results to confirm bugs eliminated

INTEGRATION:

  Works alongside other tactical patterns:
  - Daily fire-and-forget: Background improvement
  - Assault waves: Feature implementation
  - Air support: Bug extermination (YOU ARE HERE)
  - Autonomous supervisor: Overnight critical work

REMEMBER:

  "The only good bug is a dead bug!"
  - Starship Troopers (adapted for software)

EOF
}

# =============================================================================
# MAIN
# =============================================================================

case "${1:-help}" in
    recon|scout)
        cmd_recon
        ;;
    strike|attack|go)
        cmd_strike
        ;;
    sitrep|status|monitor)
        cmd_sitrep "${2}"
        ;;
    damage-report|damage|assess|report)
        cmd_damage_report
        ;;
    carpet-bomb|nuke|exterminatus)
        cmd_carpet_bomb
        ;;
    help|--help|-h)
        cmd_help
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        show_banner
        echo ""
        echo "Run: ./scripts/air-support.sh help"
        exit 1
        ;;
esac
