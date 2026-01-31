#!/bin/bash
# status-update.sh - Update _status.json for dashboard + runtime-log.md
# Usage: status-update.sh <sessionId|sessionDir> <action> [args...] [baseDir]
# Actions: agent-start, agent-complete, progress, file-created, error
#
# sessionId can be:
#   - Just the ID (e.g., 20260131-024252) - will search in baseDir/tmp/
#   - Full path to session dir (e.g., /path/to/tmp/20260131-024252)

set -e

SESSION_ARG="$1"
ACTION="$2"
shift 2

# Find baseDir (last arg if it's a directory)
ARGS=("$@")
BASE_DIR="."
if [ ${#ARGS[@]} -gt 0 ]; then
  LAST_IDX=$((${#ARGS[@]} - 1))
  LAST_ARG="${ARGS[$LAST_IDX]}"
  if [ -d "$LAST_ARG" ]; then
    BASE_DIR="$LAST_ARG"
    unset "ARGS[$LAST_IDX]"
  fi
fi

# Determine SESSION_DIR
if [ -d "$SESSION_ARG" ] && [ -f "$SESSION_ARG/_status.json" ]; then
  # SESSION_ARG is already a full path to session directory
  SESSION_DIR="$SESSION_ARG"
  SESSION_ID=$(basename "$SESSION_DIR")
elif [ -d "$BASE_DIR/tmp/$SESSION_ARG" ]; then
  # SESSION_ARG is just the session ID (spec-it mode)
  SESSION_ID="$SESSION_ARG"
  SESSION_DIR="$BASE_DIR/tmp/$SESSION_ID"
elif [ -d "$BASE_DIR/.spec-it/execute/$SESSION_ARG" ]; then
  # SESSION_ARG is just the session ID (execute mode)
  SESSION_ID="$SESSION_ARG"
  SESSION_DIR="$BASE_DIR/.spec-it/execute/$SESSION_ID"
else
  # Try to find session directory by searching common locations
  SESSION_ID="$SESSION_ARG"
  for search_dir in "$BASE_DIR" "$(pwd)" "$HOME"; do
    # Check spec-it mode (tmp/)
    if [ -d "$search_dir/tmp/$SESSION_ID" ]; then
      SESSION_DIR="$search_dir/tmp/$SESSION_ID"
      break
    fi
    # Check execute mode (.spec-it/execute/)
    if [ -d "$search_dir/.spec-it/execute/$SESSION_ID" ]; then
      SESSION_DIR="$search_dir/.spec-it/execute/$SESSION_ID"
      break
    fi
  done
fi

STATUS_FILE="$SESSION_DIR/_status.json"
RUNTIME_LOG="$SESSION_DIR/runtime-log.md"

# Debug output
echo "DEBUG:SESSION_DIR=$SESSION_DIR" >&2

if [ ! -f "$STATUS_FILE" ]; then
  echo "ERROR:STATUS_NOT_FOUND"
  exit 1
fi

TIMESTAMP=$(date -Iseconds)
TIME_DISPLAY=$(date +"%H:%M:%S")

# Initialize runtime-log.md if not exists
if [ ! -f "$RUNTIME_LOG" ]; then
  cat > "$RUNTIME_LOG" << EOF
# Runtime Log - $SESSION_ID

## Summary
- Session Start: $TIMESTAMP
- Total Agents: 0
- Total Duration: -

## Agent Timeline

| # | Agent | Started | Ended | Duration | Status |
|---|-------|---------|-------|----------|--------|
EOF
fi

# Helper: Calculate duration between two ISO timestamps
calc_duration() {
  local start_ts="$1"
  local end_ts="$2"
  local start_sec=$(date -d "$start_ts" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "${start_ts%%+*}" +%s 2>/dev/null || echo 0)
  local end_sec=$(date -d "$end_ts" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "${end_ts%%+*}" +%s 2>/dev/null || echo 0)
  local diff=$((end_sec - start_sec))
  local mins=$((diff / 60))
  local secs=$((diff % 60))
  echo "${mins}m ${secs}s"
}

# Helper: Get agent count from log
get_agent_count() {
  local count
  count=$(grep -c "^| [0-9]" "$RUNTIME_LOG" 2>/dev/null) || count=0
  echo "$count"
}

case "$ACTION" in
  "agent-start")
    AGENT_NAME="${ARGS[0]}"

    # Update _status.json
    jq --arg name "$AGENT_NAME" --arg ts "$TIMESTAMP" '
      .agents += [{"name": $name, "status": "running", "startedAt": $ts}] |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

    # Update runtime-log.md (add pending row)
    AGENT_NUM=$(($(get_agent_count) + 1))
    echo "| $AGENT_NUM | $AGENT_NAME | $TIME_DISPLAY | - | - | ⏳ |" >> "$RUNTIME_LOG"

    echo "AGENT_STARTED:$AGENT_NAME"
    ;;
  "agent-complete")
    AGENT_NAME="${ARGS[0]}"
    OUTPUT="${ARGS[1]:-}"
    STEP="${ARGS[2]:-}"  # Optional step to mark as completed

    # Get start time from _status.json
    START_TS=$(jq -r --arg name "$AGENT_NAME" '.agents[] | select(.name == $name) | .startedAt' "$STATUS_FILE")
    DURATION=$(calc_duration "$START_TS" "$TIMESTAMP")

    # Update _status.json - agent status
    jq --arg name "$AGENT_NAME" --arg ts "$TIMESTAMP" --arg out "$OUTPUT" --arg dur "$DURATION" '
      (.agents[] | select(.name == $name)) |= . + {"status": "completed", "completedAt": $ts, "output": $out, "duration": $dur} |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

    # If step is provided, also update step progress
    if [ -n "$STEP" ]; then
      # Calculate progress based on step (same logic as meta-checkpoint.sh)
      case "$STEP" in
        "1.1") PROG=4 ;;
        "1.2") PROG=8 ;;
        "1.3") PROG=12 ;;
        "1.4") PROG=16 ;;
        "2.1") PROG=24 ;;
        "2.2") PROG=33 ;;
        "3.1") PROG=41 ;;
        "3.2") PROG=50 ;;
        "4.1") PROG=58 ;;
        "4.2") PROG=66 ;;
        "5.1") PROG=75 ;;
        "5.2") PROG=83 ;;
        "6.1") PROG=91 ;;
        "6.2") PROG=100 ;;
        *) PROG=0 ;;
      esac

      PHASE="${STEP%%.*}"

      # Update _status.json with step progress
      jq --arg step "$STEP" --argjson phase "$PHASE" --argjson prog "$PROG" --arg ts "$TIMESTAMP" '
        .currentStep = $step |
        .currentPhase = $phase |
        .progress = $prog |
        .completedSteps += [$step] |
        .completedSteps |= unique |
        .lastUpdate = $ts
      ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

      # Also update _meta.json (spec-it mode)
      META_FILE="$SESSION_DIR/_meta.json"
      if [ -f "$META_FILE" ]; then
        jq --arg step "$STEP" --argjson phase "$PHASE" --arg ts "$TIMESTAMP" '
          .currentStep = $step |
          .currentPhase = $phase |
          .lastCheckpoint = $ts |
          .completedSteps += [$step] |
          .completedSteps |= unique
        ' "$META_FILE" > "$META_FILE.tmp" && mv "$META_FILE.tmp" "$META_FILE"
      fi

      # Also update _state.json (execute mode)
      STATE_FILE="$SESSION_DIR/_state.json"
      if [ -f "$STATE_FILE" ]; then
        jq --arg step "$STEP" --argjson phase "$PHASE" --arg ts "$TIMESTAMP" '
          .currentStep = $step |
          .currentPhase = $phase |
          .lastCheckpoint = $ts |
          (if .completedSteps then .completedSteps += [$step] | .completedSteps |= unique else . end)
        ' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
      fi

      echo "STEP_COMPLETED:$STEP"
      echo "PROGRESS:$PROG"
    fi

    # Update runtime-log.md (replace pending row with completed)
    # Find the line with this agent and ⏳, replace with completed info
    if grep -q "| $AGENT_NAME |.*⏳" "$RUNTIME_LOG"; then
      sed -i.bak "s/| $AGENT_NAME | \([^ ]*\) | - | - | ⏳ |/| $AGENT_NAME | \1 | $TIME_DISPLAY | $DURATION | ✓ |/" "$RUNTIME_LOG"
      rm -f "$RUNTIME_LOG.bak"
    fi

    echo "AGENT_COMPLETED:$AGENT_NAME"
    echo "DURATION:$DURATION"
    ;;
  "progress")
    PROGRESS="${ARGS[0]}"
    STEP="${ARGS[1]:-}"
    PHASE="${ARGS[2]:-}"
    jq --argjson prog "$PROGRESS" --arg step "$STEP" --arg phase "$PHASE" --arg ts "$TIMESTAMP" '
      .progress = $prog |
      (if $step != "" then .currentStep = $step else . end) |
      (if $phase != "" then .currentPhase = ($phase | tonumber) else . end) |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"
    echo "PROGRESS:$PROGRESS"
    ;;
  "file-created")
    FILE_PATH="${ARGS[0]}"
    LINES="${ARGS[1]:-0}"
    jq --arg file "$FILE_PATH" --argjson lines "$LINES" --arg ts "$TIMESTAMP" '
      .stats.filesCreated += 1 |
      .stats.linesWritten += $lines |
      .recentFiles = ([$file] + .recentFiles)[:10] |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"
    echo "FILE_CREATED:$FILE_PATH"
    ;;
  "agent-error")
    AGENT_NAME="${ARGS[0]}"
    ERROR_MSG="${ARGS[1]:-unknown error}"

    # Get start time from _status.json
    START_TS=$(jq -r --arg name "$AGENT_NAME" '.agents[] | select(.name == $name) | .startedAt' "$STATUS_FILE")
    DURATION=$(calc_duration "$START_TS" "$TIMESTAMP")

    # Update _status.json
    jq --arg name "$AGENT_NAME" --arg ts "$TIMESTAMP" --arg err "$ERROR_MSG" --arg dur "$DURATION" '
      (.agents[] | select(.name == $name)) |= . + {"status": "error", "completedAt": $ts, "error": $err, "duration": $dur} |
      .errors += [$name + ": " + $err] |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

    # Update runtime-log.md
    if grep -q "| $AGENT_NAME |.*⏳" "$RUNTIME_LOG"; then
      sed -i.bak "s/| $AGENT_NAME | \([^ ]*\) | - | - | ⏳ |/| $AGENT_NAME | \1 | $TIME_DISPLAY | $DURATION | ✗ |/" "$RUNTIME_LOG"
      rm -f "$RUNTIME_LOG.bak"
    fi

    echo "AGENT_ERROR:$AGENT_NAME"
    echo "ERROR:$ERROR_MSG"
    ;;
  "error")
    ERROR_MSG="${ARGS[0]}"
    jq --arg err "$ERROR_MSG" --arg ts "$TIMESTAMP" '
      .errors += [$err] |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

    # Log to runtime-log.md
    echo "" >> "$RUNTIME_LOG"
    echo "**Error** ($TIME_DISPLAY): $ERROR_MSG" >> "$RUNTIME_LOG"

    echo "ERROR_LOGGED:$ERROR_MSG"
    ;;
  "waiting")
    # Set waiting for user input flag
    WAITING_MSG="${ARGS[0]:-Waiting for user input}"
    jq --arg ts "$TIMESTAMP" --arg msg "$WAITING_MSG" '
      .waitingForUser = true |
      .waitingMessage = $msg |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

    # Also update _state.json (execute mode)
    STATE_FILE="$SESSION_DIR/_state.json"
    if [ -f "$STATE_FILE" ]; then
      jq --arg ts "$TIMESTAMP" --arg msg "$WAITING_MSG" '
        .waitingForUser = true |
        .waitingMessage = $msg |
        .lastCheckpoint = $ts
      ' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
    fi

    echo "WAITING:$WAITING_MSG"
    ;;
  "resume")
    # Clear waiting for user input flag
    jq --arg ts "$TIMESTAMP" '
      .waitingForUser = false |
      .waitingMessage = null |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

    # Also update _state.json (execute mode)
    STATE_FILE="$SESSION_DIR/_state.json"
    if [ -f "$STATE_FILE" ]; then
      jq --arg ts "$TIMESTAMP" '
        .waitingForUser = false |
        .waitingMessage = null |
        .lastCheckpoint = $ts
      ' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
    fi

    echo "RESUMED"
    ;;
  "phase-complete")
    # Mark phase as completed and move to next phase
    PHASE="${ARGS[0]}"
    NEXT_PHASE="${ARGS[1]:-}"
    NEXT_STEP="${ARGS[2]:-}"

    # Calculate progress based on phase (execute mode has 9 phases)
    case "$PHASE" in
      "1") PROG=11 ;;
      "2") PROG=22 ;;
      "3") PROG=33 ;;
      "4") PROG=44 ;;
      "5") PROG=55 ;;
      "6") PROG=66 ;;
      "7") PROG=77 ;;
      "8") PROG=88 ;;
      "9") PROG=100 ;;
      *) PROG=0 ;;
    esac

    # Update _status.json
    jq --argjson phase "$PHASE" --argjson prog "$PROG" --arg ts "$TIMESTAMP" '
      .completedPhases += [$phase] |
      .completedPhases |= unique |
      .progress = $prog |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

    # If next phase provided, update current phase
    if [ -n "$NEXT_PHASE" ]; then
      jq --argjson nextPhase "$NEXT_PHASE" --arg nextStep "$NEXT_STEP" --arg ts "$TIMESTAMP" '
        .currentPhase = $nextPhase |
        (if $nextStep != "" then .currentStep = $nextStep else . end) |
        .lastUpdate = $ts
      ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"
    fi

    # Also update _meta.json (spec-it mode)
    META_FILE="$SESSION_DIR/_meta.json"
    if [ -f "$META_FILE" ]; then
      jq --argjson phase "$PHASE" --argjson nextPhase "${NEXT_PHASE:-0}" --arg nextStep "$NEXT_STEP" --arg ts "$TIMESTAMP" '
        .completedPhases += [$phase] |
        .completedPhases |= unique |
        (if $nextPhase > 0 then .currentPhase = $nextPhase else . end) |
        (if $nextStep != "" then .currentStep = $nextStep else . end) |
        .lastCheckpoint = $ts
      ' "$META_FILE" > "$META_FILE.tmp" && mv "$META_FILE.tmp" "$META_FILE"
    fi

    # Also update _state.json (execute mode)
    STATE_FILE="$SESSION_DIR/_state.json"
    if [ -f "$STATE_FILE" ]; then
      jq --argjson phase "$PHASE" --argjson nextPhase "${NEXT_PHASE:-0}" --arg nextStep "$NEXT_STEP" --arg ts "$TIMESTAMP" '
        .completedPhases += [$phase] |
        .completedPhases |= unique |
        (if $nextPhase > 0 then .currentPhase = $nextPhase else . end) |
        (if $nextStep != "" then .currentStep = $nextStep else . end) |
        .lastCheckpoint = $ts
      ' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
    fi

    echo "PHASE_COMPLETED:$PHASE"
    if [ -n "$NEXT_PHASE" ]; then
      echo "NEXT_PHASE:$NEXT_PHASE"
    fi
    echo "PROGRESS:$PROG"
    ;;
  "step-update")
    # Update current step without marking anything complete
    STEP="${ARGS[0]}"
    PHASE="${STEP%%.*}"

    # Update _status.json
    jq --arg step "$STEP" --argjson phase "$PHASE" --arg ts "$TIMESTAMP" '
      .currentStep = $step |
      .currentPhase = $phase |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

    # Also update _meta.json
    META_FILE="$SESSION_DIR/_meta.json"
    if [ -f "$META_FILE" ]; then
      jq --arg step "$STEP" --argjson phase "$PHASE" --arg ts "$TIMESTAMP" '
        .currentStep = $step |
        .currentPhase = $phase |
        .lastCheckpoint = $ts
      ' "$META_FILE" > "$META_FILE.tmp" && mv "$META_FILE.tmp" "$META_FILE"
    fi

    # Also update _state.json
    STATE_FILE="$SESSION_DIR/_state.json"
    if [ -f "$STATE_FILE" ]; then
      jq --arg step "$STEP" --argjson phase "$PHASE" --arg ts "$TIMESTAMP" '
        .currentStep = $step |
        .currentPhase = $phase |
        .lastCheckpoint = $ts
      ' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
    fi

    echo "STEP:$STEP"
    ;;
  "state-update")
    # Generic state update for execute mode (_state.json specific fields)
    KEY="${ARGS[0]}"
    VALUE="${ARGS[1]}"

    STATE_FILE="$SESSION_DIR/_state.json"
    if [ -f "$STATE_FILE" ]; then
      # Try to parse VALUE as JSON, fallback to string
      if echo "$VALUE" | jq . >/dev/null 2>&1; then
        jq --arg key "$KEY" --argjson val "$VALUE" --arg ts "$TIMESTAMP" '
          .[$key] = $val |
          .lastCheckpoint = $ts
        ' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
      else
        jq --arg key "$KEY" --arg val "$VALUE" --arg ts "$TIMESTAMP" '
          .[$key] = $val |
          .lastCheckpoint = $ts
        ' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
      fi
      echo "STATE_UPDATED:$KEY=$VALUE"
    else
      echo "ERROR:STATE_FILE_NOT_FOUND"
    fi
    ;;
  "complete")
    # Update _status.json
    jq --arg ts "$TIMESTAMP" '
      .status = "completed" |
      .progress = 100 |
      .waitingForUser = false |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

    # Also update _meta.json (spec-it mode)
    META_FILE="$SESSION_DIR/_meta.json"
    if [ -f "$META_FILE" ]; then
      jq --arg ts "$TIMESTAMP" '
        .status = "completed" |
        .lastCheckpoint = $ts
      ' "$META_FILE" > "$META_FILE.tmp" && mv "$META_FILE.tmp" "$META_FILE"
    fi

    # Also update _state.json (execute mode)
    STATE_FILE="$SESSION_DIR/_state.json"
    if [ -f "$STATE_FILE" ]; then
      jq --arg ts "$TIMESTAMP" '
        .status = "completed" |
        .completedAt = $ts |
        .lastCheckpoint = $ts
      ' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
    fi

    # Update runtime-log.md summary
    START_TS=$(jq -r '.startTime' "$STATUS_FILE")
    TOTAL_DURATION=$(calc_duration "$START_TS" "$TIMESTAMP")
    TOTAL_AGENTS=$(get_agent_count)

    # Update summary section
    sed -i.bak "s/Total Agents: .*/Total Agents: $TOTAL_AGENTS/" "$RUNTIME_LOG"
    sed -i.bak "s/Total Duration: .*/Total Duration: $TOTAL_DURATION/" "$RUNTIME_LOG"
    rm -f "$RUNTIME_LOG.bak"

    # Add completion timestamp
    echo "" >> "$RUNTIME_LOG"
    echo "---" >> "$RUNTIME_LOG"
    echo "**Session Completed**: $TIMESTAMP" >> "$RUNTIME_LOG"
    echo "**Total Duration**: $TOTAL_DURATION" >> "$RUNTIME_LOG"

    echo "SESSION_COMPLETED"
    echo "TOTAL_DURATION:$TOTAL_DURATION"
    ;;
  *)
    echo "ERROR:UNKNOWN_ACTION:$ACTION"
    exit 1
    ;;
esac
