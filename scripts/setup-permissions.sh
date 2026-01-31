#!/bin/bash
# setup-permissions.sh - Register required MCP tool permissions for frontend-skills plugin
# Run this after installing the plugin: ./scripts/setup-permissions.sh

set -e

SETTINGS_FILE="$HOME/.claude/settings.json"

# Required MCP permissions for this plugin
REQUIRED_PERMISSIONS=(
  "mcp__chrome-devtools__take_screenshot"
  "mcp__chrome-devtools__take_snapshot"
  "mcp__chrome-devtools__navigate_page"
  "mcp__chrome-devtools__new_page"
  "mcp__chrome-devtools__click"
  "mcp__chrome-devtools__fill"
  "mcp__chrome-devtools__fill_form"
  "mcp__chrome-devtools__wait_for"
  "mcp__chrome-devtools__list_pages"
  "mcp__chrome-devtools__select_page"
  "mcp__chrome-devtools__close_page"
  "mcp__chrome-devtools__evaluate_script"
  "mcp__chrome-devtools__list_console_messages"
  "mcp__chrome-devtools__get_console_message"
  "mcp__chrome-devtools__list_network_requests"
  "mcp__chrome-devtools__hover"
  "mcp__chrome-devtools__press_key"
  "mcp__chrome-devtools__drag"
  "mcp__chrome-devtools__emulate"
  "mcp__chrome-devtools__resize_page"
  "mcp__chrome-devtools__performance_start_trace"
  "mcp__chrome-devtools__performance_stop_trace"
  "mcp__stitch__*"
)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  frontend-skills: MCP Permission Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "ERROR: jq is required but not installed."
  echo "Install with: brew install jq"
  exit 1
fi

# Check if settings file exists
if [ ! -f "$SETTINGS_FILE" ]; then
  echo "Creating new settings file..."
  echo '{"permissions":{"allow":[]}}' > "$SETTINGS_FILE"
fi

# Backup settings
cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup.$(date +%Y%m%d-%H%M%S)"
echo "Backup created: $SETTINGS_FILE.backup.*"

# Get current permissions
CURRENT_PERMISSIONS=$(jq -r '.permissions.allow // []' "$SETTINGS_FILE")

# Add new permissions
ADDED=0
for perm in "${REQUIRED_PERMISSIONS[@]}"; do
  # Check if permission already exists
  if echo "$CURRENT_PERMISSIONS" | jq -e "index(\"$perm\")" > /dev/null 2>&1; then
    echo "  [SKIP] $perm (already exists)"
  else
    # Add permission
    jq --arg perm "$perm" '.permissions.allow += [$perm]' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
    mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
    echo "  [ADD]  $perm"
    ((ADDED++))
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setup Complete!"
echo "  - Added: $ADDED permissions"
echo "  - Total MCP permissions: ${#REQUIRED_PERMISSIONS[@]}"
echo ""
echo "  Restart Claude Code to apply changes."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
