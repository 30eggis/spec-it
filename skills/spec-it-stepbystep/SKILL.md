---
name: spec-it-stepbystep
description: "Step-by-step spec generator with chapter approvals for small projects."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-stepbystep: Step-by-Step Mode

Transform PRD/vibe-coding into frontend specifications with **chapter-by-chapter approval**.

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).
See [shared/rules/50-question-policy.md](../shared/rules/50-question-policy.md) (Question Policy: Confirm).

### ⚠️ Main Orchestrator File Writing (CRITICAL)

**메인 오케스트레이터에서 Bash로 파일 쓰기 절대 금지:**
- ❌ `cat > file <<` (heredoc)
- ❌ `echo ... > file`
- ❌ 모든 Bash 리다이렉션

**대신 사용:**
- ✅ 상태 파일 → status-update.sh 스크립트
- ✅ 일반 파일 → Write 도구
- ✅ 대용량 파일 → Task(서브에이전트)에 위임

## Output Format

Default output format is **YAML** (structured) for improved parsing and reduced tokens:

| Spec Type | Template | Format |
|-----------|----------|--------|
| UI Wireframe | `UI_WIREFRAME_TEMPLATE.yaml` | YAML |
| Component Spec | `COMPONENT_SPEC_TEMPLATE.yaml` | YAML |
| Screen Spec | `SCREEN_SPEC_TEMPLATE.yaml` | YAML |
| Layout System | `LAYOUT_TEMPLATE.yaml` | YAML |
| Scenarios | Markdown | MD |
| Dev Tasks | Markdown | MD |

### YAML Benefits
- **-64%** file size
- **10x** faster parsing
- **-80%** token duplication
- Shared design tokens via `_ref`

## Workflow

```
[CH-00] → Approval → [CH-01] → Approval → ... → [CH-07] → Final
```

---

## Phase 0: Init

### Step 0.0: Design Style Selection

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
        {label: "Dark Mode+", description: "어두운 테마 + 적응형 색상"},
        {label: "Light Skeuomorphism", description: "부드러운 그림자, Neumorphic"},
        {label: "Glassmorphism", description: "반투명 배경 + blur"},
        {label: "Micro-Animations", description: "의미있는 모션"},
        {label: "3D Visuals", description: "3D 아이콘, WebGL"},
        {label: "Gamification", description: "Progress rings, 배지"}
      ]
    }]
  )

IF "Custom File":
  # User provides custom style file path via "Other" option
  # Expected: Path to a directory containing:
  #   - references/trends-summary.md
  #   - references/component-patterns.md
  #   - templates/*.md (navigation, card, form, dashboard templates)
  #   - references/motion-presets.md (optional)
  #
  # Example: /path/to/my-design-system

  customPath = userInput  # User enters path via "Other" option

  # Validate custom path
  IF NOT exists(customPath + "/references/trends-summary.md"):
    Output: "경고: trends-summary.md를 찾을 수 없습니다. 기본 스타일을 사용합니다."
    DESIGN_TRENDS_PATH = default
  ELSE:
    DESIGN_TRENDS_PATH = customPath
    _meta.customDesignPath = customPath

# Save to session state
_meta.designStyle = selectedStyle
_meta.designTrends = selectedTrends (if Custom)
_meta.designTrendsPath = DESIGN_TRENDS_PATH
```

### Step 0.1: Session Init

```
# Generate session and get SESSION_DIR
result = Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/session-init.sh "" {uiMode} "$(pwd)"

# Parse output to get SESSION_DIR (full absolute path)
sessionId = extract SESSION_ID from result
sessionDir = extract SESSION_DIR from result  # CRITICAL: Use this in all script calls

→ Creates folders, _meta.json, _status.json
→ Auto-launches dashboard in separate terminal

# Set spec format in _meta.json
_meta.specFormat = "yaml"  # Default to YAML for new projects
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: .spec-it/{sessionId}/plan/_meta.json
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
1. Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start design-interviewer

2. Task(design-interviewer, opus):
   - Conduct Q&A for chapter
   - Output: 01-chapters/decisions/decision-{chapter}.md

3. Show chapter summary to user

4. AskUserQuestion: "Is this correct?"
   Options: [Yes, No, Questions]

5. Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete design-interviewer "" {stepNum}
   # stepNum: 1.1 (CH-00), 1.2 (CH-01~CH-03), 1.3 (CH-04~CH-05), 1.4 (CH-06~CH-07)

6. IF No/Questions: Revise and re-ask

# After CH-07 (step 1.4) completes:
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 1 2 "2.1"
```

---

## Phase 2: UI Architecture

### Step 2.1: Layout System + Screen List

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start ui-architect

Task(ui-architect, sonnet):
  prompt: "
    Role: ui-architect

    === YAML UI FRAME REFERENCE (MUST READ) ===
    Read: skills/shared/references/yaml-ui-frame/01-basic-structure.md
    Read: skills/shared/references/yaml-ui-frame/02-grid-definition.md

    === DESIGN REFERENCE ===
    Read: {_meta.designTrendsPath}/references/trends-summary.md
    Read: {_meta.designTrendsPath}/references/component-patterns.md
    Read: {_meta.designTrendsPath}/templates/navigation-templates.md

    Design Style: {_meta.designStyle}
    Applied Trends: {_meta.designTrends}

    === OUTPUT FORMAT (YAML) ===
    Use template: assets/templates/LAYOUT_TEMPLATE.yaml
    Reference design tokens: shared/design-tokens.yaml

    Generate: 02-wireframes/layouts/layout-system.yaml and 02-wireframes/layouts/components.yaml
    Generate screen lists per domain/user type:
      - 02-wireframes/<domain>/shared.md
      - 02-wireframes/<domain>/<user-type>/screen-list.md
    Screen list rules:
      - user_type: buyer | seller | admin | operator
      - id format: <domain>-<user>-<flow>-<seq>
      - fields: id, title, flow, priority, notes, depends_on(optional)
    Include design direction in domain shared.md
  "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/screen-planner.sh {sessionId}
→ Creates screen-groups.json
```

