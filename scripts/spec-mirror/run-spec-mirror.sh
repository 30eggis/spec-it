#!/bin/bash
# run-spec-mirror.sh - Validate spec-mirror report exists and passes

set -e

PROJECT_DIR="${1:-.}"
REPORT_PATH="$PROJECT_DIR/docs/MIRROR_REPORT.md"

if [ ! -f "$REPORT_PATH" ]; then
  echo '{"status":"failed","reason":"MIRROR_REPORT.md not found"}'
  exit 1
fi

if command -v rg >/dev/null 2>&1; then
  if rg -q "FAIL" "$REPORT_PATH"; then
    echo '{"status":"failed","reason":"mirror report contains FAIL"}'
    exit 1
  fi
else
  if grep -q "FAIL" "$REPORT_PATH"; then
    echo '{"status":"failed","reason":"mirror report contains FAIL"}'
    exit 1
  fi
fi

echo '{"status":"ok","report":"docs/MIRROR_REPORT.md"}'
