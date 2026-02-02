---
name: spec-it-fast-launch
description: "Fast wireframe generator with design trends for rapid prototyping."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
---

# spec-it-fast-launch: Fast Launch Mode

Transform PRD/vibe-coding into frontend wireframes with **minimal process** and **design trends applied**.

**Auto-Execute:** After spec generation, automatically proceeds to `spec-it-execute` for implementation.

## What's Skipped

| Skipped | Reason |
|---------|--------|
| Chapter-by-chapter brainstorming | Direct to wireframes |
| Multi-critic debate | No deep analysis |
| Component inventory/migration/new spec | Skip component design |
| Critical review, ambiguity detection | Skip review phase |
| Test specification | Skip test design |

## What's Kept

| Kept | Reason |
|------|--------|
| Design Style Selection | Apply design-trends-2026 |
| UI Architecture (wireframes) | Core output |
| Design Direction in wireframes | Test design trends |
| Minimal QA (lint/typecheck) | Prevent obvious build breaks |

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).
See [shared/rules/50-question-policy.md](../shared/rules/50-question-policy.md) (Question Policy: Auto).

### ⚠️ Main Orchestrator File Writing (CRITICAL)

**메인 오케스트레이터에서 Bash로 파일 쓰기 절대 금지:**
- ❌ `cat > file <<` (heredoc)
- ❌ `echo ... > file`
- ❌ 모든 Bash 리다이렉션

**대신 사용:**
- ✅ 상태 파일 → status-update.sh 스크립트
- ✅ 일반 파일 → Write 도구
- ✅ 대용량 파일 → Task(서브에이전트)에 위임

## Workflow

```
[Init] → [Design Style] → [Quick Requirements] → [Wireframes + Design] → [Assembly] → [Auto-Execute]
                                                                                            ↓
                                                                          spec-it-execute (Phase 0-9)
```

---

## Phase 0: Init

### Step 0.0: Setup Intake (Design + Dashboard)

```
# If already provided in args/user request, do NOT ask again.

DESIGN_TRENDS_PATH = $HOME/.claude/plugins/marketplaces/claude-frontend-skills/skills/design-trends-2026
designStyle = args.designStyle or userRequest
designTrends = args.designTrends or userRequest
dashboard = args.dashboard or userRequest

questions = []

IF designStyle missing:
  questions += {
    question: "어떤 디자인 스타일을 적용하시겠습니까?",
    header: "Design Style",
    options: [
      {label: "Minimal (Recommended)", description: "깔끔한 SaaS: 밝은 테마, 미니멀 카드"},
      {label: "Immersive", description: "다크 테마: 그라데이션 카드, 네온 포인트"},
      {label: "Organic", description: "유기적: Glassmorphism, 부드러운 곡선"},
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
        {label: "Dark Mode+", description: "어두운 테마"},
        {label: "Light Skeuomorphism", description: "부드러운 그림자"},
        {label: "Glassmorphism", description: "반투명 blur"},
        {label: "Micro-Animations", description: "의미있는 모션"}
      ]
    }]
  )

IF designStyle == "Custom File":
  customPath = userInput
  IF NOT exists(customPath + "/references/trends-summary.md"):
    Output: "경고: trends-summary.md를 찾을 수 없습니다. 기본 스타일을 사용합니다."
    DESIGN_TRENDS_PATH = default
  ELSE:
    DESIGN_TRENDS_PATH = customPath
    _meta.customDesignPath = customPath

_meta.designStyle = selectedStyle
_meta.designTrends = selectedTrends or designTrends
_meta.designTrendsPath = DESIGN_TRENDS_PATH
_meta.dashboardEnabled = dashboard
```

### Step 0.1: Session Init

```
# Generate session and get SESSION_DIR
result = Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/session-init.sh "" yaml "$(pwd)"

# Parse output to get SESSION_DIR (full absolute path)
sessionId = extract SESSION_ID from result
sessionDir = extract SESSION_DIR from result  # CRITICAL: Use this in all script calls

→ Creates folders, _meta.json, _status.json

IF _meta.dashboardEnabled == "Enable":
  Output: "⏺ Dashboard:  file://$HOME/.claude/plugins/marketplaces/claude-frontend-skills/web-dashboard/index.html  을 열어 실시간 진행 상황을 확인할 수 있습니다."
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: .spec-it/{sessionId}/plan/_meta.json
  GOTO: _meta.currentStep
```

### Step 0.2: Design Style Selection (Only if Missing)

