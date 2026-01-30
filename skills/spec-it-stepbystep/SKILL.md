---
name: spec-it-stepbystep
description: "Frontend spec generator (Step-by-Step mode). Chapter-by-chapter user approval. Best for small projects or learning."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-stepbystep: Step-by-Step Mode

Transform PRD/vibe-coding into frontend specifications with **chapter-by-chapter approval**.

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).

## Workflow

```
[CH-00] → Approval → [CH-01] → Approval → ... → [CH-07] → Final
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
      Output: "Claude Code 재시작 필요. 재시작 후 /spec-it-stepbystep --resume {sessionId}"
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
# Reference: design-trends-2026/integration/spec-it-integration.md

DESIGN_TRENDS_PATH = $HOME/.claude/plugins/marketplaces/claude-frontend-skills/skills/design-trends-2026

AskUserQuestion(
  questions: [{
    question: "어떤 디자인 스타일을 적용하시겠습니까? (2026 Design Trends 기반)",
    header: "Design Style",
    options: [
      {label: "Minimal (Recommended)", description: "깔끔한 SaaS: 밝은 테마, 미니멀 카드, 깔끔한 테이블"},
      {label: "Immersive", description: "다크 테마: 그라데이션 카드, 네온 포인트, 풍부한 시각 효과"},
      {label: "Organic", description: "유기적: Glassmorphism, 부드러운 곡선, 3D 요소"},
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
        {label: "Dark Mode+", description: "어두운 테마 + 적응형 색상"},
        {label: "Light Skeuomorphism", description: "부드러운 그림자, Neumorphic"},
        {label: "Glassmorphism", description: "반투명 배경 + blur"},
        {label: "Micro-Animations", description: "의미있는 모션"},
        {label: "3D Visuals", description: "3D 아이콘, WebGL"},
        {label: "Gamification", description: "Progress rings, 배지"}
      ]
    }]
  )

# Save to session state
_meta.designStyle = selectedStyle
_meta.designTrends = selectedTrends (if Custom)
_meta.designTrendsPath = DESIGN_TRENDS_PATH
```

### Step 0.1: Session Init

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/session-init.sh {sessionId} {uiMode}
→ Creates folders, _meta.json, _status.json
→ Auto-launches dashboard in separate terminal
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: tmp/{sessionId}/_meta.json
  GOTO: _meta.currentStep
```

---

## Phase 1: Design Brainstorming

### Chapters (CH-00 to CH-07)

```
CH-00: Project Scope & Constraints
CH-01: User & Persona Definition
CH-02: Information Architecture
CH-03: Screen Inventory
CH-04: Feature Definition
CH-05: Component Requirements
CH-06: State & Data Flow
CH-07: Non-Functional Requirements
```

### For Each Chapter

```
1. Task(design-interviewer, opus):
   - Conduct Q&A for chapter
   - Output: 01-chapters/decisions/decision-{chapter}.md

2. Show chapter summary to user

3. AskUserQuestion: "Is this correct?"
   Options: [Yes, No, Questions]

4. Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/meta-checkpoint.sh {sessionId} {chapter}

5. IF No/Questions: Revise and re-ask
```

---

## Phase 2: UI Architecture

### Step 2.1: Dispatch

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/phase-dispatcher.sh {sessionId} ui
→ Returns: DISPATCH:stitch-convert OR DISPATCH:ascii-wireframe
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
    - Applied Trends (Primary/Secondary)
    - Component Patterns table (with Template Reference column)
    - Color Tokens table
    - Motion Guidelines table

    See: design-trends-2026/integration/agent-prompts.md for full template

    Output: screen-list.md, layouts/, wireframes/
  "

# Step 2: Convert to HTML via Stitch MCP (runs in main session)
/stitch-convert {sessionId}
Output: 02-screens/html/, assets/
```

### IF ASCII Mode

