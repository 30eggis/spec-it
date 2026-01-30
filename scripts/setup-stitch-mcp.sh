#!/bin/bash
# Setup Stitch MCP server in Claude Code settings
# Usage: ./setup-stitch-mcp.sh [--check-only]

SETTINGS_FILE="$HOME/.claude/settings.json"
STITCH_CONFIG='{
  "command": "npx",
  "args": ["-y", "@anthropic/stitch-mcp"]
}'

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_only=false
if [[ "$1" == "--check-only" ]]; then
  check_only=true
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo -e "${YELLOW}jq not found. Installing...${NC}"
  if command -v brew &> /dev/null; then
    brew install jq
  elif command -v apt-get &> /dev/null; then
    sudo apt-get install -y jq
  else
    echo -e "${RED}Error: Cannot install jq. Please install it manually.${NC}"
    exit 1
  fi
fi

# Check if settings.json exists
if [[ ! -f "$SETTINGS_FILE" ]]; then
  if $check_only; then
    echo -e "${RED}settings.json not found${NC}"
    exit 1
  fi

  echo -e "${YELLOW}Creating settings.json...${NC}"
  mkdir -p "$HOME/.claude"
  echo '{"mcpServers": {}}' > "$SETTINGS_FILE"
fi

# Check if stitch is already configured
if jq -e '.mcpServers.stitch' "$SETTINGS_FILE" > /dev/null 2>&1; then
  echo -e "${GREEN}✓ Stitch MCP already configured${NC}"
  exit 0
fi

if $check_only; then
  echo -e "${YELLOW}Stitch MCP not configured${NC}"
  exit 1
fi

# Add stitch to mcpServers
echo -e "${YELLOW}Adding Stitch MCP to settings.json...${NC}"

# Create backup
cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"

# Add stitch configuration
jq --argjson stitch "$STITCH_CONFIG" '.mcpServers.stitch = $stitch' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" \
  && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"

if [[ $? -eq 0 ]]; then
  echo -e "${GREEN}✓ Stitch MCP configured successfully${NC}"
  echo -e "${YELLOW}⚠️ Please restart Claude Code for changes to take effect${NC}"
  exit 0
else
  echo -e "${RED}Error: Failed to update settings.json${NC}"
  mv "$SETTINGS_FILE.backup" "$SETTINGS_FILE"
  exit 1
fi