```
IF designStyle missing:
  AskUserQuestion(
    questions: [{
      question: "어떤 디자인 스타일을 적용하시겠습니까?",
      header: "Design Style",
      options: [
        {label: "Minimal (Recommended)", description: "깔끔한 SaaS: 밝은 테마, 미니멀 카드"},
        {label: "Immersive", description: "다크 테마: 그라데이션 카드, 네온 포인트"},
        {label: "Organic", description: "유기적: Glassmorphism, 부드러운 곡선"},
        {label: "Custom", description: "직접 트렌드 선택"},
        {label: "Custom File", description: "직접 스타일 파일 경로 지정"}
      ]
    }]
  )

  IF "Custom":
    AskUserQuestion(
      questions: [{
        question: "적용할 디자인 트렌드를 선택하세요",
        header: "Trends",
        multiSelect: true,
        options: [
          {label: "Dark Mode+", description: "어두운 테마"},
          {label: "Light Skeuomorphism", description: "부드러운 그림자"},
          {label: "Glassmorphism", description: "반투명 blur"},
          {label: "Micro-Animations", description: "의미있는 모션"}
        ]
      }]
    )

  IF "Custom File":
    customPath = userInput
    IF NOT exists(customPath + "/references/trends-summary.md"):
      Output: "경고: trends-summary.md를 찾을 수 없습니다. 기본 스타일을 사용합니다."
      DESIGN_TRENDS_PATH = default
    ELSE:
      DESIGN_TRENDS_PATH = customPath
      _meta.customDesignPath = customPath

  _meta.designStyle = selectedStyle
  _meta.designTrends = selectedTrends
  _meta.designTrendsPath = DESIGN_TRENDS_PATH

  Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/meta-checkpoint.sh {sessionId} 0.2
```

---

## Phase 1: Quick Requirements

### Step 1.1: Minimal Q&A

```
AskUserQuestion(
  questions: [
    {
      question: "프로젝트의 핵심 목적은 무엇인가요?",
      header: "Purpose",
      options: [
        {label: "Dashboard", description: "데이터 시각화, 모니터링"},
        {label: "Admin Panel", description: "관리자 도구, CRUD"},
        {label: "E-commerce", description: "상품, 결제, 주문"},
        {label: "Social/Community", description: "피드, 프로필, 메시지"}
      ]
    },
    {
      question: "주요 화면은 몇 개 정도인가요?",
      header: "Screens",
      options: [
        {label: "1-3개 (Small)", description: "핵심 기능만"},
        {label: "4-7개 (Medium)", description: "주요 플로우"},
        {label: "8개+ (Large)", description: "전체 앱"}
      ]
    }
  ]
)

Write: 00-requirements/quick-brief.md
  - Project type
  - Estimated screens
  - User's original request (PRD/description)

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/meta-checkpoint.sh {sessionId} 1.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 1 2 "2.1"
```

---

## Phase 2: UI Architecture (with Design Trends)

### Step 2.1: Screen List + Layout

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start ui-architect

Task(ui-architect, sonnet):
  prompt: "
    Role: ui-architect (Fast Mode)

    === DESIGN REFERENCE (MUST READ) ===
    1. Read: {_meta.designTrendsPath}/references/trends-summary.md
    2. Read: {_meta.designTrendsPath}/references/component-patterns.md
    3. Read: {_meta.designTrendsPath}/templates/navigation-templates.md

    Design Style: {_meta.designStyle}
    Applied Trends: {_meta.designTrends}

    === INPUT ===
    Read: 00-requirements/quick-brief.md

    === OUTPUT ===
    1. 02-wireframes/layouts/layout-system.yaml
       - Layout structure based on design style

    2. 02-wireframes/layouts/components.yaml
       - Shared layout components

    3. 02-wireframes/domain-map.md (domains + user types)
  "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete ui-architect "" 2.1
```

### Step 2.1b: Shared + Screen Lists (Parallel)

```
FOR each domain in domain-map (parallel, max 4):
  Task(ui-architect, sonnet, parallel):
    prompt: "
      Role: ui-architect
      Domain: {domain}

      Output: 02-wireframes/<domain>/shared.md
      Include design direction + shared UI components
    "

FOR each domain/user-type in domain-map (parallel, max 4):
  Task(ui-architect, sonnet, parallel):
    prompt: "
      Role: ui-architect
      Domain: {domain}
      User type: {userType}

      Output: 02-wireframes/<domain>/<user-type>/screen-list.md
      Screen list rules:
        - user_type: buyer | seller | admin | operator
        - id format: <domain>-<user>-<flow>-<seq>
        - fields: id, title, flow, priority, notes, depends_on(optional)
    "
```

### Step 2.2: Wireframes (Parallel)

```
# Get screen groups from screen-list.md files
Glob: 02-wireframes/*/*/screen-list.md
Extract: domain, user_type, screen IDs

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start ui-architect-wireframes

