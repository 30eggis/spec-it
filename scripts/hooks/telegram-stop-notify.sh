#!/bin/bash
# Telegram notification on session stop
# Sends last user prompt & claude output summary

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

stop_reason = d.get('stop_reason', '')
transcript = d.get('transcript', d.get('messages', []))

user_prompt = ''
claude_output = ''

if isinstance(transcript, list):
    for msg in reversed(transcript):
        role = msg.get('role', '')
        content = msg.get('content', '')
        if isinstance(content, list):
            texts = [c.get('text','') for c in content if isinstance(c, dict) and c.get('type') == 'text']
            content = ' '.join(texts)
        content = str(content).strip()
        if role == 'assistant' and not claude_output:
            claude_output = content[:300]
        elif role == 'user' and not user_prompt:
            user_prompt = content[:300]
        if user_prompt and claude_output:
            break

if not user_prompt:
    user_prompt = str(d.get('user_prompt', d.get('input', ''))).strip()[:300]
if not claude_output:
    msg = d.get('message', {})
    if isinstance(msg, dict):
        c = msg.get('content', '')
        if isinstance(c, list):
            texts = [x.get('text','') for x in c if isinstance(x, dict) and x.get('type') == 'text']
            claude_output = ' '.join(texts).strip()[:300]
        else:
            claude_output = str(c).strip()[:300]

emoji = '\u2705' if stop_reason == 'end_turn' else '\U0001f514'

lines = [f'{emoji} [Claude Code]']
if user_prompt:
    lines.append(f'\U0001f4dd User: {user_prompt}')
if claude_output:
    lines.append(f'\U0001f916 Claude: {claude_output}')
if not user_prompt and not claude_output:
    lines.append('Session stopped')

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
