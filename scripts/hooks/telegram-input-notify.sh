#!/bin/bash
# Telegram notification when Claude waits for user input
# Triggers on: AskUserQuestion, ExitPlanMode

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

lines = []

if tool_name == 'AskUserQuestion':
    lines.append('\u2753 [Claude Code] Question')
    questions = tool_input.get('questions', [])
    for q in questions[:3]:
        question_text = q.get('question', '')
        if question_text:
            lines.append(question_text[:200])
        options = q.get('options', [])
        opts = [o.get('label', '') for o in options if isinstance(o, dict)]
        if opts:
            lines.append('  -> ' + ' | '.join(opts))

elif tool_name == 'ExitPlanMode':
    lines.append('\U0001f4cb [Claude Code] Plan Approval')
    lines.append('Plan is ready for review.')

else:
    lines.append('\u23f8\ufe0f [Claude Code] Waiting')
    lines.append(f'Tool: {tool_name}')

if not lines:
    sys.exit(0)

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
