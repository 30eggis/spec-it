---
name: spec-it-complex
description: "Frontend specification generator (Hybrid mode). Auto validation + major milestone approvals. Use for medium-sized projects requiring balance between automation and control."
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
---

# spec-it-complex: Frontend Specification Generator (Hybrid Mode)

Transform vibe-coding/PRD into production-ready frontend specifications with **automatic validation** and **major milestone approvals**.

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

- **Auto-validation**: Divergent thinking + 3-round critical review
- **User approval**: 4개 주요 마일스톤에서만
- **User questions**: 보통 (4-5회)

---

## Workflow Overview

```
[Requirements] → [Divergent Thinking] → [3-Round Critique] → [Chapter Plan]
      ↓
★ MILESTONE 1: "N개 챕터 진행?" [Yes/Modify]
      ↓
[CH-00~02: Auto] → ★ MILESTONE 2: "기본 구조 확인"
      ↓
[CH-03~04: Auto] → ★ MILESTONE 3: "기능 정의 확인"
      ↓
[CH-05~07: Auto] → [Critical Review] → [Test Spec] → [Final Assembly]
      ↓
★ MILESTONE 4: Final approval
```

---

## Execution Instructions

### Step 0: 초기화 및 Resume 확인

```
IF 인자에 "--resume" 포함:
  Read(tmp/{sessionId}/_meta.json)
  GOTO _meta.currentStep
ELSE:
  sessionId = $(date +%Y%m%d-%H%M%S)
  mkdir -p tmp/{sessionId}/{00-requirements,01-chapters/{decisions,alternatives},02-screens/{wireframes,layouts},03-components/{new,migrations},04-review/{scenarios,exceptions},05-tests/{personas,scenarios,components},06-final}

  # 대시보드 별도 창에서 자동 실행
  Bash(~/.claude/plugins/frontend-skills/scripts/open-dashboard.sh ./tmp/{sessionId})
```

### Step 0.0: UI 구현 방식 선택

```
AskUserQuestion(
  questions: [{
    question: "UI 디자인 방식을 선택해 주세요.",
    header: "UI Mode",
    options: [
      {label: "ASCII Wireframe (Recommended)", description: "텍스트 기반 와이어프레임 (빠름, 오프라인 가능)"},
      {label: "Google Stitch", description: "AI 기반 실제 UI 생성 (자동 설정)"}
    ]
  }]
)

IF "Google Stitch" 선택:
  uiMode = "stitch"

  # stitch-controller 에이전트 호출 (설치 및 인증만)
  Task(
    subagent_type: "general-purpose",
    model: "sonnet",
    prompt: "
      역할: stitch-controller
      sessionId: {sessionId}

      Phase 1만 실행 (설치 및 인증):
      1. Node.js/npm 확인
      2. @_davideast/stitch-mcp 설치
      3. OAuth 인증 확인/실행

      모든 단계는 사용자 승인 없이 자동 진행합니다.
      OAuth 브라우저 인증만 사용자 액션이 필요합니다.

      OUTPUT: '완료. Stitch 준비됨.' 또는 '실패. 원인: {error}'
    "
  )

  IF 실패:
    Output: "Stitch 설정 실패. ASCII 모드로 전환합니다."
    uiMode = "ascii"

ELSE:
  uiMode = "ascii"

# _meta.json에 uiMode 저장
Write(tmp/{sessionId}/_meta.json, {..., "uiMode": uiMode})
```

### Step 1: Requirements Analysis

```
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "
    역할: design-interviewer

    입력: {PRD 또는 사용자 요구사항}

    작업:
    1. 요구사항 분석
    2. requirements.md 작성

    출력: tmp/{sessionId}/00-requirements/requirements.md

    OUTPUT RULES: (요약만 반환)
  "
)

_meta.currentStep = "1.2"
Update(_meta.json)
```

### Step 1.2: Divergent Thinking + Critique

```
# Divergent Thinker
Task(
  subagent_type: "general-purpose",
  model: "sonnet",
  prompt: "
    역할: divergent-thinker

    작업: 대안 분석 (주제별 분리, 200줄 이하씩)

    출력:
    - tmp/{sessionId}/01-chapters/alternatives/state-management.md
    - tmp/{sessionId}/01-chapters/alternatives/data-fetching.md
    - tmp/{sessionId}/01-chapters/alternatives/realtime.md
    - tmp/{sessionId}/01-chapters/alternatives/_index.md

    OUTPUT RULES: (요약만 반환)
  "
)

# 3-Round Critique (순차 실행)
FOR round in [1, 2, 3]:
  Task(
    subagent_type: "general-purpose",
    model: "opus",
    prompt: "
      역할: chapter-critic (Round {round}/3)
      출력: tmp/{sessionId}/01-chapters/critique-round{round}.md
      OUTPUT RULES: (요약만 반환)
    "
  )

# Chapter Planner
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "
    역할: chapter-planner
    출력: tmp/{sessionId}/01-chapters/chapter-plan-final.md
    OUTPUT RULES: (요약만 반환)
  "
)

_meta.currentStep = "2.1"
Update(_meta.json)
```