```
1. Task(ui-architect, sonnet):
   prompt: "
     Role: ui-architect

     === DESIGN REFERENCE (MUST READ FIRST) ===
     1. Read: {_meta.designTrendsPath}/references/trends-summary.md
     2. Read: {_meta.designTrendsPath}/references/component-patterns.md
     3. Read: {_meta.designTrendsPath}/templates/navigation-templates.md

     Design Style: {_meta.designStyle}
     Applied Trends: {_meta.designTrends}

     Generate layout-system.md and screen-list.md
     Include design direction based on selected style
   "

2. Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/screen-planner.sh {sessionId}
   → Creates screens.json

3. FOR each batch (4 screens):
   Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/executors/batch-runner.sh {sessionId} wireframe {batchIndex}

   Task(ui-architect, sonnet, parallel):
     prompt: "
       Role: ui-architect

       === DESIGN REFERENCE (MUST READ) ===
       Read: {_meta.designTrendsPath}/references/trends-summary.md
       Read: {_meta.designTrendsPath}/references/component-patterns.md

       Design Style: {_meta.designStyle}

       === OUTPUT REQUIREMENTS ===
       Each wireframe MUST include '## Design Direction' section:

       ### Applied Trends
       - Primary: {trend} - {application}
       - Secondary: {trend} - {application}

       ### Component Patterns
       | Component | Pattern | Template Reference |
       |-----------|---------|-------------------|
       | Sidebar | {name} | navigation-templates.md#{section} |

       ### Color Tokens
       | Token | Value | Usage |

       ### Motion Guidelines
       | Interaction | Animation | Duration |

       Generate wireframe-{screen}.md with full layout
     "
```

### Step 2.2: Component Discovery

```
Task(component-auditor, haiku):
  Output: 03-components/inventory.md, gap-analysis.md

AskUserQuestion: "UI Architecture complete. Continue?"
```

---

## Phase 3: Component Specification

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/component-planner.sh {sessionId}

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/spec-{component}.md

Task(component-migrator, sonnet):
  Output: 03-components/migrations/migration-plan.md

AskUserQuestion: "Components complete. Continue?"
```

---

## Phase 4: Critical Review

```
Task(critical-reviewer, opus):
  Output: 04-review/scenarios/, ia-review.md, exceptions/

Task(ambiguity-detector, opus):
  Output: 04-review/ambiguities.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/phase-dispatcher.sh {sessionId} ambiguity
→ IF must-resolve: AskUserQuestion for resolution
```

---

## Phase 5: Test Specification

```
Task(persona-architect, sonnet):
  Output: 05-tests/personas/

Task(test-spec-writer, sonnet):
  Output: 05-tests/scenarios/, components/, coverage-map.md

AskUserQuestion: "Tests complete. Continue?"
```

---

## Phase 6: Final Assembly

```
Task(spec-assembler, haiku):
  Output: 06-final/final-spec.md, dev-tasks.md, SPEC-SUMMARY.md

AskUserQuestion: "Spec complete. Handle tmp folder?"
Options: [Archive, Keep, Delete]

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionId} complete
```

---

## Output Structure

```
tmp/{sessionId}/
├── _meta.json, _status.json
├── 00-requirements/
├── 01-chapters/decisions/, alternatives/
├── 02-screens/wireframes/, layouts/, [html/, assets/]
├── 03-components/new/, migrations/
├── 04-review/scenarios/, exceptions/
├── 05-tests/personas/, scenarios/
└── 06-final/
```

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| design-interviewer | opus | Chapter Q&A |
| ui-architect | sonnet | Wireframes |
| component-auditor | haiku | Component scan |
| component-builder | sonnet | Component spec |
| component-migrator | sonnet | Migration plan |
| critical-reviewer | opus | Scenario/IA review |
| ambiguity-detector | opus | Find ambiguities |
| persona-architect | sonnet | Persona definition |
| test-spec-writer | sonnet | Test specs |
| spec-assembler | haiku | Final assembly |

| Skill | Purpose |
|-------|---------|
| stitch-convert | ASCII → Stitch MCP → HTML export |

---

## Resume

```
/frontend-skills:spec-it-stepbystep --resume {sessionId}
```

State saved in `_meta.json` after each step.
