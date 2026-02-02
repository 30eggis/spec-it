#!/bin/bash
# phase-dispatcher.sh - Dispatch phase based on uiMode and current state
# Usage: phase-dispatcher.sh <sessionId|sessionDir> <phase> [baseDir]
# Returns: DISPATCH:{action}
#
# sessionId can be:
#   - Just the ID (e.g., 20260131-024252) - will search in baseDir/tmp/
#   - Full path to session dir (e.g., /path/to/tmp/20260131-024252)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/ensure-jq.sh" ]; then
  # shellcheck source=/dev/null
  source "$SCRIPT_DIR/ensure-jq.sh"
  if ! ensure_jq; then
    exit 1
  fi
fi

SESSION_ARG="$1"
PHASE="$2"
BASE_DIR="${3:-.}"

# Determine SESSION_DIR
# New structure: .spec-it/{sessionId}/(plan|execute)
if [ -d "$SESSION_ARG" ] && [ -f "$SESSION_ARG/_meta.json" ]; then
  SESSION_DIR="$SESSION_ARG"
  PARENT_DIR=$(dirname "$SESSION_DIR")
  SESSION_ID=$(basename "$PARENT_DIR")
elif [ -d "$BASE_DIR/.spec-it/$SESSION_ARG/plan" ]; then
  SESSION_ID="$SESSION_ARG"
  SESSION_DIR="$BASE_DIR/.spec-it/$SESSION_ID/plan"
elif [ -d "$BASE_DIR/.spec-it/$SESSION_ARG/execute" ]; then
  SESSION_ID="$SESSION_ARG"
  SESSION_DIR="$BASE_DIR/.spec-it/$SESSION_ID/execute"
else
  SESSION_ID="$SESSION_ARG"
  for search_dir in "$BASE_DIR" "$(pwd)" "$HOME"; do
    if [ -d "$search_dir/.spec-it/$SESSION_ID/plan" ]; then
      SESSION_DIR="$search_dir/.spec-it/$SESSION_ID/plan"
      break
    fi
    if [ -d "$search_dir/.spec-it/$SESSION_ID/execute" ]; then
      SESSION_DIR="$search_dir/.spec-it/$SESSION_ID/execute"
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
# Get docs directory from meta (for plan mode document artifacts)
DOCS_DIR=$(jq -r '.docsDir // ""' "$META_FILE")
if [ -z "$DOCS_DIR" ] || [ "$DOCS_DIR" = "null" ]; then
  # Fallback: derive from session path
  WORK_DIR=$(dirname $(dirname $(dirname "$SESSION_DIR")))
  DOCS_DIR="$WORK_DIR/tmp"
fi
CURRENT_STEP=$(jq -r '.currentStep' "$META_FILE")

case "$PHASE" in
  "init")
    echo "DISPATCH:init"
    echo "UI_MODE:$UI_MODE"
    ;;
  "2.1"|"ui")
    echo "DISPATCH:yaml-wireframe"
    echo "ACTION:run_layout_then_parallel_wireframes"
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
    # Check if must-resolve exists (in docs directory)
    AMBIG_FILE="$DOCS_DIR/04-review/ambiguities.md"
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
