#!/bin/bash
# batch-runner.sh - Coordinate batch parallel execution
# Usage: batch-runner.sh <sessionId> <type> <batchIndex> [baseDir]
# Types: wireframe, component, review, test
# Returns: Batch items to process

set -e

SESSION_ID="$1"
TYPE="$2"
BATCH_INDEX="${3:-0}"
BASE_DIR="${4:-.}"

SESSION_DIR="$BASE_DIR/tmp/$SESSION_ID"
BATCH_SIZE=4

case "$TYPE" in
  "wireframe")
    JSON_FILE="$SESSION_DIR/02-screens/screens.json"
    ;;
  "component")
    JSON_FILE="$SESSION_DIR/03-components/components.json"
    ;;
  *)
    echo "ERROR:UNKNOWN_TYPE:$TYPE"
    exit 1
    ;;
esac

if [ ! -f "$JSON_FILE" ]; then
  echo "ERROR:JSON_NOT_FOUND:$JSON_FILE"
  exit 1
fi

TOTAL=$(jq 'length' "$JSON_FILE")
START=$((BATCH_INDEX * BATCH_SIZE))
END=$((START + BATCH_SIZE))

if [ $START -ge $TOTAL ]; then
  echo "BATCH_COMPLETE:ALL_DONE"
  exit 0
fi

# Extract batch items
ITEMS=$(jq --argjson start "$START" --argjson size "$BATCH_SIZE" '.[$start:$start+$size]' "$JSON_FILE")

echo "BATCH_INDEX:$BATCH_INDEX"
echo "BATCH_START:$START"
echo "BATCH_END:$END"
echo "BATCH_ITEMS:$ITEMS"

# Output individual items for agent dispatch
echo "$ITEMS" | jq -c '.[]' | while read -r item; do
  NAME=$(echo "$item" | jq -r '.name')
  echo "ITEM:$NAME"
done

REMAINING=$((TOTAL - END))
if [ $REMAINING -gt 0 ]; then
  echo "NEXT_BATCH:$((BATCH_INDEX + 1))"
  echo "REMAINING:$REMAINING"
else
  echo "BATCH_COMPLETE:LAST_BATCH"
fi
