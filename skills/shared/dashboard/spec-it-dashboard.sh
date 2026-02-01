#!/bin/bash
# SPEC-IT Real-time Dashboard
# Usage: ./spec-it-dashboard.sh [session-path]
# Example: ./spec-it-dashboard.sh ./.spec-it/20260130-123456/plan

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

    # Search for session in .spec-it directory (new structure)
    SESSION_PATH=$(find "$PROJECT_DIR" -maxdepth 5 -path "*/.spec-it/*/plan" -name "_status.json" -type f 2>/dev/null | head -1 | xargs dirname 2>/dev/null || echo "")
    if [ -z "$SESSION_PATH" ]; then
        SESSION_PATH=$(find "$PROJECT_DIR" -maxdepth 5 -path "*/.spec-it/*/execute" -name "_status.json" -type f 2>/dev/null | head -1 | xargs dirname 2>/dev/null || echo "")
    fi

    # Fallback to current directory search
    if [ -z "$SESSION_PATH" ]; then
        SESSION_PATH=$(find . -maxdepth 5 -path "*/.spec-it/*/plan" -name "_status.json" -type f 2>/dev/null | head -1 | xargs dirname 2>/dev/null || echo "")
    fi
    if [ -z "$SESSION_PATH" ]; then
        SESSION_PATH=$(find . -maxdepth 5 -path "*/.spec-it/*/execute" -name "_status.json" -type f 2>/dev/null | head -1 | xargs dirname 2>/dev/null || echo "")
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

