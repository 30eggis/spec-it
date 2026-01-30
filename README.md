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

| 이렇게 말하면... | Mode | 승인 시점 | 추천 상황 |
|-----------------|------|----------|----------|
| "단계별로 논의하면서" | Manual | 매 챕터 | 소규모, 학습용 |
| "큰 틀만 확인하면서" | Hybrid | 4개 마일스톤 | 중규모 프로젝트 |
| "자동으로 만들어줘" | Full Auto | 최종만 | 대규모 프로젝트 |

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

| 이렇게 말하면... | 로딩되는 skill | 특징 |
|-----------------|---------------|------|
| "단계별로 논의하면서 스펙 만들자" | spec-it | 매 챕터 승인 |
| "하나씩 확인하면서 진행해줘" | spec-it | 꼼꼼한 검토 |
| "큰 틀만 확인하면서 스펙 만들어줘" | spec-it-complex | 마일스톤 승인 |
| "주요 포인트만 논의하자" | spec-it-complex | 중간 검토 |
| "자동으로 스펙 만들어줘" | spec-it-automation | 최종만 승인 |
| "알아서 다 만들어줘" | spec-it-automation | 완전 자동 |

```
💬 "단계별로 같이 논의하면서 스펙 만들자"
   → spec-it (Manual) 로딩
   → 매 챕터마다 "이 내용 맞아?" 확인

💬 "큰 흐름만 확인할게, 나머지는 알아서 해줘"
   → spec-it-complex (Hybrid) 로딩
   → Phase 완료 시점에만 확인

💬 "자동으로 스펙 만들어줘, 끝나면 알려줘"
   → spec-it-automation (Full Auto) 로딩
   → 최종 결과물만 확인
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

| 이렇게 말하면... | 대상 | 동작 |
|-----------------|------|------|
| "src/app 분석해서 PRD 만들어줘" | 코드 경로 | 로컬 코드 분석 |
| "http://localhost:3000 PRD로 만들어줘" | 개발 서버 | 실행 중인 앱 분석 |
| "https://google.com PRD로 만들어줘" | 외부 URL | 웹사이트 분석 |
| "이 스크린샷으로 PRD 만들어줘" | 이미지 | 모바일 앱 분석 |

```
💬 "./src/app 폴더 분석해서 PRD 만들어줘"
   → 코드베이스 스캔
   → 구조/기능 분석
   → PRD 생성

💬 "http://localhost:8080/ 이거 PRD로 만들어줘"
   → 개발 서버 접속
   → UI/기능 분석
   → PRD 생성

💬 "https://notion.so 분석해서 기획서 만들어줘"
   → 웹사이트 크롤링
   → 기능 역분석
   → PRD 생성
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

## Agents (27 Total)

### Design & Planning Agents

| Agent | Model | 역할 |
|-------|-------|------|
| `design-interviewer` | Opus | 브레인스토밍 Q&A 진행자 |
| `divergent-thinker` | Sonnet | 대안 탐색, 창의적 사고 |
| `chapter-planner` | Opus | 챕터 구조 최종 확정 |
| `ui-architect` | Sonnet | ASCII 와이어프레임 설계 |

### Multi-Agent Debate (Critic System)

병렬로 3명의 critic이 검토 후 moderator가 합의 도출:

```
┌─────────────┬─────────────┬─────────────┐
│critic-logic │critic-feasi.│critic-frontend│  ← 병렬 실행
└──────┬──────┴──────┬──────┴──────┬──────┘
       └─────────────┼─────────────┘
                     ▼
             critic-moderator              ← 합의 도출
```

| Agent | Model | 검증 영역 |
|-------|-------|----------|
| `critic-logic` | Sonnet | 논리 일관성, 중복/누락, 의존 순서 |
| `critic-feasibility` | Sonnet | 실현 가능성, 완료 기준, 테스트 가능성 |
| `critic-frontend` | Sonnet | UI/UX, 컴포넌트 재사용, 반응형/접근성 |
| `critic-moderator` | Opus | 3명 합의 도출, 충돌 해결, 최종 Verdict |

> `chapter-critic`은 레거시 (단일 에이전트 3라운드 방식)

### Component Agents

| Agent | Model | 역할 |
|-------|-------|------|
| `component-auditor` | Haiku | 기존 컴포넌트 스캔, 인벤토리 생성 |
| `component-builder` | Sonnet | 신규 컴포넌트 스펙 작성 |
| `component-migrator` | Sonnet | 컴포넌트 마이그레이션 계획 |

### Review Agents

| Agent | Model | 역할 |
|-------|-------|------|
| `critical-reviewer` | Opus | 시나리오/IA/예외 상황 리뷰 |
| `ambiguity-detector` | Opus | 모호성 탐지, 질문 생성 |
| `spec-critic` | Opus | 실행 계획 검증 (4 pillar) |

### Test Agents

| Agent | Model | 역할 |
|-------|-------|------|
| `persona-architect` | Sonnet | 사용자 페르소나 정의 |
| `test-spec-writer` | Sonnet | TDD 테스트 스펙 작성, 80%+ 커버리지 |

### Execution Agents

| Agent | Model | 역할 |
|-------|-------|------|
| `spec-executor` | Opus | 다중 파일 구현, HTML 레퍼런스 지원 |
| `code-reviewer` | Opus | 2단계 코드 리뷰 (스펙 준수 → 품질) |
| `security-reviewer` | Opus | OWASP Top 10 보안 감사 |
| `screen-vision` | Sonnet | 스크린샷/목업 분석 |

### Stitch Agents (Google Stitch MCP)

| Agent | Model | 역할 |
|-------|-------|------|
| `stitch-controller` | Sonnet | Stitch 전체 워크플로우 자동 제어 |
| `stitch-installer` | Haiku | 의존성 설치, OAuth, 프로젝트 생성 |
| `stitch-ui-designer` | Sonnet | 텍스트 → Hi-Fi UI 생성 |

### Utility Agents

| Agent | Model | 역할 |
|-------|-------|------|
| `spec-assembler` | Haiku | 최종 문서 조립 |
| `spec-md-generator` | Haiku | SPEC-IT 파일 생성 |
| `spec-md-maintainer` | Haiku | SPEC-IT 파일 유지보수 |

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
