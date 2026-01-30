#!/bin/bash
# Verify Stitch MCP setup status
# Usage: ./verify-stitch-mcp.sh
# Exit codes: 0 = all good, 1 = needs setup, 2 = needs restart

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=== Stitch MCP Verification ==="
echo ""

errors=0
needs_restart=false

# 1. Check Claude settings.json for Stitch MCP config
SETTINGS="$HOME/.claude/settings.json"
echo -n "Checking Stitch MCP configuration... "
if [ -f "$SETTINGS" ] && jq -e '.mcpServers.stitch' "$SETTINGS" > /dev/null 2>&1; then
  echo -e "${GREEN}OK${NC}"

  # Verify correct package name
  package_name=$(jq -r '.mcpServers.stitch.args[1] // ""' "$SETTINGS" 2>/dev/null)
  if [ "$package_name" = "@_davideast/stitch-mcp" ]; then
    echo -e "  Package: ${GREEN}$package_name${NC}"
  elif [ "$package_name" = "@anthropic/stitch-mcp" ]; then
    echo -e "  ${YELLOW}WARNING: Wrong package name '$package_name'${NC}"
    echo -e "  ${YELLOW}Should be '@_davideast/stitch-mcp'${NC}"
    echo -e "  ${YELLOW}Run: $SCRIPT_DIR/setup-stitch-mcp.sh to fix${NC}"
    errors=$((errors + 1))
  else
    echo -e "  Package: ${YELLOW}$package_name (unexpected)${NC}"
  fi
else
  echo -e "${RED}NOT CONFIGURED${NC}"
  echo -e "  Run: ${YELLOW}$SCRIPT_DIR/setup-stitch-mcp.sh${NC}"
  errors=$((errors + 1))
  needs_restart=true
fi

# 2. Check OAuth credentials
CREDS="$HOME/.config/stitch-mcp/credentials.json"
echo -n "Checking OAuth credentials... "
if [ -f "$CREDS" ]; then
  # Check if token is not expired (basic check)
  if jq -e '.access_token' "$CREDS" > /dev/null 2>&1; then
    echo -e "${GREEN}OK${NC}"
  else
    echo -e "${YELLOW}INVALID${NC}"
    echo -e "  Run: ${YELLOW}node $SCRIPT_DIR/setup-stitch-oauth.mjs${NC}"
    errors=$((errors + 1))
  fi
else
  echo -e "${RED}NOT FOUND${NC}"
  echo -e "  Run: ${YELLOW}node $SCRIPT_DIR/setup-stitch-oauth.mjs${NC}"
  errors=$((errors + 1))
fi

# 3. Check npm package availability
echo -n "Checking Stitch MCP package... "
if npm list -g @_davideast/stitch-mcp > /dev/null 2>&1; then
  version=$(npm list -g @_davideast/stitch-mcp --depth=0 2>/dev/null | grep stitch-mcp | sed 's/.*@//')
  echo -e "${GREEN}OK${NC} (v$version)"
else
  # Check if npx can find it (it will be downloaded on demand)
  echo -e "${YELLOW}Not installed globally${NC}"
  echo -e "  (npx will download on first use)"
fi

# 4. Check Node.js version
echo -n "Checking Node.js version... "
if command -v node &> /dev/null; then
  node_version=$(node --version | sed 's/v//')
  major_version=$(echo "$node_version" | cut -d. -f1)
  if [ "$major_version" -ge 18 ]; then
    echo -e "${GREEN}OK${NC} (v$node_version)"
  else
    echo -e "${RED}TOO OLD${NC} (v$node_version, need 18+)"
    errors=$((errors + 1))
  fi
else
  echo -e "${RED}NOT FOUND${NC}"
  errors=$((errors + 1))
fi

echo ""
echo "=== Summary ==="

if [ $errors -eq 0 ]; then
  echo -e "${GREEN}All checks passed!${NC}"
  exit 0
else
  echo -e "${RED}$errors issue(s) found${NC}"

  if $needs_restart; then
    echo -e "${YELLOW}Claude Code restart will be required after setup${NC}"
    exit 2
  fi
  exit 1
fi
