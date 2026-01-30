#!/bin/bash
# pre-init.sh - Pre-initialize spec-it session before skill starts
# Called by hooks when spec-it* skill is invoked

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SESSION_ID=$(date +%Y%m%d-%H%M%S)
WORK_DIR="$(pwd)"

SESSION_DIR="$WORK_DIR/tmp/$SESSION_ID"

# Create minimal folder structure
mkdir -p "$SESSION_DIR"

# Create initial _meta.json (uiMode will be updated later)
cat > "$SESSION_DIR/_meta.json" << EOF
{
  "sessionId": "$SESSION_ID",
  "status": "initializing",
  "currentPhase": 0,
  "currentStep": "0.0",
  "completedSteps": [],
  "lastCheckpoint": "$(date -Iseconds)",
  "canResume": true,
  "uiMode": "pending"
}
EOF

# Create initial _status.json
cat > "$SESSION_DIR/_status.json" << EOF
{
  "sessionId": "$SESSION_ID",
  "startTime": "$(date -Iseconds)",
  "currentPhase": 0,
  "currentStep": "0.0",
  "progress": 0,
  "status": "initializing",
  "agents": [],
  "stats": {"filesCreated": 0, "linesWritten": 0, "totalSize": "0KB"},
  "recentFiles": [],
  "errors": [],
  "lastUpdate": "$(date -Iseconds)"
}
EOF

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
