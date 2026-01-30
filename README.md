# Claude Frontend Skills

A collection of specialized skills and agents for frontend development, specification generation, and code quality assurance.

## Installation

```bash
# Via marketplace
/plugin marketplace add 30eggis/claude-frontend-skills

# Direct install
/plugin install frontend-skills@30eggis/claude-frontend-skills
```

---

## Skills Overview

| Skill | Description | Mode |
|-------|-------------|------|
| `spec-it` | Frontend specification generator | Manual |
| `spec-it-complex` | Frontend specification generator | Hybrid |
| `spec-it-automation` | Frontend specification generator | Full Auto |
| `spec-it-execute` | Autopilot implementation executor | Auto |
| `init-spec-md` | SPEC-IT file generator for existing code | Auto |
| `prompt-inspector` | Visual API binding tool | Interactive |
| `hack-2-prd` | Code to PRD/SPEC/PHASE/TASKS generator | Auto |
| `prd-mirror` | PRD vs implementation comparison | Auto |

---

## spec-it Suite (Specification Generator)

Transform vibe-coding/PRD into **production-ready frontend specifications** with multi-agent collaboration.

### Three Generation Modes

| Command | Mode | User Approval | Best For |
|---------|------|---------------|----------|
| `/frontend-skills:spec-it` | Manual | Every chapter | Small projects, learning |
| `/frontend-skills:spec-it-complex` | Hybrid | 4 milestones | Medium projects |
| `/frontend-skills:spec-it-automation` | Full Auto | Final only | Large projects |

### Workflow Phases

```
Phase 0: Input Analysis     → requirements.md
Phase 1: Design Brainstorm  → decisions/*.md (Q&A refinement)
Phase 2: UI Architecture    → wireframes/*.md (ASCII art)
Phase 3: Component Discover → inventory.md, gap-analysis.md
Phase 4: Critical Review    → scenarios/, ambiguities.md
Phase 5: Test Specification → personas/, coverage-map.md
Phase 6: Final Assembly     → final-spec.md, dev-tasks.md
```

### Key Features (v2)

- **Resume Support**: `--resume <sessionId>` to continue interrupted sessions
- **Real-time Dashboard**: Monitor progress in separate terminal
- **Context Management**: Automatic file splitting and agent batching
- **Checkpoint System**: `_meta.json` state tracking for recovery

### Usage Examples

자연어로 말하면 자동으로 skill이 로딩됩니다.

| 이렇게 말하면... | 로딩되는 skill |
|-----------------|---------------|
| "프론트엔드 스펙 작성해줘" | spec-it-automation |
| "이 PRD로 명세서 만들어줘" | spec-it-automation |
| "spec-it으로 명세서 만들어줘" | spec-it |
| "이어서 진행해줘" / "--resume" | 마지막 세션 재개 |

```
💬 "대시보드 앱의 프론트엔드 스펙을 작성해줘"
   → spec-it-automation 자동 로딩
   → 요구사항 분석 시작

💬 "아까 하던 스펙 작업 이어서 해줘"
   → 마지막 세션 자동 감지
   → 중단된 Phase부터 재개
```

---

## spec-it-execute (Implementation Executor)

Transform spec-it output into **working code** with autonomous execution.

| 이렇게 말하면... | 동작 |
|-----------------|------|
| "스펙대로 구현해줘" | spec-it-execute 로딩 |
| "명세서 기반으로 코드 작성해줘" | spec-it-execute 로딩 |
| "spec-it-execute 실행해줘" | 직접 실행 |

```
💬 "방금 만든 스펙대로 구현해줘"
   → spec-it-execute 자동 로딩
   → 최근 spec 폴더 감지
   → 자동 구현 시작
```

### Execution Phases

```
Phase 1: LOAD     → Validate specs, extract tasks
Phase 2: PLAN     → Generate execution plan + critique
Phase 3: EXECUTE  → Implement with spec-executor agent
Phase 4: QA       → Build/lint/test loop (max 5 cycles)
Phase 5: VALIDATE → Code review + security audit
```

