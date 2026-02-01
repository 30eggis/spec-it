#!/bin/bash
# run-qa.sh - Run lint/typecheck/test/build with auto-detection

set -e

PROJECT_DIR="${1:-.}"
shift || true

SKIP_LINT=false
SKIP_TYPECHECK=false
SKIP_TEST=false
SKIP_BUILD=false

for arg in "$@"; do
  case "$arg" in
    --skip-lint) SKIP_LINT=true ;;
    --skip-typecheck) SKIP_TYPECHECK=true ;;
    --skip-test) SKIP_TEST=true ;;
    --skip-build) SKIP_BUILD=true ;;
  esac
done

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

ran=()
skipped=()

if [ "$SKIP_LINT" = false ] && has_script "lint"; then
  run_script "lint"
  ran+=("lint")
else
  skipped+=("lint")
fi

if [ "$SKIP_TYPECHECK" = false ]; then
  if has_script "typecheck"; then
    run_script "typecheck"
    ran+=("typecheck")
  else
    skipped+=("typecheck")
  fi
else
  skipped+=("typecheck")
fi

if [ "$SKIP_TEST" = false ] && has_script "test"; then
  run_script "test"
  ran+=("test")
else
  skipped+=("test")
fi

if [ "$SKIP_BUILD" = false ] && has_script "build"; then
  run_script "build"
  ran+=("build")
else
  skipped+=("build")
fi

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

printf '{"status":"ok","packageManager":"%s","ran":%s,"skipped":%s}\n' \
  "$PKG_MANAGER" "$(json_array "${ran[@]}")" "$(json_array "${skipped[@]}")"
