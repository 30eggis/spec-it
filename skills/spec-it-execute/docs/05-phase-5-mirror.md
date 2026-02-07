# Phase 5: Spec-Mirror (Hard Gate)

Spec-it 산출물과 실제 구현을 비교하여 누락/불일치를 검출합니다.

## 목적

- Spec에 정의된 모든 기능이 구현되었는지 확인
- Over-spec (명세에 없는 추가 기능) 검출
- 구현 누락 항목 목록화

## 비교 기준 (executeMode 분기)

- If executeMode == "wireframe":
  - wireframe YAML vs 구현 코드 비교 (기존 동작)
  - wireframe prop adherence check 수행
  - screen-list.md 기반 전체 화면 구현 여부 검증
- If executeMode == "baseproject":
  - dev-plan 태스크 완료 여부 vs 구현 코드 비교
  - migration-plan 목표 달성 여부 검증
  - wireframe adherence check 스킵
  - 기존 코드 대비 리팩토링 목표 달성 여부 확인

## CRITICAL: Full Scope Verification (함축 금지)

**Phase 5는 전체 spec 대비 100% 구현을 검증합니다. 부분 구현은 무조건 FAIL입니다.**

### Scope Coverage Check (MANDATORY)

```yaml
scope_verification:
  step_1: Count screens in screen-list.md
  step_2: Count implemented page files in src/pages/
  step_3: FAIL if implemented < expected

  example:
    expected_screens: 25
    implemented_screens: 9
    verdict: FAIL - 16 screens missing (64% incomplete)
```

### Missing Screen Detection

```markdown
## SCOPE FAILURE - Missing Screens

| Expected Screen | Spec Location | Implemented? |
|-----------------|---------------|--------------|
| HR Dashboard | SCR-HR-001 | ✓ |
| Attendance Records | SCR-HR-002 | ✓ |
| Leave Management | SCR-HR-003 | ✓ |
| Business Trip | SCR-HR-005 | ✗ MISSING |
| Work Rules | SCR-HR-006 | ✗ MISSING |
| Company Settings | SCR-HR-008 | ✗ MISSING |
| Reports Overview | SCR-HR-010 | ✗ MISSING |
| Settings | SCR-HR-015 | ✗ MISSING |
...

VERDICT: FAIL - 16/25 screens missing
```

### Feature Completeness Check

For EACH implemented screen, verify:

```yaml
per_screen_check:
  - all_widgets_from_wireframe_present
  - all_buttons_functional
  - all_labels_match_spec_language  # Korean if spec is Korean
  - all_interactions_working
  - all_states_handled (loading/error/empty)
```

### Language Verification

```yaml
language_check:
  if_spec_language: Korean
  then_implementation_must_use: Korean

  violations:
    - "HR Dashboard" should be "HR 대시보드" → FAIL
    - "John Smith" should be "김철수" → FAIL
    - "Department" should be "조직" → FAIL
```

### Wireframe Prop Adherence Check (NEW)

For EACH implemented component, verify:

```yaml
prop_adherence_check:
  step_1: Extract props from wireframe YAML
  step_2: Compare against implemented code
  step_3: Flag ANY deviation as FAIL

  example_check:
    wireframe_props:
      label: "출근 인원"
      iconBg: "green-100"
      value: "287"

    implementation_must_have:
      label: "출근 인원"    # ✓ or ✗
      iconBg: "green-100"  # ✓ or ✗
      value: "287"         # ✓ or ✗

    violations:
      - label="Present" instead of "출근 인원" → FAIL
      - colorClass="success" instead of iconBg="green-100" → FAIL
      - Using different value → FAIL
```

### Structure Adherence Check

```yaml
structure_check:
  if_wireframe_has: "progress bar"
  then_implementation_must_have: "progress bar"
  not_allowed: "badge replacement" or "text only"

  if_wireframe_has: "5 stat cards"
  then_implementation_must_have: "exactly 5 stat cards"
  not_allowed: "4 cards" or "6 cards"

  if_wireframe_has: "action button '알림 일괄 발송'"
  then_implementation_must_have: "button with text '알림 일괄 발송'"
  not_allowed: "omitted" or "renamed"
```

### Mirror Report Enhancement

MIRROR_REPORT.md now includes:

```markdown
## Wireframe Adherence Issues

### Label Mismatches
| Screen | Component | Wireframe | Implementation | Status |
|--------|-----------|-----------|----------------|--------|
| SCR-HR-001 | StatCard | "출근 인원" | "Present" | ❌ FAIL |
| SCR-HR-001 | FilterBar | "조직" | "Department" | ❌ FAIL |

### Color Mismatches
| Screen | Component | Wireframe | Implementation | Status |
|--------|-----------|-----------|----------------|--------|
| SCR-HR-001 | StatCard | iconBg: "green-100" | styles.present | ⚠️ CHECK |

### Structure Mismatches
| Screen | Component | Wireframe | Implementation | Status |
|--------|-----------|-----------|----------------|--------|
| SCR-HR-001 | OvertimeRisk | progress bar | text + badge | ❌ FAIL |

### Mock Data Mismatches
| Screen | Component | Wireframe | Implementation | Status |
|--------|-----------|-----------|----------------|--------|
| SCR-HR-001 | AttendanceGap | "김철수" | "John Smith" | ❌ FAIL |
```

