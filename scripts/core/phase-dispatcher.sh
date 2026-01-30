#!/bin/bash
# phase-dispatcher.sh - Dispatch phase based on uiMode and current state
# Usage: phase-dispatcher.sh <sessionId|sessionDir> <phase> [baseDir]
# Returns: DISPATCH:{action}
#
# sessionId can be:
#   - Just the ID (e.g., 20260131-024252) - will search in baseDir/tmp/
#   - Full path to session dir (e.g., /path/to/tmp/20260131-024252)

set -e

SESSION_ARG="$1"
PHASE="$2"
BASE_DIR="${3:-.}"

# Determine SESSION_DIR
if [ -d "$SESSION_ARG" ] && [ -f "$SESSION_ARG/_meta.json" ]; then
  SESSION_DIR="$SESSION_ARG"
  SESSION_ID=$(basename "$SESSION_DIR")
elif [ -d "$BASE_DIR/tmp/$SESSION_ARG" ]; then
  SESSION_ID="$SESSION_ARG"
  SESSION_DIR="$BASE_DIR/tmp/$SESSION_ID"
else
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

UI_MODE=$(jq -r '.uiMode' "$META_FILE")
CURRENT_STEP=$(jq -r '.currentStep' "$META_FILE")

case "$PHASE" in
  "init")
    echo "DISPATCH:init"
    echo "UI_MODE:$UI_MODE"
    ;;
  "2.1"|"ui")
    if [ "$UI_MODE" == "stitch" ]; then
      echo "DISPATCH:stitch-convert"
      echo "ACTION:run_ui_architect_then_stitch_convert"
    else
      echo "DISPATCH:ascii-wireframe"
      echo "ACTION:run_layout_then_parallel_wireframes"
    fi
    ;;
  "2.2"|"component")
    echo "DISPATCH:component-batch"
    echo "ACTION:parallel_component_builder_migrator"
    ;;
  "3.1"|"review")
    echo "DISPATCH:review-batch"
    echo "ACTION:parallel_critical_ambiguity"
    ;;
  "3.2"|"ambiguity")
    # Check if must-resolve exists
    AMBIG_FILE="$SESSION_DIR/04-review/ambiguities.md"
    if [ -f "$AMBIG_FILE" ] && grep -q "Must Resolve" "$AMBIG_FILE"; then
      echo "DISPATCH:user-question"
      echo "ACTION:ask_ambiguity_resolution"
    else
      echo "DISPATCH:auto-proceed"
      echo "ACTION:skip_to_next_phase"
    fi
    ;;
  "4.1"|"test")
    echo "DISPATCH:test-batch"
    echo "ACTION:parallel_persona_testspec"
    ;;
  "5.1"|"assembly")
    echo "DISPATCH:spec-assembler"
    echo "ACTION:run_final_assembly"
    ;;
  "6.1"|"approval")
    echo "DISPATCH:user-approval"
    echo "ACTION:ask_final_cleanup"
    ;;
  *)
    echo "ERROR:UNKNOWN_PHASE:$PHASE"
    exit 1
    ;;
esac

echo "UI_MODE:$UI_MODE"
echo "CURRENT_STEP:$CURRENT_STEP"
