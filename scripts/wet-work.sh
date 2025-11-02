#!/bin/bash
# WET WORK - Target Elimination Protocol
# Covert bug elimination operations

set -e

OPERATIONS_DIR=".operations"
TARGETS_FILE="$OPERATIONS_DIR/targets.txt"
MISSION_LOG="$OPERATIONS_DIR/mission-log.txt"
ASSET_STATUS="$OPERATIONS_DIR/asset-status.json"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

mkdir -p "$OPERATIONS_DIR"

# =============================================================================
# DISPLAY FUNCTIONS
# =============================================================================

show_banner() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║              🕵️  WET WORK - ELIMINATION PROTOCOL 🕵️           ║
║                                                               ║
║                  "Bugs don't just disappear.                  ║
║                   Someone makes them disappear."              ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
}

show_classification() {
    echo -e "${DIM}CLASSIFICATION: TOP SECRET // NOFORN${NC}"
    echo -e "${DIM}HANDLER CLEARANCE REQUIRED${NC}"
    echo ""
}

assess_threat() {
    local count=$1
    echo ""
    if [ "$count" -lt 5 ]; then
        echo -e "${GREEN}THREAT LEVEL: MINIMAL${NC}"
        echo "Recommend: Single operative, surgical approach"
    elif [ "$count" -lt 15 ]; then
        echo -e "${YELLOW}THREAT LEVEL: ELEVATED${NC}"
        echo "Recommend: Small team deployment, coordinated elimination"
    elif [ "$count" -lt 30 ]; then
        echo -e "${RED}THREAT LEVEL: HIGH${NC}"
        echo "Recommend: Full team activation, parallel operations"
    else
        echo -e "${RED}${BOLD}THREAT LEVEL: CRITICAL${NC}"
        echo "Recommend: All-asset deployment, maximum authorization"
    fi
    echo ""
}

# =============================================================================
# OPERATION COMMANDS
# =============================================================================

cmd_intel() {
    show_banner
    show_classification
    echo -e "${CYAN}📋 INTELLIGENCE GATHERING${NC}"
    echo "Identifying elimination targets..."
    echo ""

    if [ -f "$TARGETS_FILE" ]; then
        echo -e "${YELLOW}⚠️  Existing target dossier detected${NC}"
        echo ""
        cat -n "$TARGETS_FILE"
        echo ""
        read -p "Clear existing targets and compile new dossier? (y/N): " confirm
        if [[ ! $confirm =~ ^[Yy]$ ]]; then
            echo "Maintaining existing target list"
            return
        fi
    fi

    cat > "$TARGETS_FILE" << 'TARGETS'
# TARGET ELIMINATION DOSSIER
# CLASSIFICATION: TOP SECRET
#
# One target per line. Format: [PRIORITY] Eliminate bug #ID: Description
#
# PRIORITY LEVELS:
# [CRITICAL] - System compromised, immediate threat
# [HIGH]     - Major capability loss
# [MEDIUM]   - Operational degradation
# [LOW]      - Minor nuisance
#
# EXAMPLES:
# [CRITICAL] Eliminate bug #101: Null pointer causes data loss in save()
# [HIGH] Eliminate bug #102: Race condition exposes sensitive data
# [MEDIUM] Eliminate bug #103: Type error prevents feature usage
# [LOW] Eliminate bug #104: Cosmetic issue in error messages
#
# TARGETS FOLLOW:

TARGETS

    echo -e "${GREEN}✅ Target dossier created: $TARGETS_FILE${NC}"
    echo ""
    echo "HANDLER INSTRUCTIONS:"
    echo "  1. Edit $TARGETS_FILE"
    echo "  2. Add elimination targets (one per line)"
    echo "  3. Authorize operation: ./scripts/wet-work.sh execute"
    echo ""
}

