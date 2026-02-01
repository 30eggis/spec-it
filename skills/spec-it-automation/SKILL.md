---
name: spec-it-automation
description: "Full-auto spec generator with minimal approvals for large projects."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-automation: Full Auto Mode

Transform PRD/vibe-coding into frontend specifications with **maximum automation** and **minimal user intervention**.

**Auto-Execute:** After spec generation, automatically proceeds to `spec-it-execute` for implementation.

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).

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
★ Final Approval (only user interaction for spec)
      ↓
[Auto: spec-it-execute (Phase 0-9)]
      ↓
★ Implementation Complete
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
# IMPORTANT: workDir is the current working directory where tmp/ folder will be created
result = Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/session-init.sh "" {uiMode} "$(pwd)"

# Parse output to get SESSION_DIR (full absolute path)
# Output format: SESSION_ID:xxx, SESSION_DIR:/path/to/tmp/xxx
sessionId = extract SESSION_ID from result
sessionDir = extract SESSION_DIR from result  # CRITICAL: Use this in all status-update calls

→ Auto-launches dashboard
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: .spec-it/{sessionId}/plan/_meta.json
  GOTO: _meta.currentStep
```

---

## Phase 1: Design Brainstorming (Auto)

### Step 1.1: Requirements

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start design-interviewer

Task(design-interviewer, opus):
  Output: 00-requirements/requirements.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete design-interviewer
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/meta-checkpoint.sh {sessionDir} 1.1
```

### Step 1.2: Divergent Thinking

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start divergent-thinker

Task(divergent-thinker, sonnet):
  Output: 01-chapters/alternatives/*.md, _index.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete divergent-thinker "" 1.2
```

### Step 1.3: Multi-Critic Debate (Parallel)

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "critic-logic,critic-feasibility,critic-frontend"

Task(critic-logic, sonnet, parallel):
  Output: 01-chapters/critique-logic.md

Task(critic-feasibility, sonnet, parallel):
  Output: 01-chapters/critique-feasibility.md

Task(critic-frontend, sonnet, parallel):
  Output: 01-chapters/critique-frontend.md

WAIT for all 3

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "critic-logic,critic-feasibility,critic-frontend"
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start critic-moderator

Task(critic-moderator, opus):
  - Synthesize 3 critiques
  - Resolve conflicts
  - Output: 01-chapters/critique-final.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete critic-moderator "" 1.3
```

### Step 1.4: Chapter Plan

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start chapter-planner

Task(chapter-planner, opus):
  Output: 01-chapters/chapter-plan-final.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete chapter-planner "" 1.4
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 1 2 "2.1"
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/validate-output.sh "$(pwd)/tmp"
```

---

## Phase 2: UI + Components (Auto)

### Step 2.1: UI Architecture

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

    Design Style: {_meta.designStyle}

    Output: screen-list.md, layouts/layout-system.yaml
  "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/screen-planner.sh {sessionId}

FOR each batch (4 screens):
  Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/executors/batch-runner.sh {sessionId} wireframe {i}

  Task(ui-architect, sonnet, parallel x4):
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
      Output file: wireframes/{screen}.yaml

      === CRITICAL RULES ===
      - NEVER use ASCII box characters
      - Use grid.areas for layout (CSS Grid syntax)
      - Include testId for all interactive elements
    "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete ui-architect "" 2.1
```

### Step 2.2: Component Discovery + Build

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start component-auditor

Task(component-auditor, haiku, parallel):
  Output: 03-components/inventory.md, gap-analysis.md

WAIT

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete component-auditor
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/component-planner.sh {sessionId}
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "component-builder,component-migrator"

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/spec-{component}.md

Task(component-migrator, sonnet, parallel):
  Output: 03-components/migrations/migration-plan.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "component-builder,component-migrator" "" 2.2
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 2 3 "3.1"
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/validate-output.sh "$(pwd)/tmp"
```

---

## Phase 3: Critical Review (Auto)

### Step 3.1: Parallel Review

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "critical-reviewer,ambiguity-detector"

Task(critical-reviewer, opus, parallel):
  Output: 04-review/scenarios/, ia-review.md, exceptions/

Task(ambiguity-detector, opus, parallel):
  Output: 04-review/ambiguities.md

WAIT for both

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "critical-reviewer,ambiguity-detector" "" 3.1
```

### Step 3.2: Ambiguity Resolution

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/phase-dispatcher.sh {sessionDir} ambiguity

IF DISPATCH:user-question:
  Read: 04-review/ambiguities.md
  Extract "Must Resolve" items

  AskUserQuestion: "Resolve these ambiguities"
  (dynamic options based on ambiguities)

  Write: 04-review/ambiguities-resolved.md

ELSE:
  Auto-proceed

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete ambiguity-resolver "" 3.2
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 3 4 "4.1"
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/validate-output.sh "$(pwd)/tmp"
```

---

## Phase 4: Test Specification (Auto)

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "persona-architect,test-spec-writer"

Task(persona-architect, sonnet, parallel):
  Output: 05-tests/personas/

Task(test-spec-writer, sonnet, parallel):
  Output: 05-tests/scenarios/, components/, coverage-map.md

WAIT for both

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "persona-architect,test-spec-writer" "" 4.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 4 5 "5.1"
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/validate-output.sh "$(pwd)/tmp"
```

---

## Phase 5: Final Assembly (Auto)

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start spec-assembler

Task(spec-assembler, haiku):
  Output:
  - 06-final/final-spec.md
  - 06-final/dev-tasks.md
  - 06-final/SPEC-SUMMARY.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete spec-assembler "" 5.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 5 6 "6.1"
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/validate-output.sh "$(pwd)/tmp"
```

---

## Phase 6: Final Approval & Auto-Execute

```
Read: 06-final/SPEC-SUMMARY.md

AskUserQuestion: "Spec complete. Ready to start implementation?"
Options: [
  {label: "Proceed to Execute (Recommended)", description: "Auto-start implementation"},
  {label: "Review First", description: "I'll review the spec, then manually run /spec-it-execute"},
  {label: "Spec Only", description: "Don't execute, keep spec files"}
]

IF "Proceed to Execute" OR "Proceed":
  Output: "Starting implementation with spec-it-execute..."

  # Auto-invoke spec-it-execute (specs are in tmp/)
  Skill(spec-it-execute, "tmp")
ELIF "Review First":
  Output: "Spec saved. Run /spec-it-execute tmp when ready."
ELSE ("Spec Only"):
  AskUserQuestion: "Handle tmp folder?"
  Options: [Archive, Keep, Delete]
  IF Archive: mv tmp archive/specs-{sessionId}
  IF Delete: rm -rf tmp

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} complete
```

---
## Resume
```
/frontend-skills:spec-it-automation --resume {sessionId}
```
