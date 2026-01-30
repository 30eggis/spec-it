#!/bin/bash
# Cross-platform notification for permission requests
# Supports: macOS (osascript), Windows (PowerShell toast), Linux (notify-send)

# Read stdin (hook input JSON)
INPUT=$(cat)

# Extract tool name from JSON using pure bash
TOOL_NAME=""
if [[ "$INPUT" =~ \"tool_name\":\"([^\"]+)\" ]]; then
    TOOL_NAME="${BASH_REMATCH[1]}"
fi

TITLE="spec-it: Permission Required"
MESSAGE="Claude needs approval for: ${TOOL_NAME:-action}"

# Detect OS and send notification
send_notification() {
    local title="$1"
    local message="$2"

    case "$(uname -s)" in
        Darwin)
            # macOS - use osascript
            osascript -e "display notification \"$message\" with title \"$title\" sound name \"Submarine\""
            ;;
        MINGW*|MSYS*|CYGWIN*|Windows_NT)
            # Windows - use PowerShell toast notification
            powershell.exe -NoProfile -Command "
                [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
                [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
                \$template = @'
<toast>
    <visual>
        <binding template=\"ToastText02\">
            <text id=\"1\">$title</text>
            <text id=\"2\">$message</text>
        </binding>
    </visual>
    <audio src=\"ms-winsoundevent:Notification.Default\"/>
</toast>
'@
                \$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
                \$xml.LoadXml(\$template)
                \$toast = [Windows.UI.Notifications.ToastNotification]::new(\$xml)
                [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('spec-it').Show(\$toast)
            " 2>/dev/null
            ;;
        Linux)
            # Linux - use notify-send if available
            if command -v notify-send &>/dev/null; then
                notify-send "$title" "$message" -u normal
            fi
            ;;
    esac
}

send_notification "$TITLE" "$MESSAGE"

# Return empty JSON (no decision modification)
echo '{}'