cmd_execute() {
    show_banner
    show_classification
    echo -e "${CYAN}🎯 AUTHORIZING ELIMINATION OPERATIONS${NC}"
    echo ""

    if [ ! -f "$TARGETS_FILE" ]; then
        echo -e "${RED}❌ No target dossier found${NC}"
        echo "Run intelligence gathering first: ./scripts/wet-work.sh intel"
        exit 1
    fi

    # Parse targets
    mapfile -t targets < <(grep -v '^#' "$TARGETS_FILE" | grep -v '^[[:space:]]*$')

    if [ ${#targets[@]} -eq 0 ]; then
        echo -e "${RED}❌ No targets identified${NC}"
        echo "Edit $TARGETS_FILE and add elimination targets"
        exit 1
    fi

    echo -e "${BOLD}TARGETS IDENTIFIED: ${#targets[@]}${NC}"
    assess_threat ${#targets[@]}

    echo "═══════════════════════════════════════════════════════════"
    echo -e "${CYAN}OPERATIONAL BRIEFING${NC}"
    echo "═══════════════════════════════════════════════════════════"
    for i in "${!targets[@]}"; do
        target="${targets[$i]}"
        # Color code by priority
        if [[ "$target" =~ \[CRITICAL\] ]]; then
            echo -e "${RED}[$(printf "%02d" $((i+1)))]${NC} $target"
        elif [[ "$target" =~ \[HIGH\] ]]; then
            echo -e "${YELLOW}[$(printf "%02d" $((i+1)))]${NC} $target"
        else
            echo -e "${BLUE}[$(printf "%02d" $((i+1)))]${NC} $target"
        fi
    done
    echo ""

    read -p "HANDLER AUTHORIZATION REQUIRED (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "Operation aborted by Handler"
        exit 0
    fi

    echo ""
    echo -e "${RED}${BOLD}🔒 AUTHORIZATION CONFIRMED${NC}"
    echo -e "${RED}${BOLD}🔒 DEPLOYING ELIMINATION ASSETS${NC}"
    echo ""

    # Log operation
    {
        echo "═══════════════════════════════════════════════════════════"
        echo "WET WORK OPERATION: $(date)"
        echo "HANDLER: $(whoami)"
        echo "═══════════════════════════════════════════════════════════"
        echo "TARGETS: ${#targets[@]}"
        echo ""
    } > "$MISSION_LOG"

    # Deploy assets
    for i in "${!targets[@]}"; do
        target="${targets[$i]}"
        asset_id=$(printf "ASSET-%03d" $((i+1)))

        echo -e "${MAGENTA}🕵️  $asset_id deploying...${NC}"
        echo -e "${DIM}   Mission: $target${NC}"

        # Strip priority tags for agent
        clean_target=$(echo "$target" | sed 's/^\[CRITICAL\] //; s/^\[HIGH\] //; s/^\[MEDIUM\] //; s/^\[LOW\] //')

        # Deploy asset
        cline "$clean_target. Follow implementer-agent rules. Verify elimination with tests. Report: target status." --yolo --oneshot &

        # Log deployment
        echo "$asset_id: $target" >> "$MISSION_LOG"

        sleep 0.5
    done

    echo ""
    echo -e "${GREEN}${BOLD}✅ ${#targets[@]} ASSETS DEPLOYED${NC}"
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo -e "${YELLOW}ASSETS IN THE FIELD - MAINTAIN OPERATIONAL SECURITY${NC}"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "HANDLER OPTIONS:"
    echo "  Monitor:  ./scripts/wet-work.sh sitrep"
    echo "  Debrief:  ./scripts/wet-work.sh debrief"
    echo ""
}

cmd_sitrep() {
    show_banner
    show_classification
    echo -e "${CYAN}📊 SITUATION REPORT${NC}"
    echo "Status as of: $(date '+%H:%M:%S %Z')"
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo -e "${CYAN}ASSET STATUS${NC}"
    echo "═══════════════════════════════════════════════════════════"

    cline task list

    echo ""
    echo -e "${DIM}Classified information above${NC}"
    echo ""

    if [[ "${1}" == "--watch" ]]; then
        echo -e "${YELLOW}Entering continuous monitoring mode...${NC}"
        echo ""
        while true; do
            sleep 30
            clear
            show_banner
            show_classification
            echo -e "${CYAN}📊 SITUATION REPORT (AUTO-REFRESH)${NC}"
            echo "Status as of: $(date '+%H:%M:%S %Z')"
            echo ""
            cline task list
            echo ""
            echo -e "${YELLOW}Next update in 30s... (Ctrl+C to exit)${NC}"
        done
    fi
}

cmd_debrief() {
    show_banner
    show_classification
    echo -e "${CYAN}📋 AFTER-ACTION DEBRIEF${NC}"
    echo ""

    if [ -f "$MISSION_LOG" ]; then
        echo "═══════════════════════════════════════════════════════════"
        echo -e "${CYAN}MISSION PARAMETERS${NC}"
        echo "═══════════════════════════════════════════════════════════"
        cat "$MISSION_LOG"
        echo ""
    fi

    echo "═══════════════════════════════════════════════════════════"
    echo -e "${CYAN}ASSET REPORTING${NC}"
    echo "═══════════════════════════════════════════════════════════"
    cline task list
    echo ""

    echo "═══════════════════════════════════════════════════════════"
    echo -e "${CYAN}ELIMINATION STATUS${NC}"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo -e "${GREEN}✅ CONFIRMED ELIMINATION${NC} - Target neutralized, verified"
    echo -e "${YELLOW}⚠️  ASSET COMPROMISED${NC}    - Mission incomplete, extraction needed"
    echo -e "${RED}❌ TARGET SURVIVED${NC}      - Elimination failed, Handler intervention required"
    echo ""
    echo "HANDLER ACTIONS:"
    echo "  Review details: cline task view <task-id>"
    echo "  Extract asset:  ./scripts/extraction.sh <task-id>"
    echo "  Declass docs:   Document lessons learned"
    echo ""
    echo "OPERATIONAL SECURITY:"
    echo "  Compromised assets should be debriefed"
    echo "  Failed eliminations escalate to Handler + Analyst (You + Claude)"
    echo "  Update protocols based on lessons learned"
    echo ""
}

cmd_burn() {
    show_banner
    show_classification
    echo -e "${RED}${BOLD}🔥 BURN PROTOCOL${NC}"
    echo ""
    echo -e "${YELLOW}WARNING: This will terminate all active operations and purge mission data${NC}"
    echo ""
    read -p "Confirm burn protocol activation (type BURN): " confirm
    if [[ "$confirm" != "BURN" ]]; then
        echo "Protocol cancelled"
        exit 0
    fi

    echo ""
    echo -e "${RED}🔥 Burning mission data...${NC}"

    if [ -d "$OPERATIONS_DIR" ]; then
        # Archive before burning
        archive_name="burned-$(date +%Y%m%d-%H%M%S).tar.gz"
        tar -czf "$archive_name" "$OPERATIONS_DIR" 2>/dev/null || true
        echo "  Archived to: $archive_name"

        rm -rf "$OPERATIONS_DIR"
        echo "  Mission data purged"
    fi

    echo ""
    echo -e "${GREEN}✅ Burn complete. All traces eliminated.${NC}"
    echo ""
}

cmd_help() {
    show_banner
    show_classification
    cat << 'EOF'

OPERATIONAL COMMANDS:
  intel       Gather intelligence, identify targets
  execute     Deploy assets, authorize eliminations
  sitrep      Situation report (current asset status)
  debrief     After-action debrief (mission results)
  burn        Emergency protocol (purge all mission data)
  help        Display this operations manual

STANDARD OPERATION PROCEDURE:

  ┌───────────────────────────────────────────────────────┐
  │ 1. INTEL    - Identify targets                        │
  │ 2. EXECUTE  - Deploy elimination assets               │
  │ 3. SITREP   - Monitor asset status (optional)         │
  │ 4. DEBRIEF  - Review elimination confirmations        │
  │ 5. EXTRACT  - Handler intervention for compromised    │
  └───────────────────────────────────────────────────────┘

MISSION EXAMPLES:

  # Standard elimination operation
  ./scripts/wet-work.sh intel
  # Edit .operations/targets.txt with bugs to eliminate
  ./scripts/wet-work.sh execute

  # Monitor active operations
  ./scripts/wet-work.sh sitrep
  ./scripts/wet-work.sh sitrep --watch  # Continuous monitoring

  # After-action review
  ./scripts/wet-work.sh debrief

  # Emergency shutdown
  ./scripts/wet-work.sh burn

TARGET DOSSIER FORMAT:

  Edit .operations/targets.txt:

  [CRITICAL] Eliminate bug #101: Null pointer in save()
  [HIGH] Eliminate bug #102: Race condition exposes data
  [MEDIUM] Eliminate bug #103: Type error blocks feature
  [LOW] Eliminate bug #104: Cosmetic error message

  Priority levels guide asset allocation and handler attention.

THREAT ASSESSMENT:

  MINIMAL (1-4)    - Single operative, surgical
  ELEVATED (5-14)  - Small team, coordinated
  HIGH (15-29)     - Full team, parallel ops
  CRITICAL (30+)   - All assets, maximum authorization

ASSET BEHAVIOR:

  - Each asset assigned ONE target
  - Assets operate independently (zero context to Handler)
  - Assets verify elimination with tests
  - Assets report status upon mission completion
  - Handler reviews and debriefs all assets

OPERATIONAL SECURITY:

  - Mission data stored in .operations/ (add to .gitignore)
  - Use burn protocol before repo commits if sensitive
  - Failed eliminations escalate to Handler + Analyst
  - Document lessons learned for protocol improvements

INTEGRATION WITH OTHER OPERATIONS:

  - Deep Cover: Background improvement ops
  - Black Ops: Covert refactoring missions
  - Wet Work: Target elimination (YOU ARE HERE)
  - Sleeper Cell: Overnight autonomous operations

REMEMBER:

  "The bug you see is not the threat.
   The bug you don't see is eliminated before dawn."
   - The Handler's Creed

EOF
}

# =============================================================================
# MAIN
# =============================================================================

case "${1:-help}" in
    intel|recon|targets)
        cmd_intel
        ;;
    execute|go|deploy)
        cmd_execute
        ;;
    sitrep|status|monitor)
        cmd_sitrep "${2}"
        ;;
    debrief|report|after-action)
        cmd_debrief
        ;;
    burn|purge|destroy)
        cmd_burn
        ;;
    help|--help|-h)
        cmd_help
        ;;
    *)
        echo "Unknown command: $1"
        echo ""
        show_banner
        echo ""
        echo "Run: ./scripts/wet-work.sh help"
        exit 1
        ;;
esac
