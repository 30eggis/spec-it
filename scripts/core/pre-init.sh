#!/bin/bash
# pre-init.sh - Pre-initialize spec-it session before skill starts
# Called by hooks when spec-it* skill is invoked

PLUGIN_DIR="$HOME/.claude/plugins/frontend-skills"
SESSION_ID=$(date +%Y%m%d-%H%M%S)
BASE_DIR="."

SESSION_DIR="$BASE_DIR/tmp/$SESSION_ID"

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

# Launch dashboard with absolute path
DASHBOARD_SCRIPT="$PLUGIN_DIR/scripts/open-dashboard.sh"
ABS_SESSION_DIR="$(pwd)/tmp/$SESSION_ID"
if [ -x "$DASHBOARD_SCRIPT" ]; then
  nohup "$DASHBOARD_SCRIPT" "$ABS_SESSION_DIR" > /dev/null 2>&1 &
fi

# Output for Claude to use
echo "SESSION_INITIALIZED"
echo "SESSION_ID:$SESSION_ID"
echo "SESSION_DIR:$SESSION_DIR"
