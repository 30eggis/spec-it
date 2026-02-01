#!/bin/bash
# validate-output.sh - Validate output file size rules

set -e

TARGET_DIR="${1:-tmp}"
MAX_LINES=600

if [ ! -d "$TARGET_DIR" ]; then
  echo '{"status":"skipped","reason":"target directory not found"}'
  exit 0
fi

violations=()

while IFS= read -r -d '' file; do
  case "$file" in
    */wireframes/*) continue ;;
  esac

  lines=$(wc -l < "$file" | tr -d ' ')
  if [ "$lines" -gt "$MAX_LINES" ]; then
    violations+=("$file:$lines")
  fi
done < <(find "$TARGET_DIR" -type f -print0)

json_array() {
  local first=true
  printf '['
  for item in "$@"; do
    if [ "$first" = true ]; then
      first=false
    else
      printf ','
    fi
    printf '"%s"' "$item"
  done
  printf ']'
}

if [ "${#violations[@]}" -gt 0 ]; then
  printf '{"status":"failed","violations":%s}\n' "$(json_array "${violations[@]}")"
  exit 1
fi

echo '{"status":"ok"}'