### Smart Model Routing

| Complexity | Model | Use Case |
|------------|-------|----------|
| LOW | Haiku | Simple reads, status checks |
| MEDIUM | Sonnet | Standard implementation |
| HIGH | Opus | Complex multi-file changes |

---

## init-spec-md

Generate `SPEC-IT-{HASH}.md` metadata files for existing UI code to enable **progressive context loading**.

| 이렇게 말하면... | 동작 |
|-----------------|------|
| "기존 컴포넌트들 문서화해줘" | 전체 프로젝트 스캔 |
| "이 프로젝트에 SPEC-IT 적용해줘" | init-spec-md 실행 |
| "init-spec-md 실행해줘" | 직접 실행 |

```
💬 "기존 코드에 SPEC-IT 메타데이터 추가해줘"
   → init-spec-md 자동 로딩
   → 컴포넌트/페이지 스캔
   → SPEC-IT-{HASH}.md 생성
```

### Purpose

- **Progressive Context Loading**: Agents load only required context
- **Bidirectional Navigation**: Parent ↔ Child document links
- **Registry Management**: `.spec-it-registry.json` tracks all HASHes

---

## prompt-inspector

Visual API binding tool for connecting UI elements to REST APIs in React/Next.js projects.

| 이렇게 말하면... | 동작 |
|-----------------|------|
| "UI에서 API 연결하고 싶어" | prompt-inspector 로딩 |
| "버튼에 API 바인딩해줘" | prompt-inspector 로딩 |
| "prompt-inspector 적용해줘" | 직접 실행 |

```
💬 "이 버튼 클릭하면 API 호출되게 해줘"
   → prompt-inspector 자동 로딩
   → UI 요소 선택 모드
   → API 엔드포인트 연결
```

### Features

- **Visual Element Selection** - Click any UI element
- **API Discovery** - Auto-detect axios, fetch, Express, Next.js routes
- **Binding Configuration** - Set trigger, success/error handlers
- **Export to Markdown** - Generate specs for implementation

---

## hack-2-prd

Analyze services/projects and systematically generate documentation.

| 이렇게 말하면... | 동작 |
|-----------------|------|
| "이 코드 분석해서 PRD 만들어줘" | hack-2-prd 로딩 |
| "프로젝트 문서화해줘" | hack-2-prd 로딩 |
| "hack-2-prd 실행해줘" | 직접 실행 |

```
💬 "이 서비스 분석해서 기획서 만들어줘"
   → hack-2-prd 자동 로딩
   → 코드베이스 분석
   → PRD/SPEC/TASKS 생성
```

### Output Structure

```
docs/
├── PRD.md
├── specs/
│   ├── SPEC-01.md
│   └── ...
├── phases/
│   └── PHASE-01.md
└── tasks/
    └── TASKS-PHASE-01.md
```

### Supported Sources

| Source | Description |
|--------|-------------|
| Website URL | Analyze via Chrome Extension data |
| Codebase | Analyze local project structure |
| Mobile App | Analyze from screenshots |

---

## prd-mirror

Compare original PRD against actual implementation to verify spec compliance.

| 이렇게 말하면... | 동작 |
|-----------------|------|
| "PRD랑 구현 비교해줘" | prd-mirror 로딩 |
| "스펙대로 구현됐는지 확인해줘" | prd-mirror 로딩 |
| "prd-mirror 실행해줘" | 직접 실행 |

```
💬 "기획서랑 실제 코드 비교해서 빠진거 찾아줘"
   → prd-mirror 자동 로딩
   → PRD vs 코드 분석
   → 누락/초과/일치 항목 리포트
```

### Workflow

```
[Original PRD] + [Codebase]
       ↓
[Reverse-engineer PRD via hack-2-prd]
       ↓
[Compare REQ items]
       ↓
[Report: Over-spec / Missing / Matched]
```