### Step 2.1: ★ MILESTONE 1 - Chapter Plan Approval

```
Read(tmp/{sessionId}/01-chapters/chapter-plan-final.md)

AskUserQuestion(
  questions: [{
    question: "총 N개 챕터가 계획되었습니다. 진행하시겠습니까?",
    header: "Milestone 1",
    options: [
      {label: "Yes", description: "계획대로 진행"},
      {label: "Modify", description: "수정 필요"}
    ]
  }]
)

IF Modify:
  # 사용자 피드백 반영 후 재계획
  ...

_meta.currentStep = "2.2"
Update(_meta.json)
```

### Step 2.2: Batch 1 - Basic Structure (CH-00~02)

```
# 2개씩 배치 실행
Task(
  subagent_type: "general-purpose",
  model: "sonnet",
  run_in_background: true,
  prompt: "CH-00, CH-01 작성... OUTPUT RULES: (요약만 반환)"
)

# ⚠️ _meta.json에서 uiMode 확인
Read(tmp/{sessionId}/_meta.json)
uiMode = _meta.uiMode  # "stitch" 또는 "ascii"

IF uiMode == "stitch":
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # Google Stitch 모드 (ASCII → Hi-Fi 변환)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Task(
    subagent_type: "general-purpose",
    model: "sonnet",
    run_in_background: true,
    prompt: "
      역할: stitch-controller
      sessionId: {sessionId}

      전체 워크플로우:
      1. [ASCII] ui-architect로 와이어프레임 생성
      2. [Stitch] 프로젝트 생성 (spec-it-{sessionId})
      3. [Stitch] 각 ASCII를 순차적으로 Hi-Fi 변환
      4. [Stitch] 디자인 QA 실행
      5. [Stitch] HTML/CSS 내보내기

      ⚠️ 모든 단계는 사용자 승인 없이 자동 진행합니다.

      출력 경로:
      - tmp/{sessionId}/02-screens/screen-list.md
      - tmp/{sessionId}/02-screens/wireframes/*.md      # ASCII 원본
      - tmp/{sessionId}/02-screens/stitch-project.json
      - tmp/{sessionId}/02-screens/html/*.html          # Hi-Fi 결과
      - tmp/{sessionId}/02-screens/assets/styles.css
      - tmp/{sessionId}/02-screens/qa-report.md

      OUTPUT: '완료. ASCII {N}개 → Hi-Fi {N}개 변환됨.'
    "
  )
ELSE:
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  # ASCII Wireframe 모드 (Layout 기반 병렬 생성)
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  # Step A: Layout 시스템 생성 (순차)
  Task(
    subagent_type: "general-purpose",
    model: "sonnet",
    prompt: "
      역할: ui-architect (Layout 설계)
      입력: chapter-plan-final.md

      작업:
      1. 화면 목록 작성 (screen-list.md) - 각 화면의 Layout 타입 지정
      2. Layout 시스템 정의 (layout-system.md)
         - Layout 타입별 구조 (Header, Sidebar, Footer 포함)
         - {{MAIN_CONTENT}} 플레이스홀더

      출력: layouts/layout-system.md, screen-list.md
      OUTPUT RULES: (요약만 반환)
    "
  )
  # → Layout 완료 대기

  # Step B: 페이지 와이어프레임 병렬 생성
  screens = extract_screens(screen-list.md)
  FOR batch IN chunk(screens, 4):
    FOR screen IN batch:
      Task(
        subagent_type: "general-purpose",
        model: "sonnet",
        run_in_background: true,
        prompt: "
          역할: ui-architect (페이지)
          Layout 참조하여 {screen} 전체 화면 와이어프레임 생성
          ⚠️ Header, Sidebar 등 Layout 전체 포함 필수
          OUTPUT RULES: (요약만 반환)
        "
      )
    Wait for batch

Wait for CH-00, CH-01 task

_meta.currentStep = "2.3"
Update(_meta.json)
```

### Step 2.3: ★ MILESTONE 2 - Basic Structure Approval

```
AskUserQuestion(
  questions: [{
    question: "기본 구조 (CH-00~02)가 완료되었습니다. 확인하시겠습니까?",
    header: "Milestone 2",
    options: [
      {label: "Yes", description: "다음 단계 진행"},
      {label: "Review", description: "상세 검토 필요"}
    ]
  }]
)

_meta.currentStep = "3.1"
Update(_meta.json)
```

