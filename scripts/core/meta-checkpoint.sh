#!/bin/bash
# meta-checkpoint.sh - Update _meta.json checkpoint
# Usage: meta-checkpoint.sh <sessionId> <step> [phase] [baseDir]
# Returns: CHECKPOINT:{step}

set -e

SESSION_ID="$1"
NEW_STEP="$2"
NEW_PHASE="${3:-}"
BASE_DIR="${4:-.}"

SESSION_DIR="$BASE_DIR/tmp/$SESSION_ID"
META_FILE="$SESSION_DIR/_meta.json"

if [ ! -f "$META_FILE" ]; then
  echo "ERROR:META_NOT_FOUND"
  exit 1
fi

TIMESTAMP=$(date -Iseconds)

# Update currentStep
jq --arg step "$NEW_STEP" --arg ts "$TIMESTAMP" '
  .currentStep = $step |
  .lastCheckpoint = $ts |
  .completedSteps += [$step]
' "$META_FILE" > "$META_FILE.tmp" && mv "$META_FILE.tmp" "$META_FILE"

# Update phase if provided
if [ -n "$NEW_PHASE" ]; then
  jq --argjson phase "$NEW_PHASE" '.currentPhase = $phase' "$META_FILE" > "$META_FILE.tmp" && mv "$META_FILE.tmp" "$META_FILE"
fi

echo "CHECKPOINT:$NEW_STEP"
echo "TIMESTAMP:$TIMESTAMP"
