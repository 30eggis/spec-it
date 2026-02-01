#!/bin/bash
# component-planner.sh - Extract component list for parallel generation
# Usage: component-planner.sh <sessionId> [baseDir]
# Returns: COMPONENTS_JSON with component list

set -e

SESSION_ID="$1"
BASE_DIR="${2:-.}"

# Document artifacts are in tmp/ (without sessionId)
DOCS_DIR="$BASE_DIR/tmp"
GAP_ANALYSIS="$DOCS_DIR/03-components/gap-analysis.md"
OUTPUT_FILE="$DOCS_DIR/03-components/components.json"

if [ ! -f "$GAP_ANALYSIS" ]; then
  echo "ERROR:GAP_ANALYSIS_NOT_FOUND"
  exit 1
fi

# Extract new components from gap analysis
# Look for sections like "## New Components" or "### Required Components"
components=$(awk '
  /^##.*[Nn]ew|^##.*[Rr]equired|^##.*[Cc]reate/ { capture=1; next }
  /^##/ { capture=0 }
  capture && /^-/ {
    gsub(/^-\s*/, "")
    gsub(/\s*\(.*\)/, "")
    gsub(/[`*]/, "")
    name = $0
    gsub(/[[:space:]]/, "", name)
    if (length(name) > 0) print "{\"name\":\"" tolower(name) "\",\"type\":\"new\"}"
  }
' "$GAP_ANALYSIS" | jq -s '.')

echo "$components" > "$OUTPUT_FILE"

COUNT=$(echo "$components" | jq 'length')
echo "COMPONENTS_READY:$COUNT"
echo "OUTPUT:$OUTPUT_FILE"

# Output batch info (4 components per batch)
BATCHES=$(( (COUNT + 3) / 4 ))
echo "BATCHES:$BATCHES"
echo "BATCH_SIZE:4"
