---
name: spec-it-execute
description: "Autopilot executor that turns spec-it output into working code (10 phases: 0-9)."
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
argument-hint: "<spec-folder> [--resume <sessionId>] [--design-style <style>] [--design-trends <trends>] [--dashboard <Enable|Skip>]"
permissionMode: bypassPermissions
---

# spec-it-execute

Autopilot execution engine that turns spec-it output into working code with minimal user intervention.

## Quick Start

```
/spec-it:spec-it-execute <spec-folder>
/spec-it:spec-it-execute <spec-folder> --resume <sessionId>
```

## What This Skill Does

- Loads spec output from plan mode (P1-P14)
- Generates an execution plan with validation
- Implements code via **dev-pilot** (parallel workers)
- Runs QA via **ultraqa** (unit/e2e test cycles)
- Validates with **Vercel Best Practices** code review
- Auto-regresses to Phase 3 on any Hard Gate failure

## Phase Overview (0-9)

| Phase | Role | Skill | Hard Gate |
|-------|------|-------|-----------|
| 0 | Initialize | bash-executor | - |
| 1 | Load | - | - |
| 2 | Plan | - | - |
| 3 | Execute | **dev-pilot** | - |
| 4 | Bringup | bash-executor | **Yes** → 3 |
| 5 | Spec-Mirror | **spec-mirror** | **Yes** → 3 |
| 6 | Unit Tests | **ultraqa** (unit) | **Yes** → 3 |
| 7 | E2E Tests | **ultraqa** (e2e) | **Yes** → 3 |
| 8 | Validate | - | **Yes** → 3 |
| 9 | Complete | - | - |

## Key Sub-Skills

| Skill | Phase | Description |
|-------|-------|-------------|
| `dev-pilot` | 3 | Parallel autopilot with file ownership (up to 5 workers) |
| `spec-mirror` | 5 | Spec compliance verification |
| `ultraqa` | 6, 7 | Test cycle orchestration (test → verify → fix → repeat) |

## Regression Flow (Fix Mode)

All Hard Gate failures (Phase 4-8) regress to Phase 3:

```
Phase N FAIL → {type}-fix-tasks.json → dev-pilot --mode=fix → Phase 4 → ... → Phase N
```

| Phase | Fix Task File |
|-------|---------------|
| 4 | fix-tasks.json |
| 5 | mirror-report-tasks.json |
| 6 | test-fix-tasks.json |
| 7 | e2e-fix-tasks.json |
| 8 | review-fix-tasks.json |

## Setup Intake (Only if Missing)

If design style or dashboard preference is already provided (args or prior spec meta), do NOT ask again.

```
designStyle = args.designStyle or userRequest
designTrends = args.designTrends or userRequest
dashboard = args.dashboard or userRequest

questions = []

IF designStyle missing:
  questions += {
    question: "어떤 디자인 스타일을 적용하시겠습니까? (2026 Design Trends 기반)",
    header: "Design Style",
    options: [
      {label: "Minimal (Recommended)", description: "밝은 테마, 미니멀 카드"},
      {label: "Immersive", description: "다크 테마, 그라데이션, 네온 포인트"},
      {label: "Organic", description: "Glassmorphism, 부드러운 곡선"},
      {label: "Custom", description: "직접 트렌드 선택"},
      {label: "Custom File", description: "직접 스타일 파일 경로 지정"}
    ]
  }

IF dashboard missing:
  questions += {
    question: "웹 대시보드를 사용할까요?",
    header: "Dashboard",
    options: [
      {label: "Enable", description: "Web dashboard 사용"},
      {label: "Skip", description: "대시보드 없이 진행"}
    ]
  }

IF questions not empty:
  AskUserQuestion(questions)

IF designStyle == "Custom":
  AskUserQuestion(
    questions: [{
      question: "적용할 디자인 트렌드를 선택하세요",
      header: "Trends",
      multiSelect: true,
      options: [
        {label: "Dark Mode+", description: "어두운 테마 + 적응형 색상"},
        {label: "Light Skeuomorphism", description: "부드러운 그림자, Neumorphic"},
        {label: "Glassmorphism", description: "반투명 배경 + blur"},
        {label: "Micro-Animations", description: "의미있는 모션"},
        {label: "3D Visuals", description: "3D 아이콘, WebGL"},
        {label: "Gamification", description: "Progress rings, 배지"}
      ]
    }]
  )

IF designStyle == "Custom File":
  AskUserQuestion(
    questions: [{
      question: "디자인 트렌드 파일 경로를 입력하세요",
      header: "Custom File",
      options: []
    }]
  )

# Persist to execute meta when available
_meta.designStyle = selectedStyle
_meta.designTrends = selectedTrends or designTrends
_meta.dashboardEnabled = dashboard
```

