#!/bin/bash
# Open spec-it dashboard in a new terminal window
# Usage: ./open-dashboard.sh [session_path]
#
# Examples:
#   ./open-dashboard.sh                           # Auto-detect latest session
#   ./open-dashboard.sh ./tmp/20260130-123456     # Specific session

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Use Python curses dashboard (no flickering)
DASHBOARD_SCRIPT="$SCRIPT_DIR/dashboard.py"
SESSION_PATH="${1:-}"

# Detect OS and open new terminal
case "$(uname -s)" in
  Darwin)
    # macOS - use osascript to open new Terminal window
    if [[ -n "$SESSION_PATH" ]]; then
      if ! osascript <<EOF
tell application "Terminal"
  activate
  do script "python3 '$DASHBOARD_SCRIPT' '$SESSION_PATH'"
  set custom title of front window to "spec-it Dashboard"
end tell
EOF
      then
        echo "ERROR: Failed to open dashboard terminal" >&2
        echo "Try running manually: python3 $DASHBOARD_SCRIPT $SESSION_PATH" >&2
        exit 1
      fi
    else
      if ! osascript <<EOF
tell application "Terminal"
  activate
  do script "python3 '$DASHBOARD_SCRIPT'"
  set custom title of front window to "spec-it Dashboard"
end tell
EOF
      then
        echo "ERROR: Failed to open dashboard terminal" >&2
        echo "Try running manually: python3 $DASHBOARD_SCRIPT" >&2
        exit 1
      fi
    fi
    ;;

  Linux)
    # Linux - try common terminal emulators
    if command -v gnome-terminal &> /dev/null; then
      gnome-terminal --title="spec-it Dashboard" -- bash -c "'$DASHBOARD_SCRIPT' '$SESSION_PATH'; exec bash"
    elif command -v xterm &> /dev/null; then
      xterm -title "spec-it Dashboard" -e "'$DASHBOARD_SCRIPT' '$SESSION_PATH'" &
    elif command -v konsole &> /dev/null; then
      konsole --new-tab -e "'$DASHBOARD_SCRIPT' '$SESSION_PATH'" &
    else
      echo "No supported terminal emulator found. Run manually:"
      echo "$DASHBOARD_SCRIPT $SESSION_PATH"
      exit 1
    fi
    ;;

  MINGW*|CYGWIN*|MSYS*)
    # Windows
    if [[ -n "$SESSION_PATH" ]]; then
      start cmd /k "$DASHBOARD_SCRIPT" "$SESSION_PATH"
    else
      start cmd /k "$DASHBOARD_SCRIPT"
    fi
    ;;

  *)
    echo "Unsupported OS. Run manually:"
    echo "$DASHBOARD_SCRIPT $SESSION_PATH"
    exit 1
    ;;
esac

echo "Dashboard opened in new window"
