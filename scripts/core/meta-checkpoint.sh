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
  # Calculate progress based on step
  # Reference: status-tracking.md
  # Phase 1: 0-16%, Phase 2: 17-33%, Phase 3: 34-50%, Phase 4: 51-66%, Phase 5: 67-83%, Phase 6: 84-100%

  calculate_progress() {
    local step="$1"
    case "$step" in
      # Phase 1: Design Brainstorming (0-16%)
      "1.1") echo 4 ;;
      "1.2") echo 8 ;;
      "1.3") echo 12 ;;
      "1.4") echo 16 ;;
      # Phase 2: UI Architecture (17-33%)
      "2.1") echo 24 ;;
      "2.2") echo 33 ;;
      # Phase 3: Component Spec (34-50%)
      "3.1") echo 41 ;;
      "3.2") echo 50 ;;
      # Phase 4: Critical Review (51-66%)
      "4.1") echo 58 ;;
      "4.2") echo 66 ;;
      # Phase 5: Test Spec (67-83%)
      "5.1") echo 75 ;;
      "5.2") echo 83 ;;
      # Phase 6: Final Assembly (84-100%)
      "6.1") echo 91 ;;
      "6.2") echo 100 ;;
      # Default: calculate based on phase.step
      *)
        local phase_num="${step%%.*}"
        local step_num="${step##*.}"
        local base=$((phase_num * 16))
        local offset=$((step_num * 2))
        local total=$((base + offset))
        [ $total -gt 100 ] && total=100
        echo $total
        ;;
    esac
  }

  TOTAL_PROGRESS=$(calculate_progress "$NEW_STEP")

  # Auto-detect phase from step if not provided
  DETECTED_PHASE="${NEW_STEP%%.*}"

  if [ -n "$NEW_PHASE" ]; then
    jq --arg step "$NEW_STEP" --argjson phase "$NEW_PHASE" --argjson prog "$TOTAL_PROGRESS" --arg ts "$TIMESTAMP" '
      .currentStep = $step |
      .currentPhase = $phase |
      .progress = $prog |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"
  else
    # Use detected phase if not explicitly provided
    jq --arg step "$NEW_STEP" --argjson phase "$DETECTED_PHASE" --argjson prog "$TOTAL_PROGRESS" --arg ts "$TIMESTAMP" '
      .currentStep = $step |
      .currentPhase = $phase |
      .progress = $prog |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"
  fi
fi

echo "CHECKPOINT:$NEW_STEP"
echo "TIMESTAMP:$TIMESTAMP"