---

## Agents (20 Total)

### Specification Agents

| Agent | Model | Role |
|-------|-------|------|
| `design-interviewer` | Opus | Brainstorming Q&A facilitator |
| `divergent-thinker` | Sonnet | Alternatives and creative thinking |
| `chapter-critic` | Opus | Critical validation (3 rounds) |
| `chapter-planner` | Opus | Chapter structure finalization |
| `ui-architect` | Sonnet | Wireframe and layout design |

### Component Agents

| Agent | Model | Role |
|-------|-------|------|
| `component-auditor` | Haiku | Component scanning and inventory |
| `component-builder` | Sonnet | Component specification writer |
| `component-migrator` | Sonnet | Migration strategy planner |

### Review Agents

| Agent | Model | Role |
|-------|-------|------|
| `critical-reviewer` | Opus | Scenario/IA/Exception review |
| `ambiguity-detector` | Opus | Ambiguity and gap detection |
| `spec-critic` | Opus | Plan validation (4-pillar review) |

### Test Agents

| Agent | Model | Role |
|-------|-------|------|
| `persona-architect` | Sonnet | User persona definition |
| `test-spec-writer` | Sonnet | Test specification author |

### Execution Agents

| Agent | Model | Role |
|-------|-------|------|
| `spec-executor` | Opus | Multi-file implementation |
| `code-reviewer` | Opus | Two-stage code review |
| `security-reviewer` | Opus | OWASP Top 10 audit |
| `screen-vision` | Sonnet | Visual/mockup analysis |

### Utility Agents

| Agent | Model | Role |
|-------|-------|------|
| `spec-assembler` | Haiku | Final document assembly |
| `spec-md-generator` | Haiku | SPEC-IT file creation |
| `spec-md-maintainer` | Haiku | SPEC-IT file maintenance |

---

## Real-time Dashboard

Monitor spec-it progress in a separate terminal.

### Installation

```bash
# Run install script
bash ~/.claude/plugins/frontend-skills/skills/shared/dashboard/install.sh

# Or create alias manually
alias spec-it-dashboard='~/.claude/plugins/frontend-skills/skills/shared/dashboard/spec-it-dashboard.sh'
```

### Usage

```bash
# Auto-detect active session
spec-it-dashboard

# Specific session
spec-it-dashboard ./tmp/20260130-123456

# Simple watch mode
watch -n 2 ~/.claude/plugins/frontend-skills/skills/shared/dashboard/spec-it-status.sh
```

### Dashboard Display

```
╔══════════════════════════════════════════════════════════════════╗
║  SPEC-IT DASHBOARD                    Runtime: 00:05:32  ║
╠══════════════════════════════════════════════════════════════════╣
║  Session: 20260130-123456
║
║  Phase: 2/6 - UI Architecture
║  Step:  2.1
║  [████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░]  33%
║
╠══════════════════════════════════════════════════════════════════╣
║  AGENTS
║
║  ● ui-architect              [running  ]  00:02:15
║  ✓ component-auditor         [completed]  00:01:30
║  ○ component-builder         [pending  ]
║
╠══════════════════════════════════════════════════════════════════╣
║  STATS
║
║  Files: 12 created
║  Lines: 1847 written
╚══════════════════════════════════════════════════════════════════╝
```

---

## Context Management Rules

All spec-it skills follow these rules to prevent context overflow:

| Rule | Limit |
|------|-------|
| Direct Write | Max 100 lines (delegate larger to agents) |
| File Size | Max 200 lines (auto-split if larger) |
| Concurrent Agents | Max 2 (batch execution) |
| Agent Output | Summary only (path + line count) |

See `skills/shared/context-rules.md` for full documentation.

---

## Tech Stack

- **Framework**: Next.js (App Router)
- **UI Library**: React + shadcn/ui
- **Styling**: Tailwind CSS
- **Best Practices**: Vercel React Best Practices compliance

## License

MIT
