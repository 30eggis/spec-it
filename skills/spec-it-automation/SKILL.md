---
name: spec-it-automation
description: "Frontend spec generator (Full Auto mode). Maximum automation with minimal approval. Best for large projects."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-automation: Full Auto Mode

Transform PRD/vibe-coding into frontend specifications with **maximum automation** and **minimal user intervention**.

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).

## Workflow

```
[Auto: Requirements → Divergent → Multi-Critic → Chapter Plan]
      ↓
[Auto: UI Architecture + Component Discovery]
      ↓
[Auto: Critical Review]
      ↓
[IF ambiguity: User Question]
      ↓
[Auto: Test Spec → Assembly]
      ↓
★ Final Approval (only user interaction)
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
      Output: "Claude Code 재시작 필요. 재시작 후 /spec-it-automation --resume {sessionId}"
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
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/session-init.sh {sessionId} {uiMode}
→ Auto-launches dashboard
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: tmp/{sessionId}/_meta.json
  GOTO: _meta.currentStep
```

---

## Phase 1: Design Brainstorming (Auto)

### Step 1.1: Requirements

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionId} agent-start design-interviewer

Task(design-interviewer, opus):
  Output: 00-requirements/requirements.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionId} agent-complete design-interviewer
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/meta-checkpoint.sh {sessionId} 1.1
```

### Step 1.2: Divergent Thinking

```
Task(divergent-thinker, sonnet):
  Output: 01-chapters/alternatives/*.md, _index.md
```

### Step 1.3: Multi-Critic Debate (Parallel)

```
Task(critic-logic, sonnet, parallel):
  Output: 01-chapters/critique-logic.md

Task(critic-feasibility, sonnet, parallel):
  Output: 01-chapters/critique-feasibility.md

Task(critic-frontend, sonnet, parallel):
  Output: 01-chapters/critique-frontend.md

WAIT for all 3

Task(critic-moderator, opus):
  - Synthesize 3 critiques
  - Resolve conflicts
  - Output: 01-chapters/critique-final.md
```

### Step 1.4: Chapter Plan

```
Task(chapter-planner, opus):
  Output: 01-chapters/chapter-plan-final.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionId} progress 16 1.4 1
```

---

## Phase 2: UI + Components (Auto)

### Step 2.1: UI Architecture

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/phase-dispatcher.sh {sessionId} ui
→ Returns: DISPATCH:stitch-convert OR DISPATCH:ascii-wireframe
```

### IF STITCH Mode

```
# Step 1: Verify Stitch MCP setup
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/verify-stitch-mcp.sh

IF exit code != 0:
  Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/setup-stitch-mcp.sh
  IF exit code == 2:
    # MCP added, restart required
    Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/restart-with-resume.sh {sessionId} spec-it-automation {workingDir}
    STOP (user will resume after restart)

# Step 2: Generate ASCII wireframes first (with Design Trends)
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

# Step 3: Convert to HTML via Stitch MCP
/stitch-convert {sessionId}

Output: 02-screens/wireframes/, html/, assets/
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

    Output: screen-list.md, layouts/layout-system.md
  "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/screen-planner.sh {sessionId}

FOR each batch (4 screens):
  Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/executors/batch-runner.sh {sessionId} wireframe {i}

  Task(ui-architect, sonnet, parallel x4):
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

      Output: wireframes/wireframe-{screen}.md
    "
```

### Step 2.2: Component Discovery + Build

```
Task(component-auditor, haiku, parallel):
  Output: 03-components/inventory.md, gap-analysis.md

WAIT

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/component-planner.sh {sessionId}

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/spec-{component}.md

Task(component-migrator, sonnet, parallel):
  Output: 03-components/migrations/migration-plan.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionId} progress 33 2.2 2
```

---

## Phase 3: Critical Review (Auto)

### Step 3.1: Parallel Review

```
Task(critical-reviewer, opus, parallel):
  Output: 04-review/scenarios/, ia-review.md, exceptions/

Task(ambiguity-detector, opus, parallel):
  Output: 04-review/ambiguities.md

WAIT for both
```

### Step 3.2: Ambiguity Resolution

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/phase-dispatcher.sh {sessionId} ambiguity

IF DISPATCH:user-question:
  Read: 04-review/ambiguities.md
  Extract "Must Resolve" items

  AskUserQuestion: "Resolve these ambiguities"
  (dynamic options based on ambiguities)

  Write: 04-review/ambiguities-resolved.md

ELSE:
  Auto-proceed

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionId} progress 50 3.2 3
```

---

## Phase 4: Test Specification (Auto)

```
Task(persona-architect, sonnet, parallel):
  Output: 05-tests/personas/

Task(test-spec-writer, sonnet, parallel):
  Output: 05-tests/scenarios/, components/, coverage-map.md

WAIT for both

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionId} progress 66 4.1 4
```

---

## Phase 5: Final Assembly (Auto)

```
Task(spec-assembler, haiku):
  Output:
  - 06-final/final-spec.md
  - 06-final/dev-tasks.md
  - 06-final/SPEC-SUMMARY.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionId} progress 83 5.1 5
```

---

## Phase 6: Final Approval

```
Read: 06-final/SPEC-SUMMARY.md

AskUserQuestion: "Spec complete. Handle tmp folder?"
Options: [Archive, Keep, Delete]

IF Archive: mv tmp/{sessionId} archive/
IF Delete: rm -rf tmp/{sessionId}

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionId} complete
```

---

## Output Structure

```
tmp/{sessionId}/
├── _meta.json, _status.json
├── 00-requirements/
├── 01-chapters/
│   ├── alternatives/
│   ├── critique-logic.md, critique-feasibility.md, critique-frontend.md
│   ├── critique-final.md
│   └── chapter-plan-final.md
├── 02-screens/
│   ├── screen-list.md, layouts/
│   ├── wireframes/ (ASCII)
│   └── html/, assets/ (Stitch)
├── 03-components/inventory.md, gap-analysis.md, new/, migrations/
├── 04-review/scenarios/, exceptions/, ambiguities.md
├── 05-tests/personas/, scenarios/, coverage-map.md
└── 06-final/final-spec.md, dev-tasks.md, SPEC-SUMMARY.md
```

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| design-interviewer | opus | Requirements |
| divergent-thinker | sonnet | Alternatives |
| critic-logic | sonnet | Logic validation |
| critic-feasibility | sonnet | Feasibility check |
| critic-frontend | sonnet | Frontend review |
| critic-moderator | opus | Synthesize critiques |
| chapter-planner | opus | Plan chapters |
| ui-architect | sonnet | Wireframes |
| component-auditor | haiku | Scan components |
| component-builder | sonnet | Build specs |
| component-migrator | sonnet | Migration plan |
| critical-reviewer | opus | Scenario review |
| ambiguity-detector | opus | Find ambiguities |
| persona-architect | sonnet | Personas |
| test-spec-writer | sonnet | Test specs |
| spec-assembler | haiku | Final assembly |

| Skill | Purpose |
|-------|---------|
| stitch-convert | ASCII → Stitch MCP → HTML export |

---

## Progress Tracking

| Phase | Steps | Progress |
|-------|-------|----------|
| 1 | 1.1-1.4 | 0-16% |
| 2 | 2.1-2.2 | 17-33% |
| 3 | 3.1-3.2 | 34-50% |
| 4 | 4.1 | 51-66% |
| 5 | 5.1 | 67-83% |
| 6 | 6.1 | 84-100% |

---

## Resume

```
/frontend-skills:spec-it-automation --resume {sessionId}
```
