---
name: spec-it-complex
description: "Frontend spec generator (Hybrid mode). Auto-validation with 4 milestone approvals. Best for medium projects."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-complex: Hybrid Mode

Transform PRD/vibe-coding into frontend specifications with **auto-validation** and **4 milestone approvals**.

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).

## Workflow

```
[Requirements] → [Divergent] → [3-Round Critique] → [Chapter Plan]
      ↓
★ MILESTONE 1: "Proceed with N chapters?"
      ↓
[CH-00~02: Auto] → ★ MILESTONE 2: "Basic structure OK?"
      ↓
[CH-03~04: Auto] → ★ MILESTONE 3: "Features OK?"
      ↓
[CH-05~07: Auto] → [Review] → [Tests] → [Assembly]
      ↓
★ MILESTONE 4: Final approval
```

---

## Phase 0: Init

### Step 0.0: UI Mode Selection

```
AskUserQuestion: "Select UI design mode"
Options: ["ASCII Wireframe (Recommended)", "Google Stitch"]

IF Stitch:
  # Step 1: Verify MCP configuration
  Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/verify-stitch-mcp.sh

  IF exit != 0:
    # Step 2: Fix MCP configuration if needed
    Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/setup-stitch-mcp.sh
    IF exit == 2:
      Output: "Claude Code 재시작 필요. 재시작 후 /spec-it-complex --resume {sessionId}"
      STOP

    # Step 3: Setup OAuth (interactive - opens browser)
    Output: "OAuth 설정을 진행합니다. 브라우저에서 Google 로그인을 완료해주세요."
    Bash: node $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/setup-stitch-oauth.mjs

    IF exit != 0:
      Output: "OAuth 설정 실패. ASCII 모드로 전환합니다."
      SET uiMode = "ascii"
    ELSE:
      # Re-verify after OAuth setup
      Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/verify-stitch-mcp.sh
      IF exit != 0:
        Output: "Stitch 설정 실패. ASCII 모드로 전환합니다."
        SET uiMode = "ascii"
```

### Step 0.0b: Design Style Selection

```
# Design Trends 2026 Integration
DESIGN_TRENDS_PATH = $HOME/.claude/plugins/marketplaces/claude-frontend-skills/skills/design-trends-2026

AskUserQuestion(
  questions: [{
    question: "어떤 디자인 스타일을 적용하시겠습니까? (2026 Design Trends 기반)",
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
        {label: "Micro-Animations", description: "의미있는 모션"},
        {label: "3D Visuals", description: "3D 아이콘"},
        {label: "Gamification", description: "Progress, 배지"}
      ]
    }]
  )

_meta.designStyle = selectedStyle
_meta.designTrends = selectedTrends
_meta.designTrendsPath = DESIGN_TRENDS_PATH
```

### Step 0.1: Session Init

```
# Generate session and get SESSION_DIR
result = Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/session-init.sh "" {uiMode} "$(pwd)"

# Parse output to get SESSION_DIR (full absolute path)
sessionId = extract SESSION_ID from result
sessionDir = extract SESSION_DIR from result  # CRITICAL: Use this in all script calls

→ Auto-launches dashboard
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: tmp/{sessionId}/_meta.json
  GOTO: _meta.currentStep
```

---

## Phase 1: Design Brainstorming

### Step 1.1: Requirements Analysis

```
Task(design-interviewer, opus):
  Output: 00-requirements/requirements.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/meta-checkpoint.sh {sessionId} 1.1
```

### Step 1.2: Divergent Thinking + Critique

```
Task(divergent-thinker, sonnet):
  Output: 01-chapters/alternatives/*.md

FOR round in [1, 2, 3]:
  Task(chapter-critic, opus):
    Output: 01-chapters/critique-round{round}.md

Task(chapter-planner, opus):
  Output: 01-chapters/chapter-plan-final.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/meta-checkpoint.sh {sessionId} 1.2
```

---

## ★ MILESTONE 1: Chapter Plan Approval

```
Read: 01-chapters/chapter-plan-final.md

AskUserQuestion: "{N} chapters planned. Proceed?"
Options: [Yes, Modify]

IF Modify: Revise plan
```

---

## Phase 2: Chapters + UI Architecture

### Step 2.1: Batch 1 (CH-00~02)

```
Task(chapter-writer, sonnet, parallel):
  Output: 01-chapters/decisions/CH-00.md, CH-01.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/phase-dispatcher.sh {sessionId} ui
→ DISPATCH:stitch-convert OR DISPATCH:ascii-wireframe
```

### IF STITCH Mode