## Doc Index (progressive loading)

- `skills/spec-it-execute/docs/00-overview.md`
- `skills/spec-it-execute/docs/01-rules.md`
- `skills/spec-it-execute/docs/02-phase-0-2-init-load-plan.md`
- `skills/spec-it-execute/docs/03-phase-3-execute.md`
- `skills/spec-it-execute/docs/04-phase-4-bringup.md`
- `skills/spec-it-execute/docs/05-phase-5-mirror.md`
- `skills/spec-it-execute/docs/06-phase-6-unit-tests.md`
- `skills/spec-it-execute/docs/07-phase-7-e2e.md`
- `skills/spec-it-execute/docs/08-phase-8-validate.md`
- `skills/spec-it-execute/docs/09-phase-9-complete.md`
- `skills/spec-it-execute/docs/10-live-preview.md`
- `skills/spec-it-execute/docs/11-model-routing.md`
- `skills/spec-it-execute/docs/12-state-schema.md`
- `skills/spec-it-execute/docs/13-error-recovery.md`
- `skills/spec-it-execute/docs/14-agents.md`

## Critical Rules (must follow)

- No phase skipping. Phases must execute in order.
- Phase completion uses `scripts/core/status-update.sh` only.
- QA, Spec-Mirror, and E2E are hard gates. Failures stop execution.
- Main orchestrator must not write files via Bash redirection.

See full details in `skills/spec-it-execute/docs/01-rules.md`.

## CRITICAL: Full Scope Implementation (함축 금지)

**ALL chapters and screens MUST be implemented. NO MVP-only approach.**

### Scope Rules

1. **NO Priority-Based Exclusion**
   - P0, P1, P2 are execution ORDER, not exclusion criteria
   - ALL priorities must be implemented in a single execution

2. **ALL Chapters Required**
   ```
   ❌ WRONG: "Implementing CH-00 to CH-06 (MVP)"
   ✅ CORRECT: Implementing CH-00 to CH-N (ALL chapters)
   ```

3. **ALL Screens Required**
   ```
   ❌ WRONG: "14 screens implemented out of 25"
   ✅ CORRECT: All 25 screens + 9 modals implemented
   ```

4. **Phase 2 Scope Gate**
   - dev-plan MUST include ALL chapters from chapter-plan-final.md
   - dev-plan MUST include ALL screens from screen-list.md
   - If scope reduction detected → REJECT and regenerate

5. **Phase 5 (Spec-Mirror) Verification**
   - Compare implementation against FULL spec
   - Flag ANY missing screens as FAIL
   - Flag ANY missing features within screens as FAIL

### Scope Verification Checkpoints

| Phase | Check | Action if Fail |
|-------|-------|----------------|
| 2 | All chapters in dev-plan? | REJECT, regenerate plan |
| 2 | All screens in dev-plan? | REJECT, regenerate plan |
| 3 | All tasks executed? | Continue until complete |
| 5 | All screens implemented? | FAIL → Phase 3 regression |
| 5 | All features per screen? | FAIL → Phase 3 regression |

### Violation Handling

If scope reduction is detected at ANY phase:
1. Log: "SCOPE VIOLATION: {details}"
2. Reject current phase output
3. Regenerate with FULL scope requirement
4. Do NOT proceed until 100% scope coverage
