#!/bin/bash
# scan-components.sh - Component scanning utility for component-auditor agent
# Scans src/components directories and outputs inventory as JSON
#
# Usage: ./scripts/scan-components.sh [project-dir]
# Output: JSON to stdout

set -e

PROJECT_DIR="${1:-.}"
SRC_DIR="$PROJECT_DIR/src"

# Check if src directory exists
if [ ! -d "$SRC_DIR" ]; then
  # Try app directory for Next.js App Router
  if [ -d "$PROJECT_DIR/app" ]; then
    SRC_DIR="$PROJECT_DIR/app"
  else
    echo '{"error": "No src/ or app/ directory found", "components": []}'
    exit 0
  fi
fi

# Initialize counters
COMMON_COUNT=0
UI_COUNT=0
LOCAL_COUNT=0

# Arrays to hold component data
declare -a COMMON_COMPONENTS=()
declare -a UI_COMPONENTS=()
declare -a LOCAL_COMPONENTS=()

# Function to extract component info
scan_component() {
  local file="$1"
  local category="$2"

  local filename=$(basename "$file" | sed 's/\.[^.]*$//')
  local dirname=$(dirname "$file")

  # Count Props interfaces/types
  local props_count=$(grep -c "Props\|interface.*{" "$file" 2>/dev/null || echo "0")

  # Check for export
  local has_export=$(grep -c "export " "$file" 2>/dev/null || echo "0")

  # Check for forwardRef
  local has_forward_ref=$(grep -c "forwardRef" "$file" 2>/dev/null || echo "0")

  # Get line count
  local line_count=$(wc -l < "$file" | tr -d ' ')

  echo "{\"name\": \"$filename\", \"path\": \"$file\", \"props\": $props_count, \"hasExport\": $([ "$has_export" -gt 0 ] && echo 'true' || echo 'false'), \"hasForwardRef\": $([ "$has_forward_ref" -gt 0 ] && echo 'true' || echo 'false'), \"lines\": $line_count}"
}

# Scan common/shared components
COMMON_DIRS=("$SRC_DIR/components/common" "$SRC_DIR/components/shared" "$SRC_DIR/shared/components")
for dir in "${COMMON_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    while IFS= read -r file; do
      COMMON_COMPONENTS+=("$(scan_component "$file" "common")")
      ((COMMON_COUNT++))
    done < <(find "$dir" -name "*.tsx" -o -name "*.jsx" 2>/dev/null | head -100)
  fi
done

# Scan UI library components (shadcn/ui style)
UI_DIRS=("$SRC_DIR/components/ui" "$SRC_DIR/ui")
for dir in "${UI_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    while IFS= read -r file; do
      UI_COMPONENTS+=("$(scan_component "$file" "ui")")
      ((UI_COUNT++))
    done < <(find "$dir" -name "*.tsx" -o -name "*.jsx" 2>/dev/null | head -100)
  fi
done

# Scan local/page-specific components (potential migration candidates)
LOCAL_DIRS=("$SRC_DIR/app" "$SRC_DIR/pages" "$PROJECT_DIR/app" "$PROJECT_DIR/pages")
for dir in "${LOCAL_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    while IFS= read -r file; do
      # Only include files in 'components' subdirectories
      if [[ "$file" == *"/components/"* ]]; then
        LOCAL_COMPONENTS+=("$(scan_component "$file" "local")")
        ((LOCAL_COUNT++))
      fi
    done < <(find "$dir" -name "*.tsx" -o -name "*.jsx" 2>/dev/null | head -100)
  fi
done

# Build JSON output
build_array() {
  local arr=("$@")
  local result=""
  local first=true
  for item in "${arr[@]}"; do
    if [ "$first" = true ]; then
      result="$item"
      first=false
    else
      result="$result, $item"
    fi
  done
  echo "[$result]"
}

COMMON_JSON=$(build_array "${COMMON_COMPONENTS[@]}")
UI_JSON=$(build_array "${UI_COMPONENTS[@]}")
LOCAL_JSON=$(build_array "${LOCAL_COMPONENTS[@]}")

cat <<EOF
{
  "summary": {
    "common": $COMMON_COUNT,
    "ui": $UI_COUNT,
    "local": $LOCAL_COUNT,
    "total": $((COMMON_COUNT + UI_COUNT + LOCAL_COUNT))
  },
  "common": $COMMON_JSON,
  "ui": $UI_JSON,
  "local": $LOCAL_JSON,
  "migrationCandidates": $([ $LOCAL_COUNT -gt 0 ] && echo "$LOCAL_JSON" || echo "[]"),
  "scannedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
