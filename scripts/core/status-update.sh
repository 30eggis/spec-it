#!/bin/bash
# status-update.sh - Update _status.json for dashboard + runtime-log.md
# Usage: status-update.sh <sessionId> <action> [args...] [baseDir]
# Actions: agent-start, agent-complete, progress, file-created, error

set -e

SESSION_ID="$1"
ACTION="$2"
shift 2

# Find baseDir (last arg if it's a directory)
ARGS=("$@")
BASE_DIR="."
if [ ${#ARGS[@]} -gt 0 ] && [ -d "${ARGS[-1]}/tmp/$SESSION_ID" ]; then
  BASE_DIR="${ARGS[-1]}"
  unset 'ARGS[-1]'
fi

SESSION_DIR="$BASE_DIR/tmp/$SESSION_ID"
STATUS_FILE="$SESSION_DIR/_status.json"
RUNTIME_LOG="$SESSION_DIR/runtime-log.md"

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
  grep -c "^| [0-9]" "$RUNTIME_LOG" 2>/dev/null || echo 0
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

    # Get start time from _status.json
    START_TS=$(jq -r --arg name "$AGENT_NAME" '.agents[] | select(.name == $name) | .startedAt' "$STATUS_FILE")
    DURATION=$(calc_duration "$START_TS" "$TIMESTAMP")

    # Update _status.json
    jq --arg name "$AGENT_NAME" --arg ts "$TIMESTAMP" --arg out "$OUTPUT" --arg dur "$DURATION" '
      (.agents[] | select(.name == $name)) |= . + {"status": "completed", "completedAt": $ts, "output": $out, "duration": $dur} |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

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
  "complete")
    # Update _status.json
    jq --arg ts "$TIMESTAMP" '
      .status = "completed" |
      .progress = 100 |
      .lastUpdate = $ts
    ' "$STATUS_FILE" > "$STATUS_FILE.tmp" && mv "$STATUS_FILE.tmp" "$STATUS_FILE"

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
