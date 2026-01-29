---
name: spec-it
description: "Frontend specification generator (Manual mode). Transforms vibe-coding/PRD into production-ready detailed specifications with chapter-by-chapter approval. Use for: (1) Frontend specification writing, (2) Converting vibe-coding/PRD to dev specs, (3) UI/component design documents, (4) Scenario test specifications"
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
---

# spec-it: Frontend Specification Generator (Manual Mode)

Transform vibe-coding/PRD into **production-ready frontend specifications** with **chapter-by-chapter user approval**.

---

## CRITICAL: Context Management Rules

**반드시 [shared/context-rules.md](../shared/context-rules.md) 규칙을 준수하세요.**

### 핵심 규칙 요약

| 규칙 | 제한 | 위반 시 |
|------|------|---------|
| 직접 Write | 100줄 이하만 | 에이전트에게 위임 |
| 파일 크기 | 600줄 이하 | 분리 필수 (wireframe 제외) |
| 동시 에이전트 | 최대 4개 | 배치로 나눠 실행 |
| 에이전트 반환 | 요약만 (경로+줄수) | 내용 포함 금지 |
| 분리 네이밍 | {index}-{name}-{type}.md | 통일 규칙 |

### 에이전트 프롬프트 필수 문구

```
OUTPUT RULES:
1. 모든 결과는 파일에 저장
2. 반환 시 "완료. 생성 파일: {경로} ({줄수}줄)" 형식만
3. 파일 내용을 응답에 절대 포함하지 않음
4. 600줄 초과 시 분리 (와이어프레임 제외)
5. 분리 시 네이밍: {index}-{name}-{type}.md
6. 분리 시 _index.md 필수 생성
```

---

## Mode Characteristics

- **Full control**: Every chapter requires user approval
- **No auto-validation**: Validation agents not used
- **User questions**: Frequent (per chapter)
- **Best for**: Small projects, learning the process, maximum control

## Commands Overview

| Command | Mode | Description |
|---------|------|-------------|
| `/frontend-skills:spec-it` | **Manual** | All chapters require user approval |
| `/frontend-skills:spec-it-complex` | Hybrid | Auto-validation + major milestone approval |
| `/frontend-skills:spec-it-automation` | Full Auto | Multi-agent validation, single final approval |
| `/frontend-skills:init-spec-md` | Utility | Create SPEC-IT files for existing code |

## Core Features

1. **Design Brainstorming**: Superpowers-style chunk-based Q&A for requirement refinement
2. **UI Architecture**: ASCII art wireframes and screen structure design
3. **Component Discovery**: Existing component scanning + gap analysis + migration
4. **Critical Review**: Rigorous scenario/IA/exception handling review
5. **Test Specification**: Persona-based scenario test specification generation
6. **SPEC-IT-{HASH}.md**: Metadata system for progressive context loading

## Workflow (Manual Mode)

```
[CH-00] → User Approval → [CH-01] → User Approval → ... → [CH-N] → User Approval
                ↓
         "Is this chapter content correct?"
         [Yes] [No] [Questions]
```

### Phase 0: Input Analysis
```
Agent: design-interviewer (opus)
Output: tmp/{session-id}/00-requirements/requirements.md
```

### Phase 1: Design Brainstorming

Chapter structure framework:
```
CH-00: Project Scope & Constraints
CH-01: User & Persona Definition
CH-02: Information Architecture
CH-03: Screen Inventory
CH-04: Feature Definition (N sub-chapters)
CH-05: Component Requirements
CH-06: State & Data Flow
CH-07: Non-Functional Requirements
```

For each chapter:
1. `design-interviewer` conducts Q&A
2. Present chapter summary to user
3. **USER APPROVAL**: "Is this content correct? [Yes] [No] [Questions]"
4. Proceed to next chapter

Output: `tmp/{session-id}/01-chapters/decisions/`

### Phase 2: UI Architecture
```
Agent: ui-architect (sonnet)
Output:
- tmp/{session-id}/02-screens/screen-list.md
- tmp/{session-id}/02-screens/wireframes/*.md
```

### Phase 3: Component Discovery & Migration
```
Agents:
- component-auditor (haiku) → inventory.md, gap-analysis.md
- component-builder (sonnet) → new/*.md
- component-migrator (sonnet) → migrations/*.md

Output: tmp/{session-id}/03-components/
```

### Phase 4: Critical Review
```
Agents:
- critical-reviewer (opus) → scenarios/, ia-review.md, exceptions/
- ambiguity-detector (opus) → ambiguities.md

Output: tmp/{session-id}/04-review/
```

### Phase 5: Persona & Scenario Test Spec
```
Agents:
- persona-architect (sonnet) → personas/
- test-spec-writer (sonnet) → scenarios/, components/, coverage-map.md

Output: tmp/{session-id}/05-tests/
```

