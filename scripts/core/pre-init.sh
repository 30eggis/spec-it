#!/bin/bash
# pre-init.sh - Pre-initialize spec-it session before skill starts
# Called by hooks when spec-it* skill is invoked

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SESSION_ID=$(date +%Y%m%d-%H%M%S)
WORK_DIR="$(pwd)"
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

# Session state goes to .spec-it/{sessionId}/plan/
SESSION_DIR="$WORK_DIR/.spec-it/$SESSION_ID/plan"
# Document artifacts go to tmp/
DOCS_DIR="$WORK_DIR/tmp"

# Create minimal folder structure
mkdir -p "$SESSION_DIR"
mkdir -p "$DOCS_DIR"

# Create initial _meta.json and _status.json (avoid shell redirection writes)
CURRENT_TIME=$(date -Iseconds)
export SESSION_ID SESSION_DIR DOCS_DIR CURRENT_TIME

"${PYTHON_CMD[@]}" -c 'import json, os
session_dir = os.environ["SESSION_DIR"]
data = {
  "sessionId": os.environ["SESSION_ID"],
  "mode": "plan",
  "status": "initializing",
  "currentPhase": 0,
  "currentStep": "0.0",
  "completedSteps": [],
  "startedAt": os.environ["CURRENT_TIME"],
  "lastCheckpoint": os.environ["CURRENT_TIME"],
  "canResume": True,
  "uiMode": "pending",
  "docsDir": os.environ["DOCS_DIR"]
}
with open(f"{session_dir}/_meta.json", "w") as f:
  json.dump(data, f, indent=2)
'

"${PYTHON_CMD[@]}" -c 'import json, os
session_dir = os.environ["SESSION_DIR"]
data = {
  "sessionId": os.environ["SESSION_ID"],
  "mode": "plan",
  "startTime": os.environ["CURRENT_TIME"],
  "startedAt": os.environ["CURRENT_TIME"],
  "currentPhase": 0,
  "currentStep": "0.0",
  "progress": 0,
  "status": "initializing",
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

# Launch dashboard with logging
DASHBOARD_SCRIPT="$PLUGIN_DIR/scripts/open-dashboard.sh"
if [ -x "$DASHBOARD_SCRIPT" ]; then
  LOG_FILE="/tmp/spec-it-dashboard-$(date +%Y%m%d%H%M%S).log"
  nohup "$DASHBOARD_SCRIPT" "$SESSION_DIR" >> "$LOG_FILE" 2>&1 &
  echo "DASHBOARD_LOG:$LOG_FILE"
else
  echo "DASHBOARD:not_found" >&2
fi

# Output for Claude to use
echo "SESSION_INITIALIZED"
echo "SESSION_ID:$SESSION_ID"
echo "SESSION_DIR:$SESSION_DIR"
