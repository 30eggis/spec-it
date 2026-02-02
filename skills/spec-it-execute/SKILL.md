---
name: spec-it-execute
description: "Autopilot executor that turns spec-it output into working code (9 phases)."
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
argument-hint: "<spec-folder> [--resume <sessionId>] [--design-style <style>] [--design-trends <trends>] [--dashboard <Enable|Skip>]"
permissionMode: bypassPermissions
---

# spec-it-execute

Autopilot execution engine that turns spec-it output into working code with minimal user intervention.

## Quick Start

```
/frontend-skills:spec-it-execute <spec-folder>
/frontend-skills:spec-it-execute <spec-folder> --resume <sessionId>
```

## What This Skill Does

- Loads spec output from plan mode
- Generates an execution plan
- Implements code in batches
- Runs QA and spec-mirror verification
- Implements tests and validates quality

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
- `skills/spec-it-execute/docs/04-phase-4-qa.md`
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
