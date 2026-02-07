#!/bin/bash
# tool-waiting-hook.sh - Set waiting status when tool requires permission
# Used by PreToolUse hook

find_session() {
    local project_dir="$1"
    if [ ! -d "$project_dir/.spec-it" ]; then return; fi

    local candidates=()
    for f in "$project_dir"/.spec-it/*/plan/_status.json; do
        [ -f "$f" ] && candidates+=("$f")
    done
    for f in "$project_dir"/.spec-it/*/execute/_status.json; do
        [ -f "$f" ] && candidates+=("$f")
    done

    if [ ${#candidates[@]} -eq 0 ]; then return; fi

    local latest=$(ls -t "${candidates[@]}" 2>/dev/null | head -1)
    if [ -n "$latest" ]; then
        dirname "$latest"
    fi
}

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
SESSION_DIR=$(find_session "$PROJECT_DIR")

if [ -z "$SESSION_DIR" ] || [ ! -f "$SESSION_DIR/_status.json" ]; then
    exit 0
fi

# Get tool name from stdin JSON if available
TOOL_NAME="Tool"
if read -t 0.1 INPUT; then
    if [[ "$INPUT" =~ \"tool_name\":\"([^\"]+)\" ]]; then
        TOOL_NAME="${BASH_REMATCH[1]}"
    fi
fi

SCRIPT_DIR="$(dirname "$0")/.."
STATUS_UPDATE="$SCRIPT_DIR/core/status-update.sh"

if [ -f "$STATUS_UPDATE" ]; then
    "$STATUS_UPDATE" "$SESSION_DIR" waiting "Waiting for permission: $TOOL_NAME"
fi