### Phase 6: Final Assembly
```
Agent: spec-assembler (haiku)
Output: tmp/{session-id}/06-final/
```

Ask user about tmp folder handling:
- **Archive**: `tmp/` → `archive/spec-it-YYYY-MM-DD/`
- **Delete**: Remove `tmp/` completely
- **Keep**: Keep `tmp/` as is

## Agents (15 total)

### Core Agents
| Agent | Model | Role |
|-------|-------|------|
| `design-interviewer` | opus | Brainstorming Q&A |
| `divergent-thinker` | sonnet | Divergent thinking, alternatives |
| `chapter-critic` | opus | Critical validation (3 rounds) |
| `chapter-planner` | opus | Chapter structure finalization |
| `ui-architect` | sonnet | Wireframe design |

### Component Agents
| Agent | Model | Role |
|-------|-------|------|
| `component-auditor` | haiku | Component scanning |
| `component-builder` | sonnet | Component specification |
| `component-migrator` | sonnet | Component migration |

### Review Agents
| Agent | Model | Role |
|-------|-------|------|
| `critical-reviewer` | opus | Scenario/IA/Exception review |
| `ambiguity-detector` | opus | Ambiguity detection |

### Test Agents
| Agent | Model | Role |
|-------|-------|------|
| `persona-architect` | sonnet | Persona definition |
| `test-spec-writer` | sonnet | Test specification |

### Utility Agents
| Agent | Model | Role |
|-------|-------|------|
| `spec-assembler` | haiku | Final assembly |
| `spec-md-generator` | haiku | SPEC-IT file creation |
| `spec-md-maintainer` | haiku | SPEC-IT file maintenance |

## Tech Stack

- **Framework**: Next.js (App Router)
- **UI Library**: React + shadcn/ui
- **Styling**: Tailwind CSS
- **Best Practices**: Vercel React Best Practices compliance

## Output Structure

```
tmp/{session-id}/
├── _meta.json
├── 00-requirements/
│   ├── _index.md              # 분리 시 생성
│   ├── 0-overview-requirement.md
│   ├── 1-auth-requirement.md
│   └── ...
├── 01-chapters/
│   ├── chapter-plan-final.md
│   ├── decisions/
│   │   ├── _index.md
│   │   ├── 0-scope-decision.md
│   │   ├── 1-persona-decision.md
│   │   └── ...
│   └── alternatives/
│       ├── _index.md
│       ├── 0-state-alternative.md
│       └── ...
├── 02-screens/
│   ├── _index.md
│   ├── 0-login-screen.md
│   ├── 1-dashboard-screen.md
│   └── wireframes/            # 와이어프레임은 분리 제외
│       ├── wireframe-login.md
│       └── ...
├── 03-components/
│   ├── inventory.md
│   ├── gap-analysis.md
│   ├── new/
│   │   ├── _index.md
│   │   ├── 0-datepicker-component.md
│   │   └── 1-stepper-component.md
│   └── migrations/
│       ├── _index.md
│       └── 0-datatable-migration.md
├── 04-review/
│   ├── scenarios/
│   │   ├── _index.md
│   │   └── 0-first-login-scenario.md
│   ├── ia-review.md
│   ├── exceptions/
│   │   ├── _index.md
│   │   └── 0-network-error-exception.md
│   └── ambiguities.md
├── 05-tests/
│   ├── personas/
│   │   ├── _index.md
│   │   ├── 0-newbie-persona.md
│   │   └── 1-expert-persona.md
│   ├── scenarios/
│   │   ├── _index.md
│   │   ├── 0-login-flow-test.md
│   │   └── 1-buy-stock-test.md
│   ├── components/
│   └── coverage-map.md
└── 06-final/
    ├── _index.md              # 분리 시 생성
    ├── 0-overview-spec.md
    ├── 1-components-spec.md
    └── dev-tasks.md
```

## SPEC-IT-{HASH}.md System

All UI-related files include accompanying `SPEC-IT-{HASH}.md` files for progressive context loading.

- **Progressive Context Loading**: Agents load only required context
- **Bidirectional Navigation**: Parent ↔ Child document links
- **Registry Management**: All HASHes managed in `.spec-it-registry.json`

## Resources

### Templates (16 files)
Located in [assets/templates/](assets/templates/):

