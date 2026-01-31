#!/bin/bash
# tool-resume-hook.sh - Clear waiting status after tool completes
# Used by PostToolUse hook

find_session() {
    local project_dir="$1"
    if [ -d "$project_dir/tmp" ]; then
        local latest=$(ls -t "$project_dir"/tmp/*/_status.json 2>/dev/null | head -1)
        if [ -n "$latest" ]; then
            dirname "$latest"
        fi
    fi
}

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
SESSION_DIR=$(find_session "$PROJECT_DIR")

if [ -z "$SESSION_DIR" ] || [ ! -f "$SESSION_DIR/_status.json" ]; then
    exit 0
fi

SCRIPT_DIR="$(dirname "$0")/.."
STATUS_UPDATE="$SCRIPT_DIR/core/status-update.sh"

if [ -f "$STATUS_UPDATE" ]; then
    "$STATUS_UPDATE" "$SESSION_DIR" resume
fi
