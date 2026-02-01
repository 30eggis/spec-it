#!/bin/bash
# screen-planner.sh - Extract screen list for parallel wireframe generation
# Usage: screen-planner.sh <sessionId> [baseDir]
# Returns: SCREENS_JSON with screen list

set -e

SESSION_ID="$1"
BASE_DIR="${2:-.}"

# Document artifacts are in tmp/ (without sessionId)
DOCS_DIR="$BASE_DIR/tmp"
WIRE_DIR="$DOCS_DIR/02-wireframes"
OUTPUT_FILE="$WIRE_DIR/screen-groups.json"

if [ ! -d "$WIRE_DIR" ]; then
  echo "ERROR:WIRE_DIR_NOT_FOUND"
  exit 1
fi

screen_groups=$(find "$WIRE_DIR" -type f -path "$WIRE_DIR/*/*/screen-list.md" -print0 | \
  while IFS= read -r -d '' file; do
    dir=$(dirname "$file")
    user_type=$(basename "$dir")
    domain=$(basename "$(dirname "$dir")")
    shared="$WIRE_DIR/$domain/shared.md"
    rel_file="${file#$DOCS_DIR/}"
    rel_shared="${shared#$DOCS_DIR/}"
    rel_output_dir="${dir#$DOCS_DIR/}"
    echo "{\"domain\":\"$domain\",\"userType\":\"$user_type\",\"screenList\":\"$rel_file\",\"shared\":\"$rel_shared\",\"outputDir\":\"$rel_output_dir\"}"
  done | jq -s 'sort_by(.domain, .userType)')

COUNT=$(echo "$screen_groups" | jq 'length')
if [ "$COUNT" -eq 0 ]; then
  echo "ERROR:SCREEN_LISTS_NOT_FOUND"
  exit 1
fi

echo "$screen_groups" > "$OUTPUT_FILE"

echo "SCREEN_GROUPS_READY:$COUNT"
echo "OUTPUT:$OUTPUT_FILE"

# Output batch info (4 groups per batch)
BATCHES=$(( (COUNT + 3) / 4 ))
echo "BATCHES:$BATCHES"
echo "BATCH_SIZE:4"