| Template | Phase | Purpose |
|----------|-------|---------|
| CHAPTER_PLAN_TEMPLATE.md | 1 | Chapter structure |
| SCREEN_LIST_TEMPLATE.md | 2 | Screen list |
| UI_WIREFRAME_TEMPLATE.md | 2 | ASCII wireframe |
| SCREEN_SPEC_TEMPLATE.md | 2 | Screen spec |
| COMPONENT_INVENTORY_TEMPLATE.md | 3 | Component inventory |
| COMPONENT_SPEC_TEMPLATE.md | 3 | New component spec |
| MIGRATION_REPORT_TEMPLATE.md | 3 | Migration report |
| SCENARIO_TEMPLATE.md | 4 | Scenario review |
| IA_REVIEW_TEMPLATE.md | 4 | IA review |
| EXCEPTION_TEMPLATE.md | 4 | Exception review |
| AMBIGUITY_TEMPLATE.md | 4 | Ambiguity report |
| PERSONA_TEMPLATE.md | 5 | Persona definition |
| TEST_SPEC_TEMPLATE.md | 5 | Test specification |
| COVERAGE_MAP_TEMPLATE.md | 5 | Coverage map |
| SPEC_IT_COMPONENT_TEMPLATE.md | - | SPEC-IT for components |
| SPEC_IT_PAGE_TEMPLATE.md | - | SPEC-IT for pages |

### References (3 files)
Located in [references/](references/):

- [ascii-wireframe-guide.md](references/ascii-wireframe-guide.md) - ASCII wireframe patterns
- [shadcn-component-list.md](references/shadcn-component-list.md) - shadcn/ui components
- [test-patterns.md](references/test-patterns.md) - Test pattern guide

## Hooks

Cross-platform notification hooks for permission requests:

| Hook | Event | Description |
|------|-------|-------------|
| `notify-permission.sh` | PermissionRequest | Desktop notification when Claude needs approval |
| `notify-attention.sh` | Notification | Alert when user input is needed |

**Supported Platforms**: macOS (osascript), Windows (PowerShell), Linux (notify-send)

## Related Skills

- `vercel-react-best-practices` - React patterns
- `vercel-composition-patterns` - Component composition
- `web-design-guidelines` - Accessibility, UX
- `prompt-inspector` - API binding automation

## Execution Instructions

### Step 0: 초기화 및 Resume 확인

```
IF 인자에 "--resume" 또는 "이어서" 또는 "재개" 포함:
  → Resume 모드 (Step 0.R)
ELSE:
  → 새 세션 (Step 0.1)
```

#### Step 0.R: Resume 모드

```bash
# 1. _meta.json 로드
Read(tmp/{sessionId}/_meta.json)

# 2. 현재 챕터 확인
currentChapter = _meta.currentChapter

# 3. 해당 챕터부터 재개
```

#### Step 0.1: 새 세션

```bash
sessionId = $(date +%Y%m%d-%H%M%S)
mkdir -p tmp/{sessionId}/{00-requirements,01-chapters/decisions,02-screens/wireframes,03-components/{new,migrations},04-review/{scenarios,exceptions},05-tests/{personas,scenarios,components},06-final}
```

### Step 1: 각 챕터별 반복 (CH-00 ~ CH-07)

```
FOR chapter in [CH-00, CH-01, CH-02, ..., CH-07]:

  # 1. 에이전트에게 챕터 작성 위임
  Task(
    subagent_type: "general-purpose",
    model: "opus",
    prompt: "
      역할: design-interviewer
      챕터: {chapter}

      작업:
      1. 사용자에게 질문 (1개씩)
      2. 응답 수집
      3. 챕터 결정문서 작성

      출력: tmp/{sessionId}/01-chapters/decisions/decision-{chapter}.md

      OUTPUT RULES: (요약만 반환)
    "
  )

  # 2. 결과 요약 표시
  Output: "
    ## Chapter {chapter} 요약
    - 결정 사항: ...
    - 다음 챕터: ...
  "

  # 3. 사용자 승인
  AskUserQuestion(
    questions: [{
      question: "이 챕터 내용이 맞습니까?",
      header: "승인",
      options: [
        {label: "Yes", description: "다음 챕터 진행"},
        {label: "No", description: "수정 필요"},
        {label: "Questions", description: "질문 있음"}
      ]
    }]
  )

  # 4. _meta.json 업데이트
  _meta.currentChapter = next_chapter
  _meta.completedChapters += chapter
  Update(_meta.json)

  # 5. IF No or Questions → 수정 후 재승인
```

### Step 2-6: Phase 진행

각 Phase는 `spec-it-automation`과 동일하되, **매 단계마다 사용자 승인** 요청

### Question Style

```markdown
**Q: 이 서비스의 주요 사용자는 누구입니까?**

A) 20-30대 직장인 - 빠른 업무 처리 중시
B) 40-50대 중장년층 - 안정성과 신뢰 중시
C) 10대 청소년 - 재미와 소셜 기능 중시
D) 기타 (직접 입력)
```

### Chapter Approval Format

```markdown
## Chapter {chapter} 요약

### 확정 사항
- 항목 1
- 항목 2

### 다음 챕터 미리보기
{다음 내용}

이 내용이 맞습니까? [Yes] [No] [Questions]
```

---

## Error Recovery

### Context Limit 도달 시

```
현재 상태 저장됨.
재개: /frontend-skills:spec-it --resume {sessionId}
```

### Resume 지원

모든 진행 상태는 `_meta.json`에 저장되어 언제든 재개 가능
