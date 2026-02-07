---
name: spec-it-onboard
description: "Onboard existing Next.js mockup into spec-it workflow. Transform mockups to production-ready specifications."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[project-path] [--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-onboard: Mockup to Spec Workflow

Transform existing Next.js mockup projects into production-ready specifications.

**Input**: Next.js codebase (*.tsx)
**Output**: Complete spec-it artifacts ready for spec-it-execute

## Rules

See [shared/references/common/output-rules.md](../../shared/references/common/output-rules.md).
See [shared/references/common/context-rules.md](../../shared/references/common/context-rules.md).

## Execution Order

Run each phase strictly in order. Do NOT start the next phase until the current phase is complete and approved (where applicable).

| Phase | Agent | Input | Output | ★ |
|-------|-------|-------|--------|---|
| P1 | mockup-analyzer | `projectPath`, `devServerUrl` | `00-analysis/_index.md`, `00-analysis/navigation-structure.md`, `00-analysis/screens/*.md` | ★ |
| P2 | persona-architect | `00-analysis/_index.md`, `00-analysis/navigation-structure.md` | `01-personas/*.md` | ★ |
| P3 | critic-logic, critic-feasibility, critic-frontend, critic-analytics | `00-analysis/`, `01-personas/` | `02-critique/critique-*.md`, `02-critique/critique-synthesis.md` | - |
| P4 | critique-resolver | `02-critique/critique-synthesis.md` | `02-critique/critique-solve/*.md` | ★ |
| P5 | chapter-planner (restructure mode) | P1~P4 전체 output | `03-chapters/restructure-plan-final.md` | ★ |
| P6 | path-architect | `01-personas/*.md`, `03-chapters/restructure-plan-final.md`, `00-analysis/navigation-structure.md` | `04-restructure/_index.md`, `04-restructure/{persona}-paths.md` | ★ |
| P7 | component-auditor | `projectPath/components/` | `05-components/_index.md`, `05-components/inventory.md` | - |
| P8 | ui-pattern-detector | `projectPath/**/*.tsx`, `05-components/inventory.md` | `06-patterns/_index.md`, `06-patterns/existing-components.md`, `06-patterns/duplicates/*.md`, `06-patterns/extraction-plan.md` | ★ |
| P9 | component-builder | `06-patterns/duplicates/*.md` | `07-component-specs/{component}.md` | ★ |
| P10 | component-migrator | `05-components/`, `06-patterns/`, `07-component-specs/` | `08-migration/_index.md`, `08-migration/migration-plan.md` | ★ |
| P11 | context-synthesizer | P1~P10 전체 output | `spec-map.md` | - |
| P12 | critical-review | `spec-map.md` | `09-review/` (FAIL → P5 회귀) | ★ |
| P13 | test-spec-writer | `01-personas/`, `spec-map.md` | `10-tests/` | ★ |
| P14 | api-predictor | `spec-map.md`, `projectPath` | `dev-plan/api-map.md` | - |
| P15 | spec-assembler + dev-planner | `spec-map.md`, `10-tests/`, 전체 artifacts | `11-final/`, `dev-plan/development-map.md`, `dev-plan/{persona}/Phase-{n}/` | ★ |

---

## Phase 0: Init

### Step 0.1: Detect Project

```
IF project-path provided:
  projectPath = args[0]
ELSE:
  projectPath = pwd

Read: {projectPath}/package.json
Detect: Next.js version, App Router vs Pages
Glob: {projectPath}/app/**/page.tsx

IF not Next.js:
  Output: "Not a Next.js project"
  STOP
```

### Step 0.2: Session Init

```
docsDir = {pwd}/spec-it-onboard          # pwd = 스킬 실행 위치 (분석 대상 폴더가 아님)
result = Bash: session-init.sh "" onboard "{projectPath}"
sessionId = extract SESSION_ID
sessionDir = extract SESSION_DIR

# 모든 output은 {pwd}/spec-it-onboard/{sessionId}/ 에 생성
outputDir = {docsDir}/{sessionId}
```

> **IMPORTANT**: Output 파일은 반드시 스킬을 실행하는 현재 디렉토리(`pwd`)에 `spec-it-onboard/` 폴더를 만들어 저장합니다.
> 분석 대상 프로젝트(`projectPath`) 안에 파일을 생성하지 마세요.

### Step 0.R: Resume

```
IF --resume in args:
  Read: .spec-it/{sessionId}/plan/_meta.json
  IF reexecuteFromP5: GOTO P5
  ELSE: GOTO _meta.currentStep
```

---

## P1: Mockup Analysis

> **MANDATORY**: P1 MUST use Playwright MCP for all analysis.
> The agent MUST visit every screen in the browser and click ALL interactive elements.
> - Click every button, link, tab, dropdown, and role="button" element
> - Click elements that have onClick handlers or appear clickable in the snapshot
> - Click center of button-like visual elements even if not properly componentized as `<button>`
> - Record all state changes: modals, dropdowns, navigation, toasts, expanded content
> - Code-only analysis without browser interaction is NOT acceptable

```
Bash: status-update.sh {sessionDir} agent-start mockup-analyzer

Task(mockup-analyzer, sonnet):
  Input: projectPath, devServerUrl
  Tools: Playwright MCP (browser_navigate, browser_snapshot, browser_click, browser_hover, browser_wait_for, browser_take_screenshot, browser_evaluate, browser_press_key)
  REQUIRED: Use browser_snapshot on every screen, browser_click ALL interactive elements found in snapshot
  Output:
    - 00-analysis/_index.md
    - 00-analysis/navigation-structure.md
    - 00-analysis/screens/*.md (MUST include Interactive Exploration Results + Hidden UI Discovered sections)

Bash: status-update.sh {sessionDir} agent-complete mockup-analyzer "" 1.1
Bash: meta-checkpoint.sh {sessionDir} 1.1

AskUserQuestion: "Analysis complete. {screenCount} screens detected, {interactionCount} interactive elements explored. Review?"
Options: [Approve, Revise]
```

---

## P2: Persona Definition

```
Bash: status-update.sh {sessionDir} agent-start persona-architect

Task(persona-architect, sonnet):
  Input: 00-analysis/_index.md, 00-analysis/navigation-structure.md
  Output: 01-personas/*.md

Bash: status-update.sh {sessionDir} agent-complete persona-architect "" 2.1
Bash: meta-checkpoint.sh {sessionDir} 2.1

AskUserQuestion: "Personas defined. Review?"
Options: [Approve, Revise]
```

---

## P3: Multi-Critic (Parallel)

```
Bash: status-update.sh {sessionDir} agent-start "critic-logic,critic-feasibility,critic-frontend"

Task(critic-logic, sonnet, parallel):
  Input: 00-analysis/, 01-personas/
  Output: 02-critique/critique-logic.md

Task(critic-feasibility, sonnet, parallel):
  Input: 00-analysis/, 01-personas/
  Output: 02-critique/critique-feasibility.md

Task(critic-frontend, sonnet, parallel):
  Input: 00-analysis/, 01-personas/
  Output: 02-critique/critique-frontend.md

WAIT for all 3

Bash: status-update.sh {sessionDir} agent-complete "critic-logic,critic-feasibility,critic-frontend"
Bash: status-update.sh {sessionDir} agent-start critic-analytics

Task(critic-analytics, sonnet):
  Input: 02-critique/critique-logic.md, critique-feasibility.md, critique-frontend.md
  Output: 02-critique/critique-synthesis.md

Bash: status-update.sh {sessionDir} agent-complete critic-analytics "" 3.1
Bash: meta-checkpoint.sh {sessionDir} 3.1
```

---

## P4: Critique Resolution (User Input)

```
Read: 02-critique/critique-synthesis.md
Extract: must_resolve_count

IF must_resolve_count > 0:
  Bash: status-update.sh {sessionDir} agent-start critique-resolver

  Skill(critique-resolver):
    Input: critique-synthesis.md
    Output: 02-critique/critique-solve/*.md

  Bash: status-update.sh {sessionDir} agent-complete critique-resolver "" 4.1
ELSE:
  Write: 02-critique/critique-solve/merged-decisions.md (no issues)

Bash: meta-checkpoint.sh {sessionDir} 4.1

AskUserQuestion: "Critique resolution complete. Review?"
Options: [Approve, Revise]
```

---

## P5: Restructure Plan (onboard 전용)

> complex의 chapter-planner와 달리, onboard에서는 **기존 코드의 리팩토링 구조를 확정**합니다.
> "뭘 만들지"가 아니라 "이미 있는 걸 어떻게 재구성할지" 결정합니다.

```
Bash: status-update.sh {sessionDir} agent-start chapter-planner

Task(chapter-planner, opus):
  Input: 00-analysis/, 01-personas/, 02-critique/critique-synthesis.md, 02-critique/critique-solve/
  Context: This is an ONBOARD project - existing code restructuring, NOT new development.
           Focus on: what to keep, what to refactor, what to merge, what to split.
  Output: 03-chapters/restructure-plan-final.md

Bash: status-update.sh {sessionDir} agent-complete chapter-planner "" 5.1
Bash: meta-checkpoint.sh {sessionDir} 5.1

AskUserQuestion: "Restructure plan confirmed. {N} chapters. Proceed with path design?"
Options: [Proceed, Modify Plan, Review Details]
```

---

## P6: Path Restructure

```
Bash: status-update.sh {sessionDir} agent-start path-architect

Read: shared/references/onboard/path-patterns.md

Task(path-architect, sonnet):
  Input: 01-personas/*.md, 03-chapters/restructure-plan-final.md, 00-analysis/navigation-structure.md
  Output:
    - 04-restructure/_index.md
    - 04-restructure/{persona}-paths.md

Bash: status-update.sh {sessionDir} agent-complete path-architect "" 6.1
Bash: meta-checkpoint.sh {sessionDir} 6.1

AskUserQuestion: "Path restructure planned. Review?"
Options: [Approve, Revise]
```

---

## P7: Component Audit

```
Bash: status-update.sh {sessionDir} agent-start component-auditor

Task(component-auditor, sonnet):
  Input: projectPath/components/
  Output:
    - 05-components/_index.md
    - 05-components/inventory.md

Bash: status-update.sh {sessionDir} agent-complete component-auditor "" 7.1
Bash: meta-checkpoint.sh {sessionDir} 7.1
```

---

## P8: Pattern Detection

```
Bash: status-update.sh {sessionDir} agent-start ui-pattern-detector

Read: shared/references/onboard/pattern-examples.md

Task(ui-pattern-detector, sonnet):
  Input: projectPath/**/*.tsx, 05-components/inventory.md
  Output:
    - 06-patterns/_index.md
    - 06-patterns/existing-components.md
    - 06-patterns/duplicates/*.md
    - 06-patterns/extraction-plan.md

Bash: status-update.sh {sessionDir} agent-complete ui-pattern-detector "" 8.1
Bash: meta-checkpoint.sh {sessionDir} 8.1

AskUserQuestion: "{patternCount} patterns detected. Review extraction plan?"
Options: [Approve, Revise]
```

---

## P9: Component Specs

```
Bash: status-update.sh {sessionDir} agent-start component-builder

Task(component-builder, sonnet):
  Input: 06-patterns/duplicates/*.md
  Output: 07-component-specs/{component}.md

Bash: status-update.sh {sessionDir} agent-complete component-builder "" 9.1
Bash: meta-checkpoint.sh {sessionDir} 9.1

AskUserQuestion: "Component specs created. Review?"
Options: [Approve, Revise]
```

---

## P10: Migration Plan

```
Bash: status-update.sh {sessionDir} agent-start component-migrator

Task(component-migrator, sonnet):
  Input: 05-components/, 06-patterns/, 07-component-specs/
  Output:
    - 08-migration/_index.md
    - 08-migration/migration-plan.md

Bash: status-update.sh {sessionDir} agent-complete component-migrator "" 10.1
Bash: meta-checkpoint.sh {sessionDir} 10.1

AskUserQuestion: "Migration plan ready. Review?"
Options: [Approve, Revise]
```

---

## P11: Context Synthesis

```
Bash: status-update.sh {sessionDir} agent-start context-synthesizer

Task(context-synthesizer, sonnet):
  Input: All artifacts from P1-P10
  Output: spec-map.md

Bash: status-update.sh {sessionDir} agent-complete context-synthesizer "" 11.1
Bash: meta-checkpoint.sh {sessionDir} 11.1
```

---

## P12: Critical Review (회귀 가능)

```
Skill(critical-review, --mode stepbystep):
  Input: spec-map.md
  Output: 09-review/

Read: 09-review/review-decisions.md
Check: Re-execution Trigger

IF reexecution_required:
  Output: "Returning to P5 for re-planning."
  _meta.reexecuteFromP5 = true
  GOTO P5

Bash: meta-checkpoint.sh {sessionDir} 12.1

AskUserQuestion: "Critical review complete. Proceed?"
Options: [Proceed, Review]
```

---

## P13: Test Specification

```
Bash: status-update.sh {sessionDir} agent-start test-spec-writer

Task(test-spec-writer, sonnet):
  Input: 01-personas/, spec-map.md
  Output: 10-tests/

Bash: status-update.sh {sessionDir} agent-complete test-spec-writer "" 13.1
Bash: meta-checkpoint.sh {sessionDir} 13.1

AskUserQuestion: "Test scenarios complete. Approve?"
Options: [Approve, Revise]
```

---

## P14: API Prediction

```
Bash: status-update.sh {sessionDir} agent-start api-predictor

Skill(api-predictor):
  Input: spec-map.md, projectPath (기존 코드의 fetch/axios 호출 분석)
  Output: dev-plan/api-map.md

Bash: status-update.sh {sessionDir} agent-complete api-predictor "" 14.1
Bash: meta-checkpoint.sh {sessionDir} 14.1
```

---

## P15: Final Assembly + Dev Plan

```
Bash: status-update.sh {sessionDir} agent-start spec-assembler

Task(spec-assembler, haiku):
  Input: spec-map.md, 10-tests/
  Output: 11-final/

Task(dev-planner, sonnet):
  Input: All artifacts
  Output:
    - dev-plan/development-map.md
    - dev-plan/{persona}/Phase-{n}/

Bash: status-update.sh {sessionDir} agent-complete spec-assembler "" 15.1
Bash: meta-checkpoint.sh {sessionDir} 15.1
```

---

## Final Approval

```
Read: 11-final/SPEC-SUMMARY.md

AskUserQuestion: "Spec complete. What next?"
Options: [
  {label: "Run /spec-it-execute", description: "Start implementation"},
  {label: "Archive", description: "Move to archive/"},
  {label: "Keep", description: "Keep in spec-it-onboard/"}
]

Bash: status-update.sh {sessionDir} complete
```

---

## Output Structure

```
spec-it-onboard/{session-id}/
├── 00-analysis/
│   ├── _index.md
│   ├── navigation-structure.md
│   └── screens/*.md
├── 01-personas/*.md
├── 02-critique/
│   ├── critique-logic.md
│   ├── critique-feasibility.md
│   ├── critique-frontend.md
│   ├── critique-synthesis.md
│   └── critique-solve/*.md
├── 03-chapters/
│   └── restructure-plan-final.md
├── 04-restructure/
│   ├── _index.md
│   └── {persona}-paths.md
├── 05-components/
│   ├── _index.md
│   └── inventory.md
├── 06-patterns/
│   ├── _index.md
│   ├── duplicates/*.md
│   └── extraction-plan.md
├── 07-component-specs/*.md
├── 08-migration/
│   ├── _index.md
│   └── migration-plan.md
├── 09-review/
├── 10-tests/
├── 11-final/
├── spec-map.md
└── dev-plan/
    ├── api-map.md
    ├── development-map.md
    └── {persona}/Phase-{n}/
```

---

## Resume

```
/spec-it-onboard --resume {sessionId}
```
