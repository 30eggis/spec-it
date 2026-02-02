#!/bin/bash
# SPEC-IT 간단한 상태 출력 (watch와 함께 사용)
# Usage: watch -n 2 ./spec-it-status.sh [session-path]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
if [ -f "$PLUGIN_DIR/scripts/core/ensure-jq.sh" ]; then
    # shellcheck source=/dev/null
    source "$PLUGIN_DIR/scripts/core/ensure-jq.sh"
    if ! ensure_jq; then
        exit 1
    fi
fi

SESSION_PATH="${1:-.}"

# Find status file (new structure: .spec-it/{id}/(plan|execute))
STATUS_FILE=$(find "$SESSION_PATH" -maxdepth 5 -path "*/.spec-it/*" -name "_status.json" -type f 2>/dev/null | head -1)
META_FILE=$(find "$SESSION_PATH" -maxdepth 5 -path "*/.spec-it/*" -name "_meta.json" -type f 2>/dev/null | head -1)

if [ -z "$STATUS_FILE" ] && [ -z "$META_FILE" ]; then
    echo "⏳ Waiting for spec-it session..."
    exit 0
fi

FILE="${STATUS_FILE:-$META_FILE}"
DIR=$(dirname "$FILE")

# Read values
SESSION=$(jq -r '.sessionId // "?"' "$FILE" 2>/dev/null)
PHASE=$(jq -r '.currentPhase // 1' "$FILE" 2>/dev/null)
STEP=$(jq -r '.currentStep // "1.1"' "$FILE" 2>/dev/null)
PROGRESS=$(jq -r '.progress // 0' "$FILE" 2>/dev/null)

# Count files
FILES=$(find "$DIR" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')

# Running agents
RUNNING=$(jq -r '.agents[]? | select(.status=="running") | .name' "$FILE" 2>/dev/null | tr '\n' ', ' | sed 's/,$//')

# Calculate runtime
START=$(jq -r '.startTime // empty' "$FILE" 2>/dev/null | cut -d'+' -f1 | cut -d'.' -f1)
if [ -n "$START" ]; then
    START_SEC=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$START" "+%s" 2>/dev/null || echo 0)
    NOW_SEC=$(date +%s)
    RUNTIME=$(( (NOW_SEC - START_SEC) / 60 ))
else
    RUNTIME="?"
fi

# Progress bar
BAR_LEN=20
FILLED=$((PROGRESS * BAR_LEN / 100))
EMPTY=$((BAR_LEN - FILLED))
BAR=$(printf "%${FILLED}s" | tr ' ' '█')$(printf "%${EMPTY}s" | tr ' ' '░')

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║ SPEC-IT: $SESSION"
echo "╠══════════════════════════════════════════════════════════════╣"
printf "║ Phase %d/6 [%s] %3d%% │ Files: %-3s │ %s min\n" "$PHASE" "$BAR" "$PROGRESS" "$FILES" "$RUNTIME"
echo "║ Step: $STEP"
if [ -n "$RUNNING" ]; then
    echo "║ Running: $RUNNING"
fi
echo "╚══════════════════════════════════════════════════════════════╝"
