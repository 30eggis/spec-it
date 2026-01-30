#!/bin/bash
# screen-planner.sh - Extract screen list for parallel wireframe generation
# Usage: screen-planner.sh <sessionId> [baseDir]
# Returns: SCREENS_JSON with screen list

set -e

SESSION_ID="$1"
BASE_DIR="${2:-.}"

SESSION_DIR="$BASE_DIR/tmp/$SESSION_ID"
SCREEN_LIST="$SESSION_DIR/02-screens/screen-list.md"
OUTPUT_FILE="$SESSION_DIR/02-screens/screens.json"

if [ ! -f "$SCREEN_LIST" ]; then
  echo "ERROR:SCREEN_LIST_NOT_FOUND"
  exit 1
fi

# Extract screens from markdown (lines starting with ## or - followed by screen name)
# Format: {"name": "screen-name", "layout": "layout-type"}
screens=$(grep -E "^(##|\-)\s+" "$SCREEN_LIST" | \
  sed -E 's/^(##|\-)\s+//' | \
  sed -E 's/\s*\(([^)]+)\)$/|\1/' | \
  while IFS='|' read -r name layout; do
    layout=${layout:-dashboard}
    name=$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    echo "{\"name\":\"$name\",\"layout\":\"$layout\"}"
  done | jq -s '.')

echo "$screens" > "$OUTPUT_FILE"

COUNT=$(echo "$screens" | jq 'length')
echo "SCREENS_READY:$COUNT"
echo "OUTPUT:$OUTPUT_FILE"

# Output batch info (4 screens per batch)
BATCHES=$(( (COUNT + 3) / 4 ))
echo "BATCHES:$BATCHES"
echo "BATCH_SIZE:4"
