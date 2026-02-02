---
name: spec-it-complex
description: "Hybrid spec generator with milestone approvals for medium projects."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-complex: Hybrid Mode

Transform PRD/vibe-coding into frontend specifications with **auto-validation** and **4 milestone approvals**.

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).
See [shared/rules/50-question-policy.md](../shared/rules/50-question-policy.md) (Question Policy: Hybrid).

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
    question: "어떤 디자인 스타일을 적용하시겠습니까? (2026 Design Trends 기반)",
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
        {label: "Micro-Animations", description: "의미있는 모션"},
        {label: "3D Visuals", description: "3D 아이콘"},
        {label: "Gamification", description: "Progress, 배지"}
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
result = Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/session-init.sh "" {uiMode} "$(pwd)"

# Parse output to get SESSION_DIR (full absolute path)
sessionId = extract SESSION_ID from result
sessionDir = extract SESSION_DIR from result  # CRITICAL: Use this in all script calls

IF _meta.dashboardEnabled == "Enable":
  Output: "⏺ Dashboard:  file://$HOME/.claude/plugins/marketplaces/claude-frontend-skills/web-dashboard/index.html  을 열어 실시간 진행 상황을 확인할 수 있습니다."
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: .spec-it/{sessionId}/plan/_meta.json
  GOTO: _meta.currentStep
```

---

## Phase 1: Design Brainstorming

### Step 1.1: Requirements Analysis

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start design-interviewer

Task(design-interviewer, opus):
  Output: 00-requirements/requirements.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete design-interviewer "" 1.1
```

### Step 1.2: Divergent Thinking + Critique

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start divergent-thinker

Task(divergent-thinker, sonnet):
  Output: 01-chapters/alternatives/*.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete divergent-thinker "" 1.2
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start chapter-critic

FOR round in [1, 2, 3]:
  Task(chapter-critic, opus):
    Output: 01-chapters/critique-round{round}.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete chapter-critic "" 1.3
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start chapter-planner

Task(chapter-planner, opus):
  Output: 01-chapters/chapter-plan-final.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete chapter-planner "" 1.4
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 1 2 "2.1"
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
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "chapter-writer,ui-architect"

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

    Output:
      - 02-wireframes/layouts/layout-system.yaml
      - 02-wireframes/layouts/components.yaml
      - 02-wireframes/domain-map.md (domains + user types)
  "

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

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/screen-planner.sh {sessionId}

FOR each batch:
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
      Output: 02-wireframes/<domain>/<user-type>/wireframes/{screen-id}.yaml

      === CRITICAL RULES ===
      - NEVER use ASCII box characters
      - Use grid.areas for layout (CSS Grid syntax)
      - Include testId for all interactive elements
    "

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "chapter-writer,ui-architect" "" 2.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 2 3 "3.1"
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
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "chapter-writer,component-auditor"

Task(chapter-writer, sonnet, parallel):
  Output: 01-chapters/decisions/CH-03.md, CH-04.md

Task(component-auditor, haiku):
  Output: 03-components/inventory.md, gap-analysis.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "chapter-writer,component-auditor"
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/planners/component-planner.sh {sessionId}
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "component-builder,component-migrator"

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/spec-{component}.md

Task(component-migrator, sonnet):
  Output: 03-components/migrations/migration-plan.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "component-builder,component-migrator" "" 3.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 3 4 "4.1"
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
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "chapter-writer,critical-reviewer,ambiguity-detector"

Task(chapter-writer, sonnet, parallel):
  Output: CH-05.md, CH-06.md, CH-07.md

Task(critical-reviewer, opus, parallel):
  Output: 04-review/scenarios/, ia-review.md, exceptions/

Task(ambiguity-detector, opus, parallel):
  Output: 04-review/ambiguities.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "chapter-writer,critical-reviewer,ambiguity-detector" "" 4.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 4 5 "5.1"

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/phase-dispatcher.sh {sessionId} ambiguity
→ IF must-resolve: AskUserQuestion
```

---

## Phase 5: Test Specification

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start "persona-architect,test-spec-writer"

Task(persona-architect, sonnet, parallel):
  Output: 05-tests/personas/

Task(test-spec-writer, sonnet, parallel):
  Output: 05-tests/scenarios/, components/, coverage-map.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete "persona-architect,test-spec-writer" "" 5.1
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 5 6 "6.1"
```

---

## Phase 6: Final Assembly

```
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-start spec-assembler

Task(spec-assembler, haiku):
  Output: 06-final/final-spec.md, dev-tasks.md, SPEC-SUMMARY.md

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} agent-complete spec-assembler "" 6.1
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
.spec-it/{sessionId}/plan/
├── _meta.json, _status.json

tmp/
├── 00-requirements/
├── 01-chapters/
│   ├── alternatives/, decisions/
│   ├── critique-round1~3.md
│   └── chapter-plan-final.md
├── 02-wireframes/
│   ├── layouts/
│   ├── domain-map.md
│   ├── <domain>/shared.md
│   ├── <domain>/<user-type>/screen-list.md
│   └── <domain>/<user-type>/wireframes/, [html/]
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