## Process

```
spec-mirror skill 실행
       │
       ▼
┌──────────────────────────────────────────────────────────────┐
│  비교 대상                                                    │
│                                                              │
│  Spec (Input)              Implementation (Actual)          │
│  ├── 03-components/    vs  ├── src/components/              │
│  ├── 04-scenarios/     vs  ├── src/ (기능 구현)              │
│  └── 02-wireframes/    vs  └── src/ (testId, 레이아웃)       │
└──────────────────────────────────────────────────────────────┘
       │
       ▼
docs/MIRROR_REPORT.md 생성
```

## Output: MIRROR_REPORT.md

```markdown
# Spec Mirror Report

## Summary
- Total Requirements: 25
- Implemented: 22
- Missing: 3
- Over-spec: 1

## Missing Items
| ID | Spec Location | Description | Priority |
|----|---------------|-------------|----------|
| M1 | 03-components/button.md | disabled 상태 미구현 | HIGH |
| M2 | 04-scenarios/login.md | 비밀번호 찾기 흐름 누락 | HIGH |
| M3 | 02-wireframes/dashboard.yaml | sidebar toggle 미구현 | MEDIUM |

## Over-spec Items
| ID | Location | Description | Action |
|----|----------|-------------|--------|
| O1 | src/components/Button.tsx | loading prop (spec에 없음) | Review needed |

## Verdict
FAIL - 3 missing items found
```

## 실패 시 흐름

### Step 1: mirror-report-tasks.json 생성

MIRROR_REPORT.md에서 누락 항목을 추출하여 별도 태스크 파일 생성:

```json
// .spec-it/{sessionId}/execute/mirror-report-tasks.json
{
  "source": "docs/MIRROR_REPORT.md",
  "generatedAt": "2026-02-04T12:00:00Z",
  "iteration": 1,
  "tasks": [
    {
      "id": "fix-001",
      "type": "missing",
      "specRef": "03-components/button.md",
      "description": "Button disabled 상태 구현",
      "priority": "HIGH",
      "files": ["src/components/Button.tsx"]
    },
    {
      "id": "fix-002",
      "type": "missing",
      "specRef": "04-scenarios/login.md",
      "description": "비밀번호 찾기 흐름 구현",
      "priority": "HIGH",
      "files": ["src/pages/ForgotPassword.tsx", "src/api/auth.ts"]
    }
  ]
}
```

**Note:** task-registry.json (Phase 1 산출물)은 불변 유지

### Step 2: Phase 3 재실행 (보완 구현)

dev-pilot 재실행 시 입력:
- `task-registry.json` - 참조용 (원본 컨텍스트)
- `mirror-report-tasks.json` - 실행 대상 (보완 태스크)

```
dev-pilot --mode=補完 --tasks=mirror-report-tasks.json
```

### Step 3: Phase 4 재실행 (Bringup)

보완된 코드의 lint/typecheck/build 확인

### Step 4: Phase 5 재실행 (Spec-Mirror)

다시 비교하여 누락 항목이 해결되었는지 확인

### 반복 시 파일 관리

```
.spec-it/{sessionId}/execute/
├── task-registry.json           ← Phase 1 산출물 (불변)
├── mirror-report-tasks.json     ← 1차 실패 시 생성
├── mirror-report-tasks-2.json   ← 2차 실패 시 생성
└── mirror-report-tasks-3.json   ← 3차 실패 시 생성
```

### 최대 시도 초과 시

- N회 초과 → `waiting` 상태
- 사용자 개입 필요:
  1. 수동으로 누락 기능 구현
  2. 또는 spec 수정 (기능 제외)
  3. `--resume`으로 재시작

## 재실행 흐름 요약

| 단계 | 동작 |
|------|------|
| Phase 5 FAIL | MIRROR_REPORT.md → mirror-report-tasks.json 생성 |
| **→ Phase 3** | dev-pilot이 mirror-report-tasks.json 실행 (보완) |
| → Phase 4 | Bringup 재검증 (lint/type/build) |
| → Phase 5 | Spec-Mirror 재검증 |
| 최대 N회 | 초과 시 waiting, 사용자 개입 |

## 회귀 포인트

**실패 시 → Phase 3 (Execute)로 회귀**

## Script

```bash
scripts/spec-mirror/run-spec-mirror.sh "$(pwd)"
```

## Skill

```
Skill(skill="spec-mirror", args="{sessionId}")
```
