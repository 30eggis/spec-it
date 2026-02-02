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
    # macOS - prefer safe Terminal open via .command
    COMMAND_FILE="$(mktemp /tmp/spec-it-dashboard-XXXXXX.command)"
    if [[ -n "$SESSION_PATH" ]]; then
      printf '#!/bin/bash\nexec /usr/bin/env python3 "%s" "%s"\n' "$DASHBOARD_SCRIPT" "$SESSION_PATH" > "$COMMAND_FILE"
    else
      printf '#!/bin/bash\nexec /usr/bin/env python3 "%s"\n' "$DASHBOARD_SCRIPT" > "$COMMAND_FILE"
    fi
    chmod +x "$COMMAND_FILE"
    if ! open -a Terminal "$COMMAND_FILE"; then
      echo "ERROR: Failed to open dashboard terminal" >&2
      if [[ -n "$SESSION_PATH" ]]; then
        echo "Try running manually: python3 $DASHBOARD_SCRIPT $SESSION_PATH" >&2
      else
        echo "Try running manually: python3 $DASHBOARD_SCRIPT" >&2
      fi
      exit 1
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
    # Windows (Git Bash/MSYS/Cygwin)
    PY_CMD=""
    if command -v py &> /dev/null; then
      PY_CMD="py -3 -u"
    elif command -v python &> /dev/null; then
      PY_CMD="python -u"
    elif command -v python3 &> /dev/null; then
      PY_CMD="python3 -u"
    else
      echo "ERROR: Python not found in PATH" >&2
      echo "Install Python or run manually: python3 $DASHBOARD_SCRIPT $SESSION_PATH" >&2
      exit 1
    fi

    WIN_DASHBOARD_SCRIPT="$DASHBOARD_SCRIPT"
    WIN_SESSION_PATH="$SESSION_PATH"
    if command -v cygpath &> /dev/null; then
      WIN_DASHBOARD_SCRIPT="$(cygpath -w "$DASHBOARD_SCRIPT")"
      if [[ -n "$SESSION_PATH" ]]; then
        WIN_SESSION_PATH="$(cygpath -w "$SESSION_PATH")"
      fi
    fi

    CMD_LINE="$PY_CMD \"$WIN_DASHBOARD_SCRIPT\""
    if [[ -n "$WIN_SESSION_PATH" ]]; then
      CMD_LINE+=" \"$WIN_SESSION_PATH\""
    fi

    if command -v wt.exe &> /dev/null; then
      wt.exe -w 0 new-tab --title "spec-it Dashboard" cmd.exe /k "$CMD_LINE"
    elif command -v wt &> /dev/null; then
      wt -w 0 new-tab --title "spec-it Dashboard" cmd.exe /k "$CMD_LINE"
    else
      cmd.exe /c start "" cmd.exe /k "$CMD_LINE"
    fi
    ;;

  *)
    echo "Unsupported OS. Run manually:"
    echo "$DASHBOARD_SCRIPT $SESSION_PATH"
    exit 1
    ;;
esac

echo "Dashboard opened in new window"
