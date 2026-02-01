#!/bin/bash
# run-e2e.sh - Run E2E tests with auto-detection

set -e

PROJECT_DIR="${1:-.}"

PKG_FILE="$PROJECT_DIR/package.json"
if [ ! -f "$PKG_FILE" ]; then
  echo '{"status":"skipped","reason":"package.json not found"}'
  exit 0
fi

PKG_MANAGER="npm"
if [ -f "$PROJECT_DIR/pnpm-lock.yaml" ]; then
  PKG_MANAGER="pnpm"
elif [ -f "$PROJECT_DIR/yarn.lock" ]; then
  PKG_MANAGER="yarn"
elif [ -f "$PROJECT_DIR/bun.lockb" ]; then
  PKG_MANAGER="bun"
fi

run_script() {
  local script_name="$1"
  case "$PKG_MANAGER" in
    pnpm) pnpm -C "$PROJECT_DIR" "$script_name" ;;
    yarn) (cd "$PROJECT_DIR" && yarn "$script_name") ;;
    bun) (cd "$PROJECT_DIR" && bun run "$script_name") ;;
    *) (cd "$PROJECT_DIR" && npm run "$script_name") ;;
  esac
}

has_script() {
  local name="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -e --arg n "$name" '.scripts[$n] != null' "$PKG_FILE" >/dev/null 2>&1
  else
    grep -q '"scripts"' "$PKG_FILE" && grep -q "\"$name\"" "$PKG_FILE"
  fi
}

if has_script "test:e2e"; then
  run_script "test:e2e"
  echo '{"status":"ok","runner":"test:e2e"}'
  exit 0
fi

if has_script "e2e"; then
  run_script "e2e"
  echo '{"status":"ok","runner":"e2e"}'
  exit 0
fi

if has_script "e2e:ci"; then
  run_script "e2e:ci"
  echo '{"status":"ok","runner":"e2e:ci"}'
  exit 0
fi

if has_script "playwright"; then
  run_script "playwright"
  echo '{"status":"ok","runner":"playwright"}'
  exit 0
fi

if has_script "cypress"; then
  run_script "cypress"
  echo '{"status":"ok","runner":"cypress"}'
  exit 0
fi

echo '{"status":"skipped","reason":"no e2e script found"}'