FOR each screen-list group (parallel, max 4):
  Task(ui-architect, sonnet):
    prompt: "
      Role: ui-architect (Fast Mode)

      Screen list: {screenListPath}
      Read: {screenListPath}
      Read: 02-wireframes/<domain>/shared.md (same domain as screen list)
      Render all screens in this list (respect depends_on order)

      === DESIGN REFERENCE (MUST READ) ===
      Read: {_meta.designTrendsPath}/references/trends-summary.md
      Read: {_meta.designTrendsPath}/references/component-patterns.md
      Read: {_meta.designTrendsPath}/references/motion-presets.md

      Design Style: {_meta.designStyle}

      === WIREFRAME REQUIREMENTS ===

      Each wireframe MUST include '## Design Direction' section:

      ### Applied Trends
      - Primary: {trend} - {application}
      - Secondary: {trend} - {application}

      ### Component Patterns
      | Component | Pattern | Template Reference |
      |-----------|---------|-------------------|
      | Sidebar | {name} | navigation-templates.md#{section} |
      | Card | {name} | card-templates.md#{section} |

      ### Color Tokens
      | Token | Value | Usage |

      ### Motion Guidelines
      | Interaction | Animation | Duration |

      === YAML WIREFRAME ===
      Generate structured YAML wireframe.
      Reference: skills/shared/references/yaml-ui-frame/03-components.md

      === CRITICAL RULES ===
      - NEVER use ASCII box characters
      - Use grid.areas for layout (CSS Grid syntax)
      - Include testId for all interactive elements

      Output: 02-wireframes/<domain>/<user-type>/wireframes/{screenId}.yaml
    "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete ui-architect-wireframes "" 2.2
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 2 3 "3.1"
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/validate-output.sh "$(pwd)/tmp"
```

---

## Phase 3: Quick Assembly

### Step 3.1: Summary

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start spec-assembler

Task(spec-assembler, haiku):
  prompt: "
    Role: spec-assembler (Fast Mode)

    Read all files in:
    - 00-requirements/
    - 02-wireframes/

    Generate:
    1. 06-final/FAST-SPEC-SUMMARY.md
       - Project overview
       - Design style applied
       - Screen list with wireframe links
       - Design Direction highlights (trends, patterns, colors)

    2. 06-final/design-checklist.md
       - List of design trends applied per screen
       - Component patterns used
       - Color token summary
  "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete spec-assembler "" 3.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} complete
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/validate-output.sh "$(pwd)/tmp"
```

### Step 3.2: Minimal QA Gate (Default)

```
# Run minimal QA before execute
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/qa/run-qa.sh "$(pwd)" --skip-test --skip-build

IF failed:
  Output: "QA failed. Fix lint/type errors, then re-run /spec-it-execute."
  STOP
```

### Step 3.3: Auto-Execute

```
Read: 06-final/FAST-SPEC-SUMMARY.md
Output to user: "Spec generation complete. Proceeding to implementation..."

# Auto-proceed to spec-it-execute
# No user approval needed - this is the Fast mode promise
Skill(spec-it-execute, "tmp --design-style {_meta.designStyle} --design-trends {_meta.designTrends} --dashboard {_meta.dashboardEnabled}")
```

---

## Phase 4: Execute (Auto-invoked)

spec-it-execute handles:
- Phase 0: Initialize
- Phase 1: Load specs
- Phase 2: Plan execution
- Phase 3: Implement code (batched parallel)
- Phase 4: QA loop
- Phase 5: Spec-mirror verification
- Phase 6: Unit tests (if time permits)
- Phase 7: E2E tests (if time permits)
- Phase 8: Code review
- Phase 9: Complete

See `spec-it-execute/SKILL.md` for full details.

---

## Output Structure

```
.spec-it/{sessionId}/plan/
├── _meta.json, _status.json

tmp/
├── 00-requirements/
│   └── quick-brief.md
├── 02-wireframes/
│   ├── layouts/layout-system.yaml
│   ├── layouts/components.yaml
│   ├── domain-map.md
│   ├── <domain>/shared.md
│   ├── <domain>/<user-type>/screen-list.md
│   └── <domain>/<user-type>/wireframes/{screen-id}.yaml
└── 06-final/
    ├── FAST-SPEC-SUMMARY.md
    └── design-checklist.md
```

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| ui-architect | sonnet | Screen list, layouts, wireframes |
| spec-assembler | haiku | Final summary |

---

## Resume

```
/frontend-skills:spec-it-fast-launch --resume {sessionId}
```

State saved in `_meta.json` after each step.
