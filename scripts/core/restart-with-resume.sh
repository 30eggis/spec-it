#!/bin/bash
# restart-with-resume.sh - Restart Claude Code and resume spec-it session
# Usage: restart-with-resume.sh <sessionId> <skillName>
# Example: restart-with-resume.sh 20260130-143215 spec-it-automation

set -e

SESSION_ID="$1"
SKILL_NAME="${2:-spec-it-automation}"
WORKING_DIR="${3:-$(pwd)}"

if [ -z "$SESSION_ID" ]; then
  echo "ERROR: SESSION_ID required"
  echo "Usage: restart-with-resume.sh <sessionId> [skillName] [workingDir]"
  exit 1
fi

RESUME_CMD="/frontend-skills:$SKILL_NAME --resume $SESSION_ID"

# Detect OS and open new terminal with claude
case "$(uname -s)" in
  Darwin)
    # macOS - use osascript to open Terminal and run command
    osascript << EOF
tell application "Terminal"
  activate
  do script "cd '$WORKING_DIR' && echo 'Resuming $SKILL_NAME session: $SESSION_ID' && echo '' && echo 'Run this command:' && echo '$RESUME_CMD' && echo '' && claude"
end tell
EOF
    ;;
  Linux)
    # Linux - try various terminal emulators
    if command -v gnome-terminal &> /dev/null; then
      gnome-terminal -- bash -c "cd '$WORKING_DIR' && echo 'Run: $RESUME_CMD' && claude; exec bash"
    elif command -v xterm &> /dev/null; then
      xterm -e "cd '$WORKING_DIR' && echo 'Run: $RESUME_CMD' && claude" &
    elif command -v konsole &> /dev/null; then
      konsole -e bash -c "cd '$WORKING_DIR' && echo 'Run: $RESUME_CMD' && claude"
    else
      echo "No supported terminal found. Please run manually:"
      echo "  cd $WORKING_DIR && claude"
      echo "  Then type: $RESUME_CMD"
    fi
    ;;
  *)
    echo "Unsupported OS. Please run manually:"
    echo "  cd $WORKING_DIR && claude"
    echo "  Then type: $RESUME_CMD"
    ;;
esac

# Copy command to clipboard for easy paste
if command -v pbcopy &> /dev/null; then
  echo "$RESUME_CMD" | pbcopy
  echo "CLIPBOARD: Resume command copied!"
elif command -v xclip &> /dev/null; then
  echo "$RESUME_CMD" | xclip -selection clipboard
  echo "CLIPBOARD: Resume command copied!"
fi

echo "RESTART_INITIATED"
echo "SESSION_ID:$SESSION_ID"
echo "SKILL:$SKILL_NAME"
echo "RESUME_CMD:$RESUME_CMD"
