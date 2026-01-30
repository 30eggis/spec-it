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
STATUS_FILE="$SESSION_DIR/_status.json"

# Update _meta.json - currentStep
jq --arg step "$NEW_STEP" --arg ts "$TIMESTAMP" '
  .currentStep = $step |
  .lastCheckpoint = $ts |
  .completedSteps += [$step]
' "$META_FILE" > "$META_FILE.tmp" && mv "$META_FILE.tmp" "$META_FILE"

# Update phase if provided
if [ -n "$NEW_PHASE" ]; then
  jq --argjson phase "$NEW_PHASE" '.currentPhase = $phase' "$META_FILE" > "$META_FILE.tmp" && mv "$META_FILE.tmp" "$META_FILE"
fi

# Also update _status.json for dashboard sync
if [ -f "$STATUS_FILE" ]; then
  # Calculate progress based on step (e.g., 1.2 -> phase 1, step 2)
  PHASE_NUM="${NEW_STEP%%.*}"
  STEP_NUM="${NEW_STEP##*.}"

  # Progress calculation: 6 phases, each ~16.67%
  # Within phase, distribute across steps (assume max 10 steps per phase)
  PHASE_PROGRESS=$((PHASE_NUM * 16))
  STEP_PROGRESS=$((STEP_NUM * 2))
  TOTAL_PROGRESS=$((PHASE_PROGRESS + STEP_PROGRESS))
  [ $TOTAL_PROGRESS -gt 100 ] && TOTAL_PROGRESS=100

  if [ -n "$NEW_PHASE" ]; then
    jq --arg step "$NEW_STEP" --argjson phase "$NEW_PHASE" --argjson prog "$TOTAL_PROGRESS" --arg ts "$TIMESTAMP" '
      .currentStep = $step |
      .currentPhase = $phase |
      .progress = $prog |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"
  else
    jq --arg step "$NEW_STEP" --argjson prog "$TOTAL_PROGRESS" --arg ts "$TIMESTAMP" '
      .currentStep = $step |
      .progress = $prog |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"
  fi
fi

echo "CHECKPOINT:$NEW_STEP"
echo "TIMESTAMP:$TIMESTAMP"
