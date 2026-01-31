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

### Step 0.0: Design Style Selection

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
        {label: "Micro-Animations", description: "의미있는 모션"},
        {label: "3D Visuals", description: "3D 아이콘"},
        {label: "Gamification", description: "Progress, 배지"}
      ]
    }]
  )

IF "Custom File":
  # User provides custom style file path via "Other" option
  # Expected: Path to a directory containing:
  #   - references/trends-summary.md
  #   - references/component-patterns.md
  #   - templates/*.md (navigation, card, form, dashboard templates)
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

### Step 2.1: Batch 1 (CH-00~02) + UI Architecture

```
Task(chapter-writer, sonnet, parallel):
  Output: 01-chapters/decisions/CH-00.md, CH-01.md

Task(ui-architect, sonnet):
  prompt: "
    Role: ui-architect

    === YAML UI FRAME REFERENCE (MUST READ) ===
    Read: skills/shared/references/yaml-ui-frame/01-basic-structure.md
    Read: skills/shared/references/yaml-ui-frame/02-grid-definition.md

    === DESIGN REFERENCE ===
    Read: {_meta.designTrendsPath}/references/trends-summary.md
    Read: {_meta.designTrendsPath}/references/component-patterns.md

    Design Style: {_meta.designStyle}

    Output: 02-screens/screen-list.md, layouts/layout-system.yaml
  "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/screen-planner.sh {sessionId}

FOR each batch:
  Task(ui-architect, sonnet, parallel):
    prompt: "
      Role: ui-architect

      === YAML UI FRAME REFERENCE (MUST READ) ===
      Read: skills/shared/references/yaml-ui-frame/03-components.md
      Read: skills/shared/references/yaml-ui-frame/07-design-direction.md

      === DESIGN REFERENCE ===
      Read: {_meta.designTrendsPath}/references/trends-summary.md
      Read: {_meta.designTrendsPath}/references/component-patterns.md

      Design Style: {_meta.designStyle}

      === OUTPUT FORMAT (YAML) ===
      Use template: assets/templates/UI_WIREFRAME_TEMPLATE.yaml
      Output: 02-screens/wireframes/{screen}.yaml

      === CRITICAL RULES ===
      - NEVER use ASCII box characters
      - Use grid.areas for layout (CSS Grid syntax)
      - Include testId for all interactive elements
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

---

## Resume

```
/frontend-skills:spec-it-complex --resume {sessionId}
```
