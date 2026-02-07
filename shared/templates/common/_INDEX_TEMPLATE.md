# _index.md Template

> Progressive Loading Policy: 에이전트는 폴더 진입 시 반드시 `_index.md`를 **먼저** 읽고, File Map의 "When to Read" 컬럼을 기준으로 **필요한 파일만** 선택적으로 읽는다.

## Template

```markdown
# {folder-name}

> {이 폴더의 목적을 1줄로 설명}

## Stats

| 항목 | 값 |
|------|---|
| Files | {N} |
| Total Lines | {N} |
| Created | {YYYY-MM-DD} |
| Phase | P{N} |
| Agent | {agent-name} |

## File Map

| # | File | Lines | Summary | When to Read |
|---|------|-------|---------|--------------|
| 1 | {filename}.md | {N} | {파일 내용 1줄 요약} | {이 파일을 읽어야 하는 조건} |
| 2 | {filename}.md | {N} | {파일 내용 1줄 요약} | {이 파일을 읽어야 하는 조건} |

## Key Decisions

- {이 폴더에서 확정된 핵심 결정 1}
- {이 폴더에서 확정된 핵심 결정 2}
- {이 폴더에서 확정된 핵심 결정 3}

## Dependencies

- ← Input: {이 폴더가 참조한 상위 폴더/파일}
- → Used by: {이 폴더를 참조하는 후속 Phase/폴더}
```

---

## Field Guide

### File Map > "When to Read" 작성 규칙

에이전트가 판단할 수 있도록 **구체적 조건**을 명시한다.

| 패턴 | 예시 | 의미 |
|------|------|------|
| Phase 참조 | `P3, P12에서 페르소나 참조 시` | 해당 Phase 작업 중일 때만 읽기 |
| 역할 참조 | `컴포넌트 스펙 작성 시` | 해당 역할 수행 중일 때만 읽기 |
| 조건부 | `baseproject 모드일 때만` | 조건 충족 시에만 읽기 |
| 항상 | `항상 (핵심 요약)` | 폴더 진입 시 반드시 읽기 |
| 필요 시 | `상세 구현 검토 시` | 개요로 부족할 때만 읽기 |

### Key Decisions 작성 규칙

- 개별 파일을 읽지 않아도 이 폴더의 **결론**을 알 수 있어야 한다
- 최소 2개, 최대 7개
- 결정의 "무엇"만 적고, "왜"는 개별 파일에 위임

### Dependencies 작성 규칙

- `←` 는 이 폴더의 입력 소스 (선행 Phase)
- `→` 는 이 폴더를 사용하는 후속 소비자 (후행 Phase)
- Phase 번호와 폴더명을 함께 표기

---

## Example: 01-personas/_index.md

```markdown
# 01-personas

> 시스템 사용자 유형별 페르소나 정의

## Stats

| 항목 | 값 |
|------|---|
| Files | 3 |
| Total Lines | 255 |
| Created | 2026-02-06 |
| Phase | P2 |
| Agent | persona-architect |

## File Map

| # | File | Lines | Summary | When to Read |
|---|------|-------|---------|--------------|
| 1 | persona-hr-admin.md | 120 | HR 관리자: 근태/급여 관리, 조직 설정 담당 | P3 경로설계, P7 와이어프레임, P12 테스트 시나리오 |
| 2 | persona-employee.md | 95 | 일반 직원: 출퇴근, 휴가 신청, 급여 확인 | P3 경로설계, P7 와이어프레임, P12 테스트 시나리오 |
| 3 | persona-comparison.md | 40 | 페르소나 간 권한/화면 접근 비교표 | 항상 (핵심 요약) |

## Key Decisions

- 2개 페르소나 확정: HR Admin (관리자), Employee (일반 직원)
- HR Admin은 전체 메뉴 접근, Employee는 개인 메뉴만 접근
- 뷰 모드 분리: /hr-admin/* vs /employee/*

## Dependencies

- ← Input: P1 00-analysis/_index.md, navigation-structure.md
- → Used by: P3 02-restructure (경로 설계), P7 wireframes (화면별 페르소나), P12 09-tests (시나리오)
```

---

## Validation Checklist

에이전트가 `_index.md` 작성 후 자체 검증:

- [ ] 1줄 요약이 폴더 목적을 명확히 설명하는가?
- [ ] File Map의 모든 파일이 실제 존재하는가?
- [ ] Lines 수가 실제와 일치하는가?
- [ ] When to Read가 구체적 조건인가? ("필요 시" 같은 모호한 표현 금지)
- [ ] Key Decisions만 읽어도 이 폴더의 결론을 알 수 있는가?
- [ ] Dependencies의 Phase 번호가 정확한가?
