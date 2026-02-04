# Phase 8: Validate

최종 코드 품질 검증 단계입니다.

## Overview

모든 구현과 테스트가 완료된 후, 전문가 수준의 코드 리뷰와 보안 검토를 수행합니다.

## Step 1: Code Review (code-reviewer)

**Best Practices Guide:** Vercel Agent Skills (`docs/refs/agent-skills/`)

### 2-Stage Review Process

**Stage 1: Spec Compliance (먼저)**
- 모든 요구사항이 구현되었는가?
- 누락된 기능이 있는가?
- 명세에 없는 추가 기능이 있는가? (Over-spec)

**Stage 2: Code Quality (Stage 1 통과 후)**
- Security analysis
- Code quality metrics
- Performance review
- **Vercel Best Practices check**:
  - Tailwind CSS (semantic spacing, responsive-first)
  - React/Next.js (server components, cache, dynamic imports)
  - Layout & Design (CSS Grid/Flexbox, color system)

### Severity Levels

| Level | Description | Action |
|-------|-------------|--------|
| CRITICAL | 보안 취약점 | 수정 필수, Phase 진행 차단 |
| HIGH | 버그, 주요 코드 스멜 | 수정 필수, Phase 진행 차단 |
| MEDIUM | 사소한 이슈, 성능 | 경고 로그, 진행 가능 |
| LOW | 스타일 제안 | 선택적, 진행 가능 |

## Step 2: Security Review (security-reviewer)

- OWASP Top 10 취약점 검사
- 하드코딩된 시크릿/크레덴셜 탐지
- 인증/권한 검사 검토
- 입력 검증 확인
- SQL Injection, XSS 방지 확인

## Agents

| Agent | Model | Role |
|-------|-------|------|
| code-reviewer | opus | Spec compliance + Code quality 2-stage review |
| security-reviewer | opus | Security audit (OWASP, secrets, auth) |

## 실패 시

1. `review-fix-tasks.json` 생성:
```json
{
  "source": "code-review-report.md",
  "sourcePhase": 8,
  "generatedAt": "...",
  "iteration": 1,
  "tasks": [
    {
      "id": "fix-001",
      "type": "security",
      "description": "SQL Injection 취약점 수정",
      "priority": "CRITICAL",
      "files": ["src/api/users.ts"],
      "errorDetail": "Unsanitized user input in query"
    },
    {
      "id": "fix-002",
      "type": "code-quality",
      "description": "에러 핸들링 누락",
      "priority": "HIGH",
      "files": ["src/services/payment.ts"],
      "errorDetail": "Unhandled promise rejection"
    }
  ]
}
```

2. **Phase 3 (Execute)로 회귀**:
```bash
/spec-it:dev-pilot {sessionId} --mode=fix --tasks=review-fix-tasks.json
```

3. Phase 4 → Phase 5 → Phase 6 → Phase 7 → Phase 8 순차 재검증
4. 최대 시도 횟수 초과 시 → `waiting` 상태, 사용자 개입 필요

## 회귀 포인트

**실패 시 → Phase 3 (Execute)로 회귀**

## Output

- Code review report
- Security review report
- Issue list with severity