```
# Step 1: Generate ASCII wireframes first (with Design Trends)
Task(ui-architect, sonnet):
  prompt: "
    Role: ui-architect

    === DESIGN REFERENCE (MUST READ FIRST) ===
    1. Read: {_meta.designTrendsPath}/references/trends-summary.md
    2. Read: {_meta.designTrendsPath}/references/component-patterns.md
    3. Read: {_meta.designTrendsPath}/templates/navigation-templates.md

    Design Style: {_meta.designStyle}
    Applied Trends: {_meta.designTrends}

    === WIREFRAME REQUIREMENTS ===
    Each wireframe MUST include '## Design Direction' section with:
    - Applied Trends, Component Patterns (with Template Reference), Color Tokens, Motion Guidelines

    Output: screen-list.md, layouts/, wireframes/
  "

# Step 2: Convert to HTML via Stitch MCP (runs in main session)
/stitch-convert {sessionId}
Output: 02-screens/html/, assets/
```

### IF ASCII Mode

```
Task(ui-architect, sonnet):
  prompt: "
    Role: ui-architect

    === DESIGN REFERENCE (MUST READ FIRST) ===
    1. Read: {_meta.designTrendsPath}/references/trends-summary.md
    2. Read: {_meta.designTrendsPath}/references/component-patterns.md

    Design Style: {_meta.designStyle}

    Output: 02-screens/screen-list.md, layouts/layout-system.md
  "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/screen-planner.sh {sessionId}

FOR each batch:
  Task(ui-architect, sonnet, parallel):
    prompt: "
      Role: ui-architect

      === DESIGN REFERENCE ===
      Read: {_meta.designTrendsPath}/references/trends-summary.md
      Read: {_meta.designTrendsPath}/references/component-patterns.md

      Design Style: {_meta.designStyle}

      === OUTPUT: Each wireframe MUST include ===
      ## Design Direction
      ### Applied Trends
      ### Component Patterns (with Template Reference column)
      ### Color Tokens
      ### Motion Guidelines

      Output: 02-screens/wireframes/wireframe-{screen}.md
    "
```

---

## ★ MILESTONE 2: Basic Structure Approval

```
AskUserQuestion: "Basic structure (CH-00~02) complete. Continue?"
Options: [Yes, Review]
```

---

## Phase 3: Features + Components

### Step 3.1: Batch 2 (CH-03~04)

```
Task(chapter-writer, sonnet, parallel):
  Output: 01-chapters/decisions/CH-03.md, CH-04.md

Task(component-auditor, haiku):
  Output: 03-components/inventory.md, gap-analysis.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/component-planner.sh {sessionId}

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/spec-{component}.md

Task(component-migrator, sonnet):
  Output: 03-components/migrations/migration-plan.md
```

---

## ★ MILESTONE 3: Feature Approval

```
AskUserQuestion: "Features (CH-03~04) complete. Continue?"
Options: [Yes, Review]
```

---

## Phase 4: Remaining + Review

### Step 4.1: Batch 3 (CH-05~07) + Review

```
Task(chapter-writer, sonnet, parallel):
  Output: CH-05.md, CH-06.md, CH-07.md

Task(critical-reviewer, opus, parallel):
  Output: 04-review/scenarios/, ia-review.md, exceptions/

Task(ambiguity-detector, opus, parallel):
  Output: 04-review/ambiguities.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/phase-dispatcher.sh {sessionId} ambiguity
→ IF must-resolve: AskUserQuestion
```

---

## Phase 5: Test Specification

```
Task(persona-architect, sonnet, parallel):
  Output: 05-tests/personas/

Task(test-spec-writer, sonnet, parallel):
  Output: 05-tests/scenarios/, components/, coverage-map.md
```

---

## Phase 6: Final Assembly

```
Task(spec-assembler, haiku):
  Output: 06-final/final-spec.md, dev-tasks.md, SPEC-SUMMARY.md
```

---

## ★ MILESTONE 4: Final Approval

```
AskUserQuestion: "Spec complete. Handle tmp folder?"
Options: [Archive, Keep, Delete]

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} complete
```

---

## Output Structure

```
tmp/{sessionId}/
├── _meta.json, _status.json
├── 00-requirements/
├── 01-chapters/
│   ├── alternatives/, decisions/
│   ├── critique-round1~3.md
│   └── chapter-plan-final.md
├── 02-screens/wireframes/, layouts/, [html/]
├── 03-components/new/, migrations/
├── 04-review/scenarios/, exceptions/
├── 05-tests/personas/, scenarios/
└── 06-final/
```

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| design-interviewer | opus | Requirements |
| divergent-thinker | sonnet | Alternatives |
| chapter-critic | opus | 3-round critique |
| chapter-planner | opus | Plan chapters |
| chapter-writer | sonnet | Write chapters |
| ui-architect | sonnet | Wireframes |
| component-auditor | haiku | Component scan |
| component-builder | sonnet | Component spec |
| component-migrator | sonnet | Migration |
| critical-reviewer | opus | Review |
| ambiguity-detector | opus | Ambiguities |
| persona-architect | sonnet | Personas |
| test-spec-writer | sonnet | Tests |
| spec-assembler | haiku | Assembly |

| Skill | Purpose |
|-------|---------|
| stitch-convert | ASCII → Stitch MCP → HTML export |

---

## Resume

```
/frontend-skills:spec-it-complex --resume {sessionId}
```