### Step 2.1b: Generate Wireframes (Parallel Batch)

```
FOR each batch (4 groups):
  Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/executors/batch-runner.sh {sessionId} wireframe {batchIndex}

    Task(ui-architect, sonnet, parallel):
      prompt: "
        Role: ui-architect

        Screen list: {screenListPath}
        Read: {screenListPath}
        Read: 02-wireframes/<domain>/shared.md (same domain as screen list)
        Render all screens in this list (respect depends_on order)

      === YAML UI FRAME REFERENCE (MUST READ) ===
      Read: skills/shared/references/yaml-ui-frame/03-components.md
      Read: skills/shared/references/yaml-ui-frame/07-design-direction.md

      === DESIGN REFERENCE ===
      Read: {_meta.designTrendsPath}/references/trends-summary.md
      Read: {_meta.designTrendsPath}/references/component-patterns.md

      Design Style: {_meta.designStyle}

      === OUTPUT FORMAT (YAML) ===
      Use template: assets/templates/UI_WIREFRAME_TEMPLATE.yaml
      Reference: shared/design-tokens.yaml via _ref

      Input: 02-wireframes/<domain>/<user-type>/screen-list.md + 02-wireframes/<domain>/shared.md
      Output file: 02-wireframes/<domain>/<user-type>/wireframes/{screen-id}.yaml

      === YAML STRUCTURE ===
      Each wireframe must include:
      - id, name, route, type, priority
      - layout: type, sidebar, header, main
      - grid: areas, columns, rows (CSS Grid)
      - responsive: desktop, tablet, mobile
      - components: list with props, styles, testId
      - interactions: clicks, forms, stateChanges
      - designDirection: appliedTrends, componentPatterns, colorTokens, motionGuidelines

      === CRITICAL RULES ===
      - NEVER use ASCII box characters (┌─┐│└┘)
      - Use grid.areas for layout (CSS Grid syntax)
      - Use components array with typed elements
      - Include testId for all interactive elements
    "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete ui-architect "" 2.1
```

### Step 2.2: Component Discovery

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start component-auditor

Task(component-auditor, haiku):
  Output: 03-components/inventory.md, gap-analysis.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete component-auditor "" 2.2
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 2 3 "3.1"

AskUserQuestion: "UI Architecture complete. Continue?"
```

---

## Phase 3: Component Specification

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/component-planner.sh {sessionId}
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "component-builder,component-migrator"

Task(component-builder, sonnet, parallel):
  prompt: "
    Role: component-builder

    === OUTPUT FORMAT (YAML) ===
    Use template: assets/templates/COMPONENT_SPEC_TEMPLATE.yaml
    Reference: shared/design-tokens.yaml via _ref

    Output file: 03-components/new/{component}.yaml

    Include all sections:
    - id, name, category, priority
    - props: with types, required, defaults
    - variants, states
    - visual: sizes, baseStyles, animation
    - accessibility: role, keyboardNav, ariaAttributes
    - dependencies, tests
  "
  Output: 03-components/new/{component}.yaml

Task(component-migrator, sonnet):
  Output: 03-components/migrations/migration-plan.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "component-builder,component-migrator" "" 3.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 3 4 "4.1"

AskUserQuestion: "Components complete. Continue?"
```

---

## Phase 4: Critical Review

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "critical-reviewer,ambiguity-detector"

Task(critical-reviewer, opus):
  Output: 04-review/scenarios/, ia-review.md, exceptions/

Task(ambiguity-detector, opus):
  Output: 04-review/ambiguities.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "critical-reviewer,ambiguity-detector" "" 4.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 4 5 "5.1"

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/phase-dispatcher.sh {sessionId} ambiguity
→ IF must-resolve: AskUserQuestion for resolution
```

---

## Phase 5: Test Specification

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "persona-architect,test-spec-writer"

Task(persona-architect, sonnet):
  Output: 05-tests/personas/

Task(test-spec-writer, sonnet):
  Output: 05-tests/scenarios/, components/, coverage-map.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "persona-architect,test-spec-writer" "" 5.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 5 6 "6.1"

AskUserQuestion: "Tests complete. Continue?"
```

---

## Phase 6: Final Assembly

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start spec-assembler

Task(spec-assembler, haiku):
  Output: 06-final/final-spec.md, dev-tasks.md, SPEC-SUMMARY.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete spec-assembler "" 6.1

AskUserQuestion: "Spec complete. Handle tmp folder?"
Options: [Archive, Keep, Delete]

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} complete
```

---

## Output Structure

See `README.md` for the full output tree and examples.

---

## Resume

```
/frontend-skills:spec-it-stepbystep --resume {sessionId}
```

State saved in `_meta.json` after each step.