# ASCII art for waiting alert
show_waiting_alert() {
    local msg="$1"
    echo ""
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║${NC}                                                                  ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                    ${BOLD}${YELLOW}██╗${NC}                                         ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                    ${BOLD}${YELLOW}██║${NC}     ${WHITE}USER INPUT REQUIRED${NC}              ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                    ${BOLD}${YELLOW}██║${NC}                                         ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                    ${BOLD}${YELLOW}╚═╝${NC}                                         ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                    ${BOLD}${YELLOW}██╗${NC}                                         ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                    ${BOLD}${YELLOW}╚═╝${NC}                                         ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                                  ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}  ${CYAN}$msg${NC}"
    printf "${YELLOW}║${NC}%*s${YELLOW}║${NC}\n" 66 ""
    echo -e "${YELLOW}║${NC}                                                                  ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}         ${DIM}Please respond in the Claude Code terminal${NC}              ${YELLOW}║${NC}"
    echo -e "${YELLOW}║${NC}                                                                  ${YELLOW}║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
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

    # Check for waiting for user input
    local waiting_for_user=$(jq -r '.waitingForUser // false' "$STATUS_FILE" 2>/dev/null)
    local waiting_message=$(jq -r '.waitingMessage // "Waiting for user input"' "$STATUS_FILE" 2>/dev/null)

    if [ "$waiting_for_user" = "true" ]; then
        show_waiting_alert "$waiting_message"
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

    # Dynamic progress calculation based on folder content or phase
    calculate_progress() {
        local current_mode="$1"
        local current_phase="$2"

        # Execute mode: calculate by phase and completedPhases
        if [ "$current_mode" = "execute" ]; then
            local completed_phases=$(jq -r '.completedPhases | length' "$STATUS_FILE" 2>/dev/null || echo 0)
            local qa_attempts=$(jq -r '.qaAttempts // 0' "$STATUS_FILE" 2>/dev/null || echo 0)

            # Base progress on completed phases (20% each for 5 phases)
            local calc_progress=$((completed_phases * 20))

            # Add partial progress for current phase
            case "$current_phase" in
                1) calc_progress=$((calc_progress + 5)) ;;   # LOAD in progress
                2) calc_progress=$((calc_progress + 10)) ;;  # PLAN in progress
                3) calc_progress=$((calc_progress + 10)) ;;  # EXECUTE in progress
                4) calc_progress=$((calc_progress + 5 + qa_attempts * 3)) ;;  # QA with attempts
                5) calc_progress=$((calc_progress + 10)) ;;  # VALIDATE in progress
            esac

            [ "$calc_progress" -gt 100 ] && calc_progress=100
            echo "$calc_progress"
            return
        fi

        # Spec-it mode: calculate by folder content
        local req_files=$(find "$SESSION_PATH/00-requirements" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        local ch_files=$(find "$SESSION_PATH/01-chapters" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        local scr_files=$(find "$SESSION_PATH/02-screens" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        local comp_files=$(find "$SESSION_PATH/03-components" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        local rev_files=$(find "$SESSION_PATH/04-review" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        local test_files=$(find "$SESSION_PATH/05-tests" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
        local final_files=$(find "$SESSION_PATH/06-final" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')

        local calc_progress=0

        # Detect mode: fast-launch skips chapters, components, review, tests
        local is_fast_launch=0
        if [ "$scr_files" -gt 0 ] && [ "$ch_files" -eq 0 ]; then
            is_fast_launch=1
        fi

        if [ "$is_fast_launch" -eq 1 ]; then
            # Fast-launch mode: Requirements(20%) + Wireframes(70%) + Final(10%)
            [ "$req_files" -gt 0 ] && calc_progress=$((calc_progress + 20))
            [ "$scr_files" -gt 0 ] && calc_progress=$((calc_progress + 10 + scr_files * 4))
            [ "$final_files" -gt 0 ] && calc_progress=100
            [ "$calc_progress" -gt 95 ] && [ "$final_files" -eq 0 ] && calc_progress=95
        else
            # Standard mode: weighted by phase
            [ "$req_files" -gt 0 ] && calc_progress=$((calc_progress + 10))
            [ "$ch_files" -gt 0 ] && calc_progress=$((calc_progress + 15))
            [ "$scr_files" -gt 0 ] && calc_progress=$((calc_progress + 25))
            [ "$comp_files" -gt 0 ] && calc_progress=$((calc_progress + 20))
            [ "$rev_files" -gt 0 ] && calc_progress=$((calc_progress + 15))
            [ "$test_files" -gt 0 ] && calc_progress=$((calc_progress + 10))
            [ "$final_files" -gt 0 ] && calc_progress=100
        fi

        echo "$calc_progress"
    }

    # Calculate runtime
    current_time=$(date +%s)
    if [ "$start_time" -gt 0 ] 2>/dev/null; then
        runtime=$((current_time - start_time))
    else
        runtime=0
    fi

    # Detect mode: spec-it (generation) vs spec-it-execute (implementation)
    local mode="spec-it"
    local total_phases=6
    local mode_label="SPEC-IT"

    # Check for execute mode indicators
    if [ -f "$STATUS_FILE" ]; then
        local spec_source=$(jq -r '.specSource // ""' "$STATUS_FILE" 2>/dev/null)
        local qa_attempts=$(jq -r '.qaAttempts // ""' "$STATUS_FILE" 2>/dev/null)
        if [ -n "$spec_source" ] || [ -n "$qa_attempts" ]; then
            mode="execute"
            total_phases=5
            mode_label="SPEC-IT EXECUTE"
        fi
    fi

    # Also detect by path pattern (new structure: .spec-it/{id}/execute)
    if [[ "$SESSION_PATH" == */execute ]] || [[ "$SESSION_PATH" == */execute/ ]]; then
        mode="execute"
        total_phases=5
        mode_label="SPEC-IT EXECUTE"
    fi

    # Get phase name based on mode
    local phase_name
    if [ "$mode" = "execute" ]; then
        case "$phase" in
            1) phase_name="LOAD" ;;
            2) phase_name="PLAN" ;;
            3) phase_name="EXECUTE" ;;
            4) phase_name="QA" ;;
            5) phase_name="VALIDATE" ;;
            6) phase_name="Complete" ;;
            *) phase_name="Initializing" ;;
        esac
    else
        case "$phase" in
            1) phase_name="Design Brainstorming" ;;
            2) phase_name="UI Architecture" ;;
            3) phase_name="Critical Review" ;;
            4) phase_name="Test Specification" ;;
            5) phase_name="Final Assembly" ;;
            6) phase_name="Complete" ;;
            *) phase_name="Initializing" ;;
        esac
    fi

    # Use _status.json progress if available, otherwise calculate
    local status_progress=$(jq -r '.progress // 0' "$STATUS_FILE" 2>/dev/null || echo 0)
    if [ "$status_progress" -gt 0 ] 2>/dev/null; then
        progress="$status_progress"
    else
        # Fallback: Calculate progress dynamically based on mode
        progress=$(calculate_progress "$mode" "$phase")
    fi

    # Ensure progress is a valid number
    if ! [[ "$progress" =~ ^[0-9]+$ ]]; then
        progress=0
    fi

    # Header
    echo -e "${BOLD}╔══════════════════════════════════════════════════════════════════╗${NC}"
    if [ "$mode" = "execute" ]; then
        echo -e "${BOLD}║${NC}  ${GREEN}${mode_label}${NC}                  Runtime: ${WHITE}$(format_duration $runtime)${NC}  ${BOLD}║${NC}"
    else
        echo -e "${BOLD}║${NC}  ${CYAN}${mode_label} DASHBOARD${NC}                    Runtime: ${WHITE}$(format_duration $runtime)${NC}  ${BOLD}║${NC}"
    fi
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"

    # Session info
    echo -e "${BOLD}║${NC}  Session: ${DIM}${session_id}${NC}"
    echo -e "${BOLD}║${NC}"

    # Progress
    echo -e "${BOLD}║${NC}  Phase: ${WHITE}${phase}/${total_phases}${NC} - ${CYAN}${phase_name}${NC}"
    echo -e "${BOLD}║${NC}  Step:  ${WHITE}${step}${NC}"
    echo -e "${BOLD}║${NC}  $(progress_bar $progress)"
    echo -e "${BOLD}║${NC}"

    # Agents section with summary
    echo -e "${BOLD}╠══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BOLD}║${NC}  ${WHITE}AGENTS${NC}"
    echo -e "${BOLD}║${NC}"

    if [ -f "$STATUS_FILE" ]; then
        local agents_json=$(jq -r '.agents // []' "$STATUS_FILE" 2>/dev/null)

        if [ "$agents_json" != "[]" ] && [ -n "$agents_json" ]; then
            # Count by status
            local running_count=$(echo "$agents_json" | jq -r '[.[] | select(.status == "running")] | length' 2>/dev/null || echo 0)
            local completed_count=$(echo "$agents_json" | jq -r '[.[] | select(.status == "completed")] | length' 2>/dev/null || echo 0)
            local error_count=$(echo "$agents_json" | jq -r '[.[] | select(.status == "error")] | length' 2>/dev/null || echo 0)
            local total_count=$(echo "$agents_json" | jq -r 'length' 2>/dev/null || echo 0)

            # Summary line
            printf "${BOLD}║${NC}  ${DIM}Total:${NC} %d  " "$total_count"
            [ "$running_count" -gt 0 ] && printf "${GREEN}●${NC} %d running  " "$running_count"
            [ "$completed_count" -gt 0 ] && printf "${BLUE}✓${NC} %d done  " "$completed_count"
            [ "$error_count" -gt 0 ] && printf "${RED}✗${NC} %d error" "$error_count"
            echo ""
            echo -e "${BOLD}║${NC}"

            # Show running agents first (highlighted)
            echo "$agents_json" | jq -r '.[] | select(.status == "running") | "\(.name)|\(.status)|\(.duration // "-")"' 2>/dev/null | while IFS='|' read -r name status duration; do
                echo -e "${BOLD}║${NC}  ${GREEN}▶${NC} ${WHITE}${name}${NC} ${GREEN}[running]${NC}"
            done

            # Show recent completed/error agents (last 3)
            echo "$agents_json" | jq -r '[.[] | select(.status != "running")] | reverse | .[0:3] | .[] | "\(.name)|\(.status)|\(.duration // "-")"' 2>/dev/null | while IFS='|' read -r name status duration; do
                local icon status_color
                if [ "$status" = "completed" ]; then
                    icon="${BLUE}✓${NC}"
                    status_color="${DIM}"
                else
                    icon="${RED}✗${NC}"
                    status_color="${RED}"
                fi
                echo -e "${BOLD}║${NC}  ${icon} ${status_color}${name}${NC} ${DIM}(${duration})${NC}"
            done
        else
            echo -e "${BOLD}║${NC}  ${DIM}No agents tracked yet${NC}"
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
