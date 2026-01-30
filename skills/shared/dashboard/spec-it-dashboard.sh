#!/bin/bash
# SPEC-IT Real-time Dashboard
# Usage: ./spec-it-dashboard.sh [session-path]
# Example: ./spec-it-dashboard.sh ./tmp/20260130-123456

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Find session path (convert to absolute path)
if [ -n "$1" ]; then
    # Convert to absolute path if relative
    if [[ "$1" = /* ]]; then
        SESSION_PATH="$1"
    else
        SESSION_PATH="$(cd "$1" 2>/dev/null && pwd)" || SESSION_PATH="$1"
    fi
else
    # Auto-detect latest session using absolute paths
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PLUGIN_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
    # Get project directory (parent of plugin's .claude directory)
    PROJECT_DIR="${PLUGIN_DIR%/.claude/*}"
    if [ "$PROJECT_DIR" = "$PLUGIN_DIR" ]; then
        # Fallback: plugin may not be in .claude, search from current directory
        PROJECT_DIR="$(pwd)"
    fi

    # Search for session in project's tmp directory
    SESSION_PATH=$(find "$PROJECT_DIR" -maxdepth 5 -path "*/tmp/*" -name "_status.json" -type f 2>/dev/null | head -1 | xargs dirname 2>/dev/null || echo "")
    if [ -z "$SESSION_PATH" ]; then
        SESSION_PATH=$(find "$PROJECT_DIR" -maxdepth 5 -path "*/tmp/*" -name "_meta.json" -type f 2>/dev/null | head -1 | xargs dirname 2>/dev/null || echo "")
    fi

    # Fallback to current directory search
    if [ -z "$SESSION_PATH" ]; then
        SESSION_PATH=$(find . -maxdepth 3 -name "_status.json" -type f 2>/dev/null | head -1 | xargs dirname 2>/dev/null || echo "")
    fi
    if [ -z "$SESSION_PATH" ]; then
        SESSION_PATH=$(find . -maxdepth 3 -name "_meta.json" -type f 2>/dev/null | head -1 | xargs dirname 2>/dev/null || echo "")
    fi
fi

STATUS_FILE="${SESSION_PATH}/_status.json"
META_FILE="${SESSION_PATH}/_meta.json"

# Progress bar function
progress_bar() {
    local percent=$1
    local width=40
    local filled=$((percent * width / 100))
    local empty=$((width - filled))

    printf "["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] %3d%%" "$percent"
}

# Format duration
format_duration() {
    local seconds=$1
    printf "%02d:%02d:%02d" $((seconds/3600)) $((seconds%3600/60)) $((seconds%60))
}

# Agent status icon
agent_icon() {
    case "$1" in
        "running") echo -e "${GREEN}●${NC}" ;;
        "completed") echo -e "${BLUE}✓${NC}" ;;
        "pending") echo -e "${DIM}○${NC}" ;;
        "error") echo -e "${RED}✗${NC}" ;;
        *) echo -e "${DIM}○${NC}" ;;
    esac
}

# Render dashboard
render_dashboard() {
    clear

    # Check if files exist
    if [ ! -f "$STATUS_FILE" ] && [ ! -f "$META_FILE" ]; then
        echo -e "${YELLOW}Waiting for spec-it session...${NC}"
        echo -e "${DIM}Looking in: ${SESSION_PATH:-current directory}${NC}"
        echo ""
        echo -e "${DIM}Start spec-it in another terminal:${NC}"
        echo -e "  /frontend-skills:spec-it-automation"
        return
    fi

    # Read status
    local session_id phase step progress runtime files_count lines_count
    local start_time current_time

    # Helper function: Convert ISO timestamp to Unix timestamp (macOS compatible)
    iso_to_unix() {
        local iso_ts="$1"
        if [ -z "$iso_ts" ] || [ "$iso_ts" = "null" ] || [ "$iso_ts" = "0" ]; then
            echo 0
            return
        fi
        # Extract datetime part (before +/- timezone)
        local dt_part=$(echo "$iso_ts" | sed 's/[+-][0-9][0-9]:[0-9][0-9]$//' | sed 's/T/ /')
        # Try macOS date format
        date -j -f "%Y-%m-%d %H:%M:%S" "$dt_part" "+%s" 2>/dev/null || \
        # Try Linux date format
        date -d "$iso_ts" "+%s" 2>/dev/null || \
        echo 0
    }

    if [ -f "$STATUS_FILE" ]; then
        session_id=$(jq -r '.sessionId // "unknown"' "$STATUS_FILE" 2>/dev/null || echo "unknown")
        phase=$(jq -r '.currentPhase // 1' "$STATUS_FILE" 2>/dev/null || echo 1)
        step=$(jq -r '.currentStep // "1.1"' "$STATUS_FILE" 2>/dev/null || echo "1.1")
        progress=$(jq -r '.progress // 0' "$STATUS_FILE" 2>/dev/null || echo 0)
        local start_time_iso=$(jq -r '.startTime // ""' "$STATUS_FILE" 2>/dev/null || echo "")
        start_time=$(iso_to_unix "$start_time_iso")
        files_count=$(jq -r '.stats.filesCreated // 0' "$STATUS_FILE" 2>/dev/null || echo 0)
        lines_count=$(jq -r '.stats.linesWritten // 0' "$STATUS_FILE" 2>/dev/null || echo 0)
    elif [ -f "$META_FILE" ]; then
        session_id=$(jq -r '.sessionId // "unknown"' "$META_FILE" 2>/dev/null || echo "unknown")
        phase=$(jq -r '.currentPhase // 1' "$META_FILE" 2>/dev/null || echo 1)
        step=$(jq -r '.currentStep // "1.1"' "$META_FILE" 2>/dev/null || echo "1.1")
        progress=$((phase * 100 / 6))
        local start_time_iso=$(jq -r '.lastCheckpoint // ""' "$META_FILE" 2>/dev/null || echo "")
        start_time=$(iso_to_unix "$start_time_iso")
        files_count=$(find "$SESSION_PATH" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        lines_count=$(find "$SESSION_PATH" -name "*.md" -type f -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' || echo 0)
    fi

    # Ensure progress is a valid number
    if ! [[ "$progress" =~ ^[0-9]+$ ]]; then
        progress=0
    fi

    # Calculate runtime
    current_time=$(date +%s)
    if [ "$start_time" -gt 0 ] 2>/dev/null; then
        runtime=$((current_time - start_time))
    else
        runtime=0
    fi

    # Get phase name
    local phase_name
    case "$phase" in
        1) phase_name="Design Brainstorming" ;;
        2) phase_name="UI Architecture" ;;
        3) phase_name="Critical Review" ;;
        4) phase_name="Test Specification" ;;
        5) phase_name="Final Assembly" ;;
        6) phase_name="Complete" ;;
        *) phase_name="Initializing" ;;
    esac

    # Header
    echo -e "${BOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}║${NC}  ${CYAN}SPEC-IT DASHBOARD${NC}                    Runtime: ${WHITE}$(format_duration $runtime)${NC}  ${BOLD}║${NC}"
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"

    # Session info
    echo -e "${BOLD}║${NC}  Session: ${DIM}${session_id}${NC}"
    echo -e "${BOLD}║${NC}"

    # Progress
    echo -e "${BOLD}║${NC}  Phase: ${WHITE}${phase}/6${NC} - ${CYAN}${phase_name}${NC}"
    echo -e "${BOLD}║${NC}  Step:  ${WHITE}${step}${NC}"
    echo -e "${BOLD}║${NC}  $(progress_bar $progress)"
    echo -e "${BOLD}║${NC}"

    # Agents section
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║${NC}  ${WHITE}AGENTS${NC}"
    echo -e "${BOLD}║${NC}"

    if [ -f "$STATUS_FILE" ]; then
        # Read agents from status file
        local agents_json=$(jq -r '.agents // []' "$STATUS_FILE" 2>/dev/null)
        if [ "$agents_json" != "[]" ] && [ -n "$agents_json" ]; then
            echo "$agents_json" | jq -r '.[] | "\(.name)|\(.status)|\(.duration // 0)"' 2>/dev/null | while IFS='|' read -r name status duration; do
                local icon=$(agent_icon "$status")
                local status_color
                case "$status" in
                    "running") status_color="${GREEN}" ;;
                    "completed") status_color="${BLUE}" ;;
                    "error") status_color="${RED}" ;;
                    *) status_color="${DIM}" ;;
                esac
                printf "${BOLD}║${NC}  %s %-25s ${status_color}[%-9s]${NC}" "$icon" "$name" "$status"
                if [ "$duration" -gt 0 ] 2>/dev/null; then
                    printf "  %s" "$(format_duration $duration)"
                fi
                echo ""
            done
        else
            echo -e "${BOLD}║${NC}  ${DIM}No agents running${NC}"
        fi
    else
        echo -e "${BOLD}║${NC}  ${DIM}Agent tracking not available${NC}"
    fi

    echo -e "${BOLD}║${NC}"

    # Stats section - calculate from actual files
    local actual_files=$(find "$SESSION_PATH" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    local actual_lines=$(find "$SESSION_PATH" -name "*.md" -type f -exec cat {} + 2>/dev/null | wc -l | tr -d ' ')

    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║${NC}  ${WHITE}STATS${NC}"
    echo -e "${BOLD}║${NC}"
    echo -e "${BOLD}║${NC}  Files: ${GREEN}${actual_files}${NC} created"
    echo -e "${BOLD}║${NC}  Lines: ${GREEN}${actual_lines}${NC} written"

    # Recent files
    if [ -d "$SESSION_PATH" ]; then
        local recent_files=$(find "$SESSION_PATH" -name "*.md" -type f -mmin -1 2>/dev/null | head -3)
        if [ -n "$recent_files" ]; then
            echo -e "${BOLD}║${NC}"
            echo -e "${BOLD}║${NC}  ${DIM}Recent:${NC}"
            echo "$recent_files" | while read -r f; do
                local fname=$(basename "$f")
                echo -e "${BOLD}║${NC}    ${DIM}+ ${fname}${NC}"
            done
        fi
    fi

    echo -e "${BOLD}║${NC}"
    echo -e "${BOLD}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${DIM}Press Ctrl+C to exit${NC}"
}

# Main loop
echo -e "${CYAN}Starting SPEC-IT Dashboard...${NC}"
echo -e "${DIM}Session path: ${SESSION_PATH:-auto-detect}${NC}"
echo ""

while true; do
    render_dashboard
    sleep 2
done
