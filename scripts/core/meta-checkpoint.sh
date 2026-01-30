#!/bin/bash
# meta-checkpoint.sh - Update _meta.json checkpoint
# Usage: meta-checkpoint.sh <sessionId|sessionDir> <step> [phase] [baseDir]
# Returns: CHECKPOINT:{step}
#
# sessionId can be:
#   - Just the ID (e.g., 20260131-024252) - will search in baseDir/tmp/
#   - Full path to session dir (e.g., /path/to/tmp/20260131-024252)

set -e

SESSION_ARG="$1"
NEW_STEP="$2"
NEW_PHASE="${3:-}"
BASE_DIR="${4:-.}"

# Determine SESSION_DIR
if [ -d "$SESSION_ARG" ] && [ -f "$SESSION_ARG/_meta.json" ]; then
  # SESSION_ARG is already a full path to session directory
  SESSION_DIR="$SESSION_ARG"
  SESSION_ID=$(basename "$SESSION_DIR")
elif [ -d "$BASE_DIR/tmp/$SESSION_ARG" ]; then
  # SESSION_ARG is just the session ID
  SESSION_ID="$SESSION_ARG"
  SESSION_DIR="$BASE_DIR/tmp/$SESSION_ID"
else
  # Try to find session directory by searching common locations
  SESSION_ID="$SESSION_ARG"
  for search_dir in "$BASE_DIR" "$(pwd)" "$HOME"; do
    if [ -d "$search_dir/tmp/$SESSION_ID" ]; then
      SESSION_DIR="$search_dir/tmp/$SESSION_ID"
      break
    fi
  done
fi

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
