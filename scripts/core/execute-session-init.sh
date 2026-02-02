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
PYTHON_CMD=()

resolve_python() {
  if command -v python3 >/dev/null 2>&1; then
    if python3 -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 6) else 1)' >/dev/null 2>&1; then
      PYTHON_CMD=(python3)
      return 0
    fi
  fi

  if command -v py >/dev/null 2>&1; then
    if py -3 -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 6) else 1)' >/dev/null 2>&1; then
      PYTHON_CMD=(py -3)
      return 0
    fi
  fi

  if command -v python >/dev/null 2>&1; then
    if python -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 6) else 1)' >/dev/null 2>&1; then
      PYTHON_CMD=(python)
      return 0
    fi
  fi

  echo "ERROR:Python 3.6+ not found in PATH" >&2
  exit 1
}

resolve_python

if [ -f "$SCRIPT_DIR/ensure-jq.sh" ]; then
  # shellcheck source=/dev/null
  source "$SCRIPT_DIR/ensure-jq.sh"
  if ! ensure_jq; then
    exit 1
  fi
fi

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

# Create _meta.json and _status.json (avoid shell redirection writes)
export SESSION_ID SESSION_DIR SPEC_FOLDER WORK_DIR PARENT_TERMINAL_INFO CURRENT_TIME

"${PYTHON_CMD[@]}" -c 'import json, os
session_dir = os.environ["SESSION_DIR"]
data = {
  "sessionId": os.environ["SESSION_ID"],
  "mode": "execute",
  "specSource": os.environ.get("SPEC_FOLDER", ""),
  "workDir": os.environ["WORK_DIR"],
  "status": "in_progress",
  "currentPhase": 1,
  "currentStep": "1.1",
  "completedPhases": [],
  "completedTasks": [],
  "completedSteps": [],
  "startedAt": os.environ["CURRENT_TIME"],
  "lastCheckpoint": os.environ["CURRENT_TIME"],
  "canResume": True,
  "livePreview": False,
  "qaAttempts": 0,
  "maxQaAttempts": 5,
  "mirrorAttempts": 0,
  "maxMirrorAttempts": 5,
  "lastMirrorReport": {"matchCount": 0, "missingCount": 0, "overCount": 0},
  "coverageAttempts": 0,
  "maxCoverageAttempts": 5,
  "targetCoverage": 95,
  "currentCoverage": {"statements": 0, "branches": 0, "functions": 0, "lines": 0},
  "scenarioAttempts": 0,
  "maxScenarioAttempts": 5,
  "scenarioResults": {"total": 0, "passed": 0, "failed": 0},
  "parentTerminal": json.loads(os.environ["PARENT_TERMINAL_INFO"])
}
with open(f"{session_dir}/_meta.json", "w") as f:
  json.dump(data, f, indent=2)
'

"${PYTHON_CMD[@]}" -c 'import json, os
session_dir = os.environ["SESSION_DIR"]
data = {
  "sessionId": os.environ["SESSION_ID"],
  "mode": "execute",
  "specSource": os.environ.get("SPEC_FOLDER", ""),
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
  "startedAt": os.environ["CURRENT_TIME"],
  "lastUpdate": os.environ["CURRENT_TIME"]
}
with open(f"{session_dir}/_status.json", "w") as f:
  json.dump(data, f, indent=2)
'

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
