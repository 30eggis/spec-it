# Phase 4: Bringup (Hard Gate)

코드가 "숨을 쉬는지" 확인하는 기본 검증 단계입니다.

## 목적

구현된 코드의 기본적인 생존 여부를 확인합니다:
- 린트 에러 없이 코드 스타일 준수
- 타입 에러 없이 컴파일 가능
- 프로덕션 빌드 성공

## 실행 항목

| 항목 | 실행 | 역할 |
|------|------|------|
| lint | ✓ | ESLint 코드 스타일/문법 검사 |
| typecheck | ✓ | TypeScript 타입 검사 |
| test | ✗ Skip | Phase 6에서 테스트 코드 작성 후 실행 |
| build | ✓ | 프로덕션 빌드 가능 여부 |

## Process

```
lint 실패 ──► dev-build-fixer 수정 시도 ──► 재실행 (최대 N회)
    │
    ▼ 성공
typecheck 실패 ──► dev-build-fixer 수정 시도 ──► 재실행
    │
    ▼ 성공
build 실패 ──► dev-build-fixer 수정 시도 ──► 재실행
    │
    ▼ 성공
Phase 5 진행
```

## Script

```bash
# --skip-test: 테스트 코드가 Phase 6에서 작성되므로 스킵
scripts/qa/run-qa.sh "$(pwd)" --skip-test
```

## 실패 시

1. `fix-tasks.json` 생성:
```json
{
  "source": "bringup-report.md",
  "sourcePhase": 4,
  "generatedAt": "...",
  "iteration": 1,
  "tasks": [
    {
      "id": "fix-001",
      "type": "build-error",
      "description": "TypeScript 타입 에러 수정",
      "priority": "HIGH",
      "files": ["src/components/Button.tsx"],
      "errorDetail": "Property 'disabled' does not exist..."
    }
  ]
}
```

2. **Phase 3 (Execute)로 회귀**:
```bash
/spec-it:dev-pilot {sessionId} --mode=fix --tasks=fix-tasks.json
```

3. Phase 4 재검증
4. 최대 시도 횟수 초과 시 `waiting` 상태, 사용자 개입 필요

## 다음 단계와의 관계

| Phase | 역할 |
|-------|------|
| Phase 4 (Bringup) | 코드 생존 확인 (lint, type, build) |
| Phase 5 (Spec-Mirror) | Spec 준수 확인 |
| Phase 6 (Unit Tests) | 테스트 작성 + 실행 |
| Phase 8 (Validate) | Code Review + Security Review |