### Step 3.1: Batch 2 - Features (CH-03~04)

```
# 병렬 실행 (최대 2개)
Task(...) # CH-03
Task(...) # CH-04

Wait for both tasks

_meta.currentStep = "3.2"
Update(_meta.json)
```

### Step 3.2: ★ MILESTONE 3 - Feature Approval

```
AskUserQuestion(
  questions: [{
    question: "기능 정의 (CH-03~04)가 완료되었습니다. 확인하시겠습니까?",
    header: "Milestone 3",
    options: [...]
  }]
)

_meta.currentStep = "4.1"
Update(_meta.json)
```

### Step 4.1: Batch 3 - Remaining + Review

```
# CH-05~07 생성
Task(...) # CH-05, CH-06
Task(...) # CH-07

Wait for both

# Critical Review (병렬, 최대 2개)
Task(...) # critical-reviewer
Task(...) # ambiguity-detector

Wait for both

# 모호성 처리
IF ambiguities.md에 "Must Resolve" 있으면:
  AskUserQuestion(...)

_meta.currentStep = "5.1"
Update(_meta.json)
```

### Step 5.1: Test Specification

```
Task(...) # persona-architect
Task(...) # test-spec-writer

Wait for both

_meta.currentStep = "6.1"
Update(_meta.json)
```

### Step 6.1: Final Assembly

```
Task(
  subagent_type: "general-purpose",
  model: "haiku",
  prompt: "
    역할: spec-assembler
    출력:
    - tmp/{sessionId}/06-final/final-spec.md
    - tmp/{sessionId}/06-final/dev-tasks.md
    - tmp/{sessionId}/06-final/SPEC-SUMMARY.md
    OUTPUT RULES: (요약만 반환)
  "
)

_meta.currentStep = "6.2"
Update(_meta.json)
```

### Step 6.2: ★ MILESTONE 4 - Final Approval

```
AskUserQuestion(
  questions: [{
    question: "명세서가 완료되었습니다. 작업 파일 처리 방법을 선택하세요:",
    header: "Final",
    options: [
      {label: "Archive", description: "archive/ 폴더로 이동"},
      {label: "Keep", description: "tmp/ 폴더에 유지"},
      {label: "Delete", description: "삭제"}
    ]
  }]
)

_meta.status = "completed"
Update(_meta.json)

Output: "
===== SPEC-IT-COMPLEX 완료 =====
세션 ID: {sessionId}
...
"
```

---

## Output Structure

```
tmp/{session-id}/
├── _meta.json                 # Resume 지원
├── 00-requirements/
│   ├── _index.md              # 분리 시 생성
│   ├── 0-overview-requirement.md
│   ├── 1-auth-requirement.md
│   └── ...
├── 01-chapters/
│   ├── alternatives/
│   │   ├── _index.md
│   │   ├── 0-state-alternative.md
│   │   └── ...
│   ├── critique-round1.md
│   ├── critique-round2.md
│   ├── critique-round3.md
│   ├── chapter-plan-final.md
│   └── decisions/
│       ├── _index.md
│       ├── 0-scope-decision.md
│       └── ...
├── 02-screens/
│   ├── _index.md
│   ├── 0-login-screen.md
│   └── wireframes/            # 와이어프레임은 분리 제외
├── 03-components/
│   ├── new/
│   │   ├── _index.md
│   │   ├── 0-datepicker-component.md
│   │   └── ...
│   └── migrations/
│       ├── _index.md
│       └── 0-datatable-migration.md
├── 04-review/
│   ├── scenarios/
│   │   ├── _index.md
│   │   └── 0-first-login-scenario.md
│   └── exceptions/
│       ├── _index.md
│       └── 0-network-error-exception.md
├── 05-tests/
│   ├── personas/
│   │   ├── _index.md
│   │   └── 0-newbie-persona.md
│   └── scenarios/
│       ├── _index.md
│       └── 0-login-flow-test.md
└── 06-final/
    ├── _index.md              # 분리 시 생성
    ├── 0-overview-spec.md
    └── dev-tasks.md
```

---

## Error Recovery

### Context Limit 도달 시

```
현재 상태 저장됨: _meta.json
재개: /frontend-skills:spec-it-complex --resume {sessionId}
```

---

## Related Skills

- `/frontend-skills:spec-it` - Manual mode (모든 챕터 승인)
- `/frontend-skills:spec-it-automation` - Full auto mode (최소 승인)
- `/frontend-skills:init-spec-md` - 기존 코드용 SPEC-IT 생성
