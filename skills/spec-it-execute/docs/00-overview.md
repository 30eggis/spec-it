# Overview

spec-it-execute converts a spec-it plan output into a working implementation with verification.

## Inputs

- Spec folder from plan mode (typically `tmp/06-final/`)

## Outputs

- Updated codebase
- Logs, reviews, screenshots under `.spec-it/{sessionId}/execute/`

## Phase Map

| Phase | Name | Description |
|-------|------|-------------|
| 0 | Initialize | 세션 초기화, 상태 파일 생성 |
| 1 | Load | spec-it 산출물 로드, task-registry 추출 |
| 2 | Plan | 실행 계획 생성 및 검증 |
| 3 | Execute | 코드 구현 (dev-pilot 병렬 실행) |
| 4 | Bringup | 코드 생존 확인 (lint, typecheck, build) |
| 5 | Spec-Mirror | Spec vs 구현 비교 검증 |
| 6 | Unit Tests | 단위 테스트 작성 및 실행 |
| 7 | E2E | E2E 테스트 작성 및 실행 |
| 8 | Validate | Code Review + Security Review |
| 9 | Complete | 최종 정리 및 요약 |

## Progressive Loading

Each phase has its own doc in `skills/spec-it-execute/docs/` so the orchestrator can load only what it needs.
