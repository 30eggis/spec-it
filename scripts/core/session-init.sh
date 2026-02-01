#!/bin/bash
# session-init.sh - Initialize spec-it session
# Usage: session-init.sh [sessionId] [uiMode] [workDir]
# Returns: SESSION_ID:{id}

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SESSION_ID="${1:-$(date +%Y%m%d-%H%M%S)}"
UI_MODE="${2:-yaml}"
WORK_DIR="${3:-$(pwd)}"

# Convert to absolute path
if [[ "$WORK_DIR" != /* ]]; then
    WORK_DIR="$(cd "$WORK_DIR" 2>/dev/null && pwd)" || WORK_DIR="$(pwd)"
fi

# Session state goes to .spec-it/{sessionId}/plan/
SESSION_DIR="$WORK_DIR/.spec-it/$SESSION_ID/plan"
# Document artifacts go to tmp/ (archive)
DOCS_DIR="$WORK_DIR/tmp"
# Shared runtime log at session level
RUNTIME_LOG_DIR="$WORK_DIR/.spec-it/$SESSION_ID"

echo "DEBUG:WORK_DIR=$WORK_DIR"
echo "DEBUG:SESSION_DIR=$SESSION_DIR"
echo "DEBUG:DOCS_DIR=$DOCS_DIR"

# Create state folder structure
mkdir -p "$SESSION_DIR"
mkdir -p "$RUNTIME_LOG_DIR"

# Create document artifact folders (in tmp/)
mkdir -p "$DOCS_DIR"/{00-requirements,01-chapters/{decisions,alternatives},02-screens/{wireframes,layouts},03-components/{new,migrations},04-review/{scenarios,exceptions},05-tests/{personas,scenarios,components},06-final}

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

# Create _meta.json and _status.json (avoid shell redirection writes)
CURRENT_TIME=$(date -Iseconds)
export SESSION_ID SESSION_DIR UI_MODE DOCS_DIR PARENT_TERMINAL_INFO CURRENT_TIME

python3 -c 'import json, os
session_dir = os.environ["SESSION_DIR"]
data = {
  "sessionId": os.environ["SESSION_ID"],
  "mode": "plan",
  "status": "in_progress",
  "currentPhase": 1,
  "currentStep": "1.1",
  "completedSteps": [],
  "completedPhases": [],
  "pendingSteps": ["1.1","1.2","1.3","1.4","2.1","2.2","3.1","3.2","4.1","5.1","6.1"],
  "startedAt": os.environ["CURRENT_TIME"],
  "lastCheckpoint": os.environ["CURRENT_TIME"],
  "canResume": True,
  "uiMode": os.environ["UI_MODE"],
  "docsDir": os.environ["DOCS_DIR"],
  "techStack": {
    "framework": "Next.js 15 (App Router)",
    "ui": "React + shadcn/ui",
    "styling": "Tailwind CSS"
  },
  "parentTerminal": json.loads(os.environ["PARENT_TERMINAL_INFO"])
}
with open(f"{session_dir}/_meta.json", "w") as f:
  json.dump(data, f, indent=2)
'

python3 -c 'import json, os
session_dir = os.environ["SESSION_DIR"]
data = {
  "sessionId": os.environ["SESSION_ID"],
  "mode": "plan",
  "startTime": os.environ["CURRENT_TIME"],
  "startedAt": os.environ["CURRENT_TIME"],
  "currentPhase": 1,
  "currentStep": "1.1",
  "completedSteps": [],
  "completedPhases": [],
  "progress": 0,
  "status": "running",
  "docsDir": os.environ["DOCS_DIR"],
  "agents": [],
  "stats": {"filesCreated": 0, "linesWritten": 0, "totalSize": "0KB"},
  "recentFiles": [],
  "errors": [],
  "lastUpdate": os.environ["CURRENT_TIME"]
}
with open(f"{session_dir}/_status.json", "w") as f:
  json.dump(data, f, indent=2)
'

# Auto-launch dashboard in separate terminal with logging
DASHBOARD_SCRIPT="$PLUGIN_DIR/scripts/open-dashboard.sh"
if [ -x "$DASHBOARD_SCRIPT" ]; then
  LOG_FILE="/tmp/spec-it-dashboard-$(date +%Y%m%d%H%M%S).log"
  nohup "$DASHBOARD_SCRIPT" "$SESSION_DIR" >> "$LOG_FILE" 2>&1 &
  echo "DASHBOARD:launched"
  echo "DASHBOARD_LOG:$LOG_FILE"
else
  echo "DASHBOARD:not_found" >&2
fi

echo "SESSION_ID:$SESSION_ID"
echo "SESSION_DIR:$SESSION_DIR"
echo "DOCS_DIR:$DOCS_DIR"
echo "UI_MODE:$UI_MODE"
