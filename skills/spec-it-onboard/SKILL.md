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
| P3 | path-architect | `01-personas/*.md`, `00-analysis/navigation-structure.md` | `02-restructure/_index.md`, `02-restructure/{persona}-paths.md` | ★ |
| P4 | ux-scorer | `00-analysis/screens/*.md`, `devServerUrl` | `03-ux-audit/_index.md`, `03-ux-audit/{persona}/{screen}-score.md` | ★ |
| P5 | component-auditor | `projectPath/components/` | `04-components/_index.md`, `04-components/inventory.md` | - |
| P6 | ui-pattern-detector | `projectPath/**/*.tsx`, `04-components/inventory.md` | `05-patterns/_index.md`, `05-patterns/existing-components.md`, `05-patterns/duplicates/*.md`, `05-patterns/extraction-plan.md` | ★ |
| P7 | component-builder | `05-patterns/duplicates/*.md` | `06-component-specs/{component}.md` | ★ |
| P8 | component-migrator | `04-components/`, `05-patterns/`, `06-component-specs/` | `07-migration/_index.md`, `07-migration/migration-plan.md` | ★ |
| P9 | context-synthesizer | P1~P8 전체 output | `spec-map.md` | - |
| P10 | critical-review | `spec-map.md` | `08-review/` | ★ |
| P11 | test-spec-writer | `01-personas/`, `spec-map.md` | `09-tests/` | ★ |
| P12 | spec-assembler + dev-planner | `spec-map.md`, `09-tests/`, 전체 artifacts | `10-final/`, `dev-plan/development-map.md`, `dev-plan/{persona}/Phase-{n}/` | ★ |

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
  GOTO _meta.currentStep
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

## P3: Path Restructure

```
Bash: status-update.sh {sessionDir} agent-start path-architect

Read: shared/references/onboard/path-patterns.md

Task(path-architect, sonnet):
  Input: 01-personas/*.md, 00-analysis/navigation-structure.md
  Output:
    - 02-restructure/_index.md
    - 02-restructure/{persona}-paths.md

Bash: status-update.sh {sessionDir} agent-complete path-architect "" 3.1
Bash: meta-checkpoint.sh {sessionDir} 3.1

AskUserQuestion: "Path restructure planned. Review?"
Options: [Approve, Revise]
```

---

## P4: UX Audit

```
Bash: status-update.sh {sessionDir} agent-start ux-scorer

Read: shared/references/onboard/ux-scoring-criteria.md

Task(ux-scorer, sonnet):
  Input: 00-analysis/screens/*.md, devServerUrl
  Tools: Playwright MCP
  Output:
    - 03-ux-audit/_index.md
    - 03-ux-audit/{persona}/{screen}-score.md

Bash: status-update.sh {sessionDir} agent-complete ux-scorer "" 4.1
Bash: meta-checkpoint.sh {sessionDir} 4.1

AskUserQuestion: "UX audit complete. Overall score: {score}. Review?"
Options: [Approve, Revise]
```

---

## P5: Component Audit

```
Bash: status-update.sh {sessionDir} agent-start component-auditor

Task(component-auditor, haiku):
  Input: projectPath/components/
  Output:
    - 04-components/_index.md
    - 04-components/inventory.md

Bash: status-update.sh {sessionDir} agent-complete component-auditor "" 5.1
Bash: meta-checkpoint.sh {sessionDir} 5.1
```

---

## P6: Pattern Detection

```
Bash: status-update.sh {sessionDir} agent-start ui-pattern-detector

Read: shared/references/onboard/pattern-examples.md

Task(ui-pattern-detector, sonnet):
  Input: projectPath/**/*.tsx, 04-components/inventory.md
  Output:
    - 05-patterns/_index.md
    - 05-patterns/existing-components.md
    - 05-patterns/duplicates/*.md
    - 05-patterns/extraction-plan.md

Bash: status-update.sh {sessionDir} agent-complete ui-pattern-detector "" 6.1
Bash: meta-checkpoint.sh {sessionDir} 6.1

AskUserQuestion: "{patternCount} patterns detected. Review extraction plan?"
Options: [Approve, Revise]
```

---

## P7: Component Specs

```
Bash: status-update.sh {sessionDir} agent-start component-builder

Task(component-builder, sonnet):
  Input: 05-patterns/duplicates/*.md
  Output: 06-component-specs/{component}.md

Bash: status-update.sh {sessionDir} agent-complete component-builder "" 7.1
Bash: meta-checkpoint.sh {sessionDir} 7.1

AskUserQuestion: "Component specs created. Review?"
Options: [Approve, Revise]
```

---

## P8: Migration Plan

```
Bash: status-update.sh {sessionDir} agent-start component-migrator

Task(component-migrator, sonnet):
  Input: 04-components/, 05-patterns/, 06-component-specs/
  Output:
    - 07-migration/_index.md
    - 07-migration/migration-plan.md

Bash: status-update.sh {sessionDir} agent-complete component-migrator "" 8.1
Bash: meta-checkpoint.sh {sessionDir} 8.1

AskUserQuestion: "Migration plan ready. Review?"
Options: [Approve, Revise]
```

---

## P9: Context Synthesis

```
Bash: status-update.sh {sessionDir} agent-start context-synthesizer

Task(context-synthesizer, sonnet):
  Input: All artifacts from P1-P8
  Output: spec-map.md

Bash: status-update.sh {sessionDir} agent-complete context-synthesizer "" 9.1
Bash: meta-checkpoint.sh {sessionDir} 9.1
```

---

## P10: Critical Review

```
Skill(critical-review, --mode stepbystep):
  Input: spec-map.md
  Output: 08-review/

Bash: meta-checkpoint.sh {sessionDir} 10.1

AskUserQuestion: "Critical review complete. Proceed?"
Options: [Proceed, Review]
```

---

## P11: Test Specification

```
Bash: status-update.sh {sessionDir} agent-start test-spec-writer

Task(test-spec-writer, sonnet):
  Input: 01-personas/, spec-map.md
  Output: 09-tests/

Bash: status-update.sh {sessionDir} agent-complete test-spec-writer "" 11.1
Bash: meta-checkpoint.sh {sessionDir} 11.1

AskUserQuestion: "Test scenarios complete. Approve?"
Options: [Approve, Revise]
```

---

## P12: Final Assembly + Dev Plan

```
Bash: status-update.sh {sessionDir} agent-start spec-assembler

Task(spec-assembler, haiku):
  Input: spec-map.md, 09-tests/
  Output: 10-final/

Task(dev-planner, sonnet):
  Input: All artifacts
  Output:
    - dev-plan/development-map.md
    - dev-plan/{persona}/Phase-{n}/

Bash: status-update.sh {sessionDir} agent-complete spec-assembler "" 12.1
Bash: meta-checkpoint.sh {sessionDir} 12.1
```

---

## Final Approval

```
Read: 10-final/SPEC-SUMMARY.md

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
├── 02-restructure/
│   ├── _index.md
│   └── {persona}-paths.md
├── 03-ux-audit/
│   ├── _index.md
│   └── {persona}/{screen}-score.md
├── 04-components/
│   ├── _index.md
│   └── inventory.md
├── 05-patterns/
│   ├── _index.md
│   ├── duplicates/*.md
│   └── extraction-plan.md
├── 06-component-specs/*.md
├── 07-migration/
├── 08-review/
├── 09-tests/
├── 10-final/
├── spec-map.md
└── dev-plan/
```

---

## Resume

```
/spec-it-onboard --resume {sessionId}
```
