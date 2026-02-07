#!/bin/bash
# Shared Telegram config loader
# Reads from ~/.claude/hooks/spec-it/telegram-config.js
# Usage: source telegram-config.sh; _load_telegram_config || exit 0

_load_telegram_config() {
    local config="$HOME/.claude/hooks/spec-it/telegram-config.js"
    [ ! -f "$config" ] && return 1

    eval $(python3 -c "
import re
try:
    with open('$config') as f:
        c = f.read()
    b = re.search(r'botToken:\s*\"([^\"]+)\"', c)
    i = re.search(r'chatId:\s*\"([^\"]+)\"', c)
    if b and i:
        print(f'TELEGRAM_BOT_TOKEN=\"{b.group(1)}\"')
        print(f'TELEGRAM_CHAT_ID=\"{i.group(1)}\"')
except:
    pass
" 2>/dev/null)

    [ -z "$TELEGRAM_BOT_TOKEN" ] && return 1
    [ -z "$TELEGRAM_CHAT_ID" ] && return 1
    export TELEGRAM_BOT_TOKEN TELEGRAM_CHAT_ID
    return 0
}
