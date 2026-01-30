#!/bin/bash
# detect-stack.sh - Unified framework/stack detection for all agents
# Eliminates duplicate detection logic across design-interviewer, ui-architect,
# component-builder, test-spec-writer, and spec-executor agents.
#
# Usage: ./scripts/detect-stack.sh [project-dir]
# Output: JSON to stdout (for _meta.json consumption)

set -e

PROJECT_DIR="${1:-.}"

# Check if package.json exists
if [ ! -f "$PROJECT_DIR/package.json" ]; then
  echo '{"error": "No package.json found", "framework": "unknown", "testFramework": "unknown", "ui": "unknown"}'
  exit 0
fi

# Use jq if available, otherwise fall back to grep-based detection
if command -v jq &> /dev/null; then
  # Read package.json
  PKG="$PROJECT_DIR/package.json"

  # Detect framework
  FRAMEWORK=$(cat "$PKG" | jq -r '
    if .dependencies["next"] then "nextjs"
    elif .dependencies["nuxt"] then "nuxt"
    elif .dependencies["vue"] then "vue"
    elif .dependencies["svelte"] then "svelte"
    elif .dependencies["@angular/core"] then "angular"
    elif .dependencies["react"] then "react"
    else "unknown"
    end
  ')

  # Detect test framework
  TEST_FRAMEWORK=$(cat "$PKG" | jq -r '
    if .devDependencies["vitest"] then "vitest"
    elif .devDependencies["jest"] then "jest"
    elif .devDependencies["@playwright/test"] then "playwright"
    elif .devDependencies["cypress"] then "cypress"
    elif .devDependencies["mocha"] then "mocha"
    else "unknown"
    end
  ')

  # Detect UI library
  UI_LIB=$(cat "$PKG" | jq -r '
    if .dependencies["@shadcn/ui"] or .devDependencies["@shadcn/ui"] then "shadcn"
    elif .dependencies["@radix-ui/react-slot"] then "shadcn"
    elif .dependencies["@chakra-ui/react"] then "chakra"
    elif .dependencies["@mui/material"] then "mui"
    elif .dependencies["antd"] then "antd"
    elif .dependencies["@headlessui/react"] then "headless"
    else "custom"
    end
  ')

  # Detect CSS framework
  CSS_FRAMEWORK=$(cat "$PKG" | jq -r '
    if .devDependencies["tailwindcss"] or .dependencies["tailwindcss"] then "tailwind"
    elif .devDependencies["sass"] or .dependencies["sass"] then "sass"
    elif .devDependencies["styled-components"] or .dependencies["styled-components"] then "styled-components"
    elif .devDependencies["@emotion/react"] or .dependencies["@emotion/react"] then "emotion"
    else "css"
    end
  ')

  # Detect package manager
  if [ -f "$PROJECT_DIR/pnpm-lock.yaml" ]; then
    PKG_MANAGER="pnpm"
  elif [ -f "$PROJECT_DIR/yarn.lock" ]; then
    PKG_MANAGER="yarn"
  elif [ -f "$PROJECT_DIR/bun.lockb" ]; then
    PKG_MANAGER="bun"
  else
    PKG_MANAGER="npm"
  fi

  # Detect TypeScript
  if [ -f "$PROJECT_DIR/tsconfig.json" ]; then
    TYPESCRIPT="true"
  else
    TYPESCRIPT="false"
  fi

  # Detect monorepo
  if [ -f "$PROJECT_DIR/pnpm-workspace.yaml" ] || [ -f "$PROJECT_DIR/lerna.json" ] || [ -d "$PROJECT_DIR/packages" ]; then
    MONOREPO="true"
  else
    MONOREPO="false"
  fi

  # Output JSON
  cat <<EOF
{
  "framework": "$FRAMEWORK",
  "testFramework": "$TEST_FRAMEWORK",
  "ui": "$UI_LIB",
  "css": "$CSS_FRAMEWORK",
  "packageManager": "$PKG_MANAGER",
  "typescript": $TYPESCRIPT,
  "monorepo": $MONOREPO,
  "detectedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

else
  # Fallback: grep-based detection (less accurate)
  PKG_CONTENT=$(cat "$PROJECT_DIR/package.json")

  # Simple framework detection
  if echo "$PKG_CONTENT" | grep -q '"next"'; then
    FRAMEWORK="nextjs"
  elif echo "$PKG_CONTENT" | grep -q '"vue"'; then
    FRAMEWORK="vue"
  elif echo "$PKG_CONTENT" | grep -q '"svelte"'; then
    FRAMEWORK="svelte"
  elif echo "$PKG_CONTENT" | grep -q '"react"'; then
    FRAMEWORK="react"
  else
    FRAMEWORK="unknown"
  fi

  # Simple test framework detection
  if echo "$PKG_CONTENT" | grep -q '"vitest"'; then
    TEST_FRAMEWORK="vitest"
  elif echo "$PKG_CONTENT" | grep -q '"jest"'; then
    TEST_FRAMEWORK="jest"
  elif echo "$PKG_CONTENT" | grep -q '"@playwright/test"'; then
    TEST_FRAMEWORK="playwright"
  else
    TEST_FRAMEWORK="unknown"
  fi

  # Simple UI detection
  if echo "$PKG_CONTENT" | grep -q '"@radix-ui'; then
    UI_LIB="shadcn"
  else
    UI_LIB="custom"
  fi

  cat <<EOF
{
  "framework": "$FRAMEWORK",
  "testFramework": "$TEST_FRAMEWORK",
  "ui": "$UI_LIB",
  "css": "unknown",
  "packageManager": "npm",
  "typescript": false,
  "monorepo": false,
  "detectedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "note": "jq not available - limited detection"
}
EOF
fi
