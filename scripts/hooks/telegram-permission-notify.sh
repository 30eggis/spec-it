#!/bin/bash
# Telegram notification when Claude needs permission approval

source "$(dirname "$0")/telegram-config.sh"
_load_telegram_config || exit 0

INPUT=$(cat)

echo "$INPUT" | python3 -c "
import sys, json, urllib.request, os

BOT_TOKEN = os.environ['TELEGRAM_BOT_TOKEN']
CHAT_ID = os.environ['TELEGRAM_CHAT_ID']

try:
    d = json.load(sys.stdin)
except:
    sys.exit(0)

tool_name = d.get('tool_name', 'unknown')
tool_input = d.get('tool_input', {})

command = ''
if isinstance(tool_input, dict):
    command = tool_input.get('command', tool_input.get('description', ''))
if isinstance(command, str):
    command = command[:200]

lines = ['\u23f3 [Claude Code] Permission Required']
lines.append(f'Tool: {tool_name}')
if command:
    lines.append(f'Command: {command}')

text = '\n'.join(lines)

payload = json.dumps({
    'chat_id': CHAT_ID,
    'text': text,
    'disable_notification': False
}).encode('utf-8')

req = urllib.request.Request(
    f'https://api.telegram.org/bot{BOT_TOKEN}/sendMessage',
    data=payload,
    headers={'Content-Type': 'application/json'}
)
try:
    urllib.request.urlopen(req, timeout=5)
except:
    pass
" 2>/dev/null

exit 0
