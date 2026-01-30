---
name: spec-it-fast-launch
description: "Frontend spec generator (Fast Launch mode). Skip brainstorming, component design, and test spec. Quick wireframes with design trends. Best for rapid prototyping and design testing."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
---

# spec-it-fast-launch: Fast Launch Mode

Transform PRD/vibe-coding into frontend wireframes with **minimal process** and **design trends applied**.

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

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).

## Workflow

```
[Init] → [Design Style] → [Quick Requirements] → [Wireframes + Design] → [Done]
```

---

## Phase 0: Init

### Step 0.1: Session Init

```
# Generate session and get SESSION_DIR
result = Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/session-init.sh "" ascii "$(pwd)"

# Parse output to get SESSION_DIR (full absolute path)
sessionId = extract SESSION_ID from result
sessionDir = extract SESSION_DIR from result  # CRITICAL: Use this in all script calls

→ Creates folders, _meta.json, _status.json
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: tmp/{sessionId}/_meta.json
  GOTO: _meta.currentStep
```

### Step 0.2: Design Style Selection

```
DESIGN_TRENDS_PATH = $HOME/.claude/plugins/marketplaces/claude-frontend-skills/skills/design-trends-2026

AskUserQuestion(
  questions: [{
    question: "어떤 디자인 스타일을 적용하시겠습니까?",
    header: "Design Style",
    options: [
      {label: "Minimal (Recommended)", description: "깔끔한 SaaS: 밝은 테마, 미니멀 카드"},
      {label: "Immersive", description: "다크 테마: 그라데이션 카드, 네온 포인트"},
      {label: "Organic", description: "유기적: Glassmorphism, 부드러운 곡선"},
      {label: "Custom", description: "직접 트렌드 선택"}
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
```

---

## Phase 2: UI Architecture (with Design Trends)

### Step 2.1: Screen List + Layout

```
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
    1. 02-screens/screen-list.md
       - List all screens with IDs (SCR-001, SCR-002, ...)
       - Brief description per screen

    2. 02-screens/layouts/layout-system.md
       - Layout structure based on design style
       - Include Design Direction section
  "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/meta-checkpoint.sh {sessionId} 2.1
```

### Step 2.2: Wireframes (Parallel)

```
# Get screen count from screen-list.md
Read: 02-screens/screen-list.md
Extract: screen IDs

FOR each screen (parallel, max 4):
  Task(ui-architect, sonnet):
    prompt: "
      Role: ui-architect (Fast Mode)

      === DESIGN REFERENCE (MUST READ) ===
      Read: {_meta.designTrendsPath}/references/trends-summary.md
      Read: {_meta.designTrendsPath}/references/component-patterns.md
      Read: {_meta.designTrendsPath}/references/motion-presets.md

      Design Style: {_meta.designStyle}

      === WIREFRAME REQUIREMENTS ===
      Screen: {screenId} - {screenName}

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

      === ASCII WIREFRAME ===
      Draw detailed ASCII wireframe using box-drawing characters.
      Reference: ../references/ascii-wireframe-guide.md

      Output: 02-screens/wireframes/wireframe-{screenId}.md
    "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/meta-checkpoint.sh {sessionId} 2.2
```

---

## Phase 3: Quick Assembly

### Step 3.1: Summary

```
Task(spec-assembler, haiku):
  prompt: "
    Role: spec-assembler (Fast Mode)

    Read all files in:
    - 00-requirements/
    - 02-screens/

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

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} complete
```

### Step 3.2: Done

```
Read: 06-final/FAST-SPEC-SUMMARY.md
Output to user

AskUserQuestion: "Fast spec 완료. 폴더 처리?"
Options: [Keep, Delete]

IF Delete: rm -rf tmp/{sessionId}
```

---

## Output Structure

```
tmp/{sessionId}/
├── _meta.json, _status.json
├── 00-requirements/
│   └── quick-brief.md
├── 02-screens/
│   ├── screen-list.md
│   ├── layouts/layout-system.md
│   └── wireframes/wireframe-*.md (with Design Direction)
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
