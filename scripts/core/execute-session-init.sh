#!/bin/bash
# execute-session-init.sh - Initialize spec-it-execute session with dashboard auto-launch
# Usage: execute-session-init.sh [sessionId] [specFolder] [workDir]
# Returns: SESSION_ID:{id}, SESSION_DIR:{path}

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SESSION_ID="${1:-$(date +%Y%m%d-%H%M%S)}"
SPEC_FOLDER="${2:-}"
WORK_DIR="${3:-$(pwd)}"

# Convert to absolute paths
if [[ "$WORK_DIR" != /* ]]; then
    WORK_DIR="$(cd "$WORK_DIR" 2>/dev/null && pwd)" || WORK_DIR="$(pwd)"
fi

if [[ -n "$SPEC_FOLDER" && "$SPEC_FOLDER" != /* ]]; then
    SPEC_FOLDER="$(cd "$WORK_DIR" && cd "$SPEC_FOLDER" 2>/dev/null && pwd)" || SPEC_FOLDER="$WORK_DIR/$SPEC_FOLDER"
fi

# Session state goes to .spec-it/{sessionId}/execute/
SESSION_DIR="$WORK_DIR/.spec-it/$SESSION_ID/execute"
# Shared runtime log at session level
RUNTIME_LOG_DIR="$WORK_DIR/.spec-it/$SESSION_ID"

echo "DEBUG:WORK_DIR=$WORK_DIR"
echo "DEBUG:SESSION_DIR=$SESSION_DIR"
echo "DEBUG:SPEC_FOLDER=$SPEC_FOLDER"

# Create folder structure
mkdir -p "$SESSION_DIR"/{plans,logs,reviews,screenshots}
mkdir -p "$RUNTIME_LOG_DIR"

# Get parent terminal info for 'r' key feature
get_parent_terminal_info() {
  local os_type=$(uname)
  local parent_pid=$$
  local parent_tty=$(tty 2>/dev/null || echo "")
  local window_id=""

  if [ "$os_type" = "Darwin" ]; then
    # macOS: Try to get Terminal window ID via AppleScript
    window_id=$(osascript -e 'tell application "Terminal" to id of front window' 2>/dev/null || echo "")
  fi

  echo "{\"pid\": \"$parent_pid\", \"tty\": \"$parent_tty\", \"windowId\": \"$window_id\", \"os\": \"$os_type\"}"
}

PARENT_TERMINAL_INFO=$(get_parent_terminal_info)
CURRENT_TIME=$(date -Iseconds)

# Create _meta.json (unified: includes resume state)
cat > "$SESSION_DIR/_meta.json" << EOF
{
  "sessionId": "$SESSION_ID",
  "mode": "execute",
  "specSource": "$SPEC_FOLDER",
  "workDir": "$WORK_DIR",
  "status": "in_progress",
  "currentPhase": 1,
  "currentStep": "1.1",
  "completedPhases": [],
  "completedTasks": [],
  "completedSteps": [],
  "startedAt": "$CURRENT_TIME",
  "lastCheckpoint": "$CURRENT_TIME",
  "canResume": true,
  "livePreview": false,
  "qaAttempts": 0,
  "maxQaAttempts": 5,
  "mirrorAttempts": 0,
  "maxMirrorAttempts": 5,
  "lastMirrorReport": { "matchCount": 0, "missingCount": 0, "overCount": 0 },
  "coverageAttempts": 0,
  "maxCoverageAttempts": 5,
  "targetCoverage": 95,
  "currentCoverage": { "statements": 0, "branches": 0, "functions": 0, "lines": 0 },
  "scenarioAttempts": 0,
  "maxScenarioAttempts": 5,
  "scenarioResults": { "total": 0, "passed": 0, "failed": 0 },
  "parentTerminal": $PARENT_TERMINAL_INFO
}
EOF

# Create _status.json (for dashboard display)
cat > "$SESSION_DIR/_status.json" << EOF
{
  "sessionId": "$SESSION_ID",
  "mode": "execute",
  "specSource": "$SPEC_FOLDER",
  "status": "in_progress",
  "currentPhase": 1,
  "currentStep": "1.1",
  "completedPhases": [],
  "completedTasks": [],
  "qaAttempts": 0,
  "maxQaAttempts": 5,
  "progress": 0,
  "agents": [],
  "currentTask": "",
  "startedAt": "$CURRENT_TIME",
  "lastUpdate": "$CURRENT_TIME"
}
EOF

# Auto-launch dashboard in separate terminal with logging
DASHBOARD_SCRIPT="$PLUGIN_DIR/scripts/open-dashboard.sh"
if [ -x "$DASHBOARD_SCRIPT" ]; then
  LOG_FILE="/tmp/spec-it-execute-dashboard-$(date +%Y%m%d%H%M%S).log"
  nohup "$DASHBOARD_SCRIPT" "$SESSION_DIR" >> "$LOG_FILE" 2>&1 &
  echo "DASHBOARD:launched"
  echo "DASHBOARD_LOG:$LOG_FILE"
else
  echo "DASHBOARD:not_found" >&2
fi

echo "SESSION_ID:$SESSION_ID"
echo "SESSION_DIR:$SESSION_DIR"
echo "SPEC_FOLDER:$SPEC_FOLDER"
