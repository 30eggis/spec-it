#!/bin/bash
# session-init.sh - Initialize spec-it session
# Usage: session-init.sh [sessionId] [uiMode] [workDir]
# Returns: SESSION_ID:{id}

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SESSION_ID="${1:-$(date +%Y%m%d-%H%M%S)}"
UI_MODE="${2:-ascii}"
WORK_DIR="${3:-$(pwd)}"

SESSION_DIR="$WORK_DIR/tmp/$SESSION_ID"

# Create folder structure
mkdir -p "$SESSION_DIR"/{00-requirements,01-chapters/{decisions,alternatives},02-screens/{wireframes,layouts},03-components/{new,migrations},04-review/{scenarios,exceptions},05-tests/{personas,scenarios,components},06-final}

# Create _meta.json
cat > "$SESSION_DIR/_meta.json" << EOF
{
  "sessionId": "$SESSION_ID",
  "status": "in_progress",
  "currentPhase": 1,
  "currentStep": "1.1",
  "completedSteps": [],
  "pendingSteps": ["1.1","1.2","1.3","1.4","2.1","2.2","3.1","3.2","4.1","5.1","6.1"],
  "lastCheckpoint": "$(date -Iseconds)",
  "canResume": true,
  "uiMode": "$UI_MODE",
  "techStack": {
    "framework": "Next.js 15 (App Router)",
    "ui": "React + shadcn/ui",
    "styling": "Tailwind CSS"
  }
}
EOF

# Create _status.json
cat > "$SESSION_DIR/_status.json" << EOF
{
  "sessionId": "$SESSION_ID",
  "startTime": "$(date -Iseconds)",
  "currentPhase": 1,
  "currentStep": "1.1",
  "progress": 0,
  "status": "running",
  "agents": [],
  "stats": {"filesCreated": 0, "linesWritten": 0, "totalSize": "0KB"},
  "recentFiles": [],
  "errors": [],
  "lastUpdate": "$(date -Iseconds)"
}
EOF

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
echo "UI_MODE:$UI_MODE"
