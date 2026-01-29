#!/bin/bash
# SPEC-IT Dashboard 설치 스크립트
# 실행: bash install.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DASHBOARD_SCRIPT="${SCRIPT_DIR}/spec-it-dashboard.sh"

echo "SPEC-IT Dashboard 설치"
echo "========================"

# Make executable
chmod +x "$DASHBOARD_SCRIPT"
echo "✓ 실행 권한 설정 완료"

# Create symlink in /usr/local/bin (optional)
if [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
    ln -sf "$DASHBOARD_SCRIPT" /usr/local/bin/spec-it-dashboard
    echo "✓ /usr/local/bin/spec-it-dashboard 심볼릭 링크 생성"
    echo ""
    echo "사용법:"
    echo "  spec-it-dashboard              # 자동 감지"
    echo "  spec-it-dashboard ./tmp/xxx    # 특정 세션"
else
    echo ""
    echo "전역 명령어 설정 (선택사항):"
    echo "  sudo ln -sf '$DASHBOARD_SCRIPT' /usr/local/bin/spec-it-dashboard"
fi

echo ""
echo "또는 alias 추가 (~/.zshrc 또는 ~/.bashrc):"
echo "  alias spec-it-dashboard='$DASHBOARD_SCRIPT'"
echo ""
echo "설치 완료!"
