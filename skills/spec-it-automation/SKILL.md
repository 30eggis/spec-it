---
name: spec-it-automation
description: "Frontend specification generator (Full Auto mode). Multi-agent parallel validation with single final approval. Use for large projects requiring fast, comprehensive specification generation."
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
---

# spec-it-automation: Frontend Specification Generator (Full Auto Mode)

Transform vibe-coding/PRD into production-ready frontend specifications with **maximum automation** and **minimal user intervention**.

---

## CRITICAL: Context Management Rules

**반드시 [shared/context-rules.md](../shared/context-rules.md) 규칙을 준수하세요.**

### 핵심 규칙 요약

| 규칙 | 제한 | 위반 시 |
|------|------|---------|
| 직접 Write | 100줄 이하만 | 에이전트에게 위임 |
| 파일 크기 | 600줄 이하 | 분리 필수 (wireframe 제외) |
| 동시 에이전트 | 최대 2개 | 배치로 나눠 실행 |
| 에이전트 반환 | 요약만 (경로+줄수) | 내용 포함 금지 |
| 분리 네이밍 | {index}-{name}-{type}.md | 통일 규칙 |

### 에이전트 프롬프트 필수 문구

모든 Task 호출 시 프롬프트에 반드시 포함:

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

## Real-time Dashboard

별도 터미널에서 실시간 진행 상황 모니터링:

```bash
# 대시보드 실행
~/.claude/plugins/frontend-skills/skills/shared/dashboard/spec-it-dashboard.sh

# 또는 특정 세션
~/.claude/plugins/frontend-skills/skills/shared/dashboard/spec-it-dashboard.sh ./tmp/20260130-123456
```

**참조**: [dashboard/status-tracking.md](../shared/dashboard/status-tracking.md)

---

## Mode Characteristics

- **Parallel processing**: 최대 2개씩 배치 실행
- **Multi-agent validation**: 자동 품질 게이트
- **User approval**: 모호성 발견 시 + 최종 승인만
- **User questions**: 최소 (1-2회)
- **Real-time tracking**: _status.json으로 진행 상황 추적

---

## Execution Instructions

### Step 0: 초기화 및 Resume 확인

```
IF 인자에 "--resume" 또는 "이어서" 또는 "재개" 포함:
  → Resume 모드로 전환 (Step 0.R 실행)
ELSE:
  → 새 세션 시작 (Step 0.1 실행)
```

#### Step 0.R: Resume 모드

```bash
# 1. 세션 ID 확인
sessionId = 인자에서 추출 또는 가장 최근 tmp/*/ 폴더

# 2. _meta.json 로드
Read(tmp/{sessionId}/_meta.json)

# 3. 상태 확인
currentPhase = _meta.currentPhase
currentStep = _meta.currentStep

# 4. 필수 파일만 로드 (컨텍스트 절약)
IF currentPhase >= 2:
  Read(tmp/{sessionId}/01-chapters/chapter-plan-final.md)
  # 다른 파일은 로드하지 않음

# 5. 해당 Step부터 재개
GOTO Step {currentStep}
```

#### Step 0.1: 새 세션 초기화

```bash
# 1. 세션 ID 생성
sessionId = $(date +%Y%m%d-%H%M%S)
startTime = $(date -Iseconds)

# 2. 폴더 구조 생성
mkdir -p tmp/{sessionId}/{00-requirements,01-chapters/decisions,02-screens/wireframes,03-components/{new,migrations},04-review/{scenarios,exceptions},05-tests/{personas,scenarios,components},06-final}

# 3. _meta.json 초기화 (체크포인트용)
Write(tmp/{sessionId}/_meta.json)

# 4. _status.json 초기화 (대시보드용)
Write(tmp/{sessionId}/_status.json)

# 5. 인라인 진행률 출력
Output: "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Session: {sessionId} 시작
대시보드: spec-it-dashboard.sh ./tmp/{sessionId}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
```

**_meta.json** (체크포인트/Resume용):
```json
{
  "sessionId": "{sessionId}",
  "status": "in_progress",
  "currentPhase": 1,
  "currentStep": "1.1",
  "completedSteps": [],
  "pendingSteps": ["1.1", "1.2", "1.3", "1.4", "2.1", "2.2", "3.1", "3.2", "4.1", "5.1", "6.1"],
  "lastCheckpoint": "{startTime}",
  "canResume": true,
  "techStack": {
    "framework": "Next.js 15 (App Router)",
    "ui": "React + shadcn/ui",
    "styling": "Tailwind CSS"
  }
}
```

**_status.json** (대시보드용):
```json
{
  "sessionId": "{sessionId}",
  "startTime": "{startTime}",
  "currentPhase": 1,
  "currentStep": "1.1",
  "progress": 0,
  "status": "running",
  "agents": [],
  "stats": {
    "filesCreated": 0,
    "linesWritten": 0,
    "totalSize": "0KB"
  },
  "recentFiles": [],
  "errors": [],
  "lastUpdate": "{startTime}"
}
```

---

### Phase 1: Design Brainstorming (Sequential)

#### Step 1.1: Requirements Analysis

```
# 1. 상태 업데이트 - 에이전트 시작
_status.agents.push({
  "name": "design-interviewer",
  "status": "running",
  "startedAt": "{now}"
})
_status.lastUpdate = {now}
Update(_status.json)

# 2. 인라인 진행률 출력
Output: "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 1/6 [██░░░░░░░░░░░░░░] 4% │ Step 1.1
● design-interviewer 실행 중...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"

# 3. 에이전트 실행
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "
    역할: design-interviewer

    입력: {PRD 또는 사용자 요구사항}

    작업:
    1. 요구사항을 분석하여 requirements.md 생성
    2. 다음 구조로 작성:
       - 프로젝트 개요
       - 핵심 기능 목록
       - 사용자 유형
       - 기술 제약사항

    출력 경로: tmp/{sessionId}/00-requirements/requirements.md

    OUTPUT RULES:
    1. 모든 결과는 파일에 저장
    2. 반환 시 '완료. 생성 파일: {경로} ({줄수}줄)' 형식만
    3. 파일 내용을 응답에 절대 포함하지 않음
  "
)

# 4. 상태 업데이트 - 에이전트 완료
agent = _status.agents.find(a => a.name == "design-interviewer")
agent.status = "completed"
agent.completedAt = {now}
agent.duration = {seconds since startedAt}
agent.output = "requirements.md ({줄수}줄)"

_status.stats.filesCreated += 1
_status.stats.linesWritten += {줄수}
_status.recentFiles.unshift("00-requirements/requirements.md")
_status.progress = 4
_status.lastUpdate = {now}
Update(_status.json)

# 5. 체크포인트 업데이트
_meta.completedSteps += "1.1"
_meta.currentStep = "1.2"
_meta.lastCheckpoint = {now}
Update(_meta.json)
```

#### Step 1.2: Divergent Thinking

```
Task(
  subagent_type: "general-purpose",
  model: "sonnet",
  prompt: "
    역할: divergent-thinker

    입력: Read(tmp/{sessionId}/00-requirements/requirements.md)

    작업:
    1. 각 주요 결정 사항에 대해 3-4개 대안 제시
    2. 대안별 장단점 분석
    3. 권장안 제시

    주제:
    - 상태 관리 전략
    - 데이터 페칭 전략
    - 실시간 업데이트 방식
    - UI 컴포넌트 선택
    - 테스트 전략

    출력: 주제별로 분리된 파일 (600줄 이하씩)

    출력 경로:
    - tmp/{sessionId}/01-chapters/alternatives/state-management.md
    - tmp/{sessionId}/01-chapters/alternatives/data-fetching.md
    - tmp/{sessionId}/01-chapters/alternatives/realtime.md
    - tmp/{sessionId}/01-chapters/alternatives/ui-components.md
    - tmp/{sessionId}/01-chapters/alternatives/testing.md
    - tmp/{sessionId}/01-chapters/alternatives/_index.md (목차)

    OUTPUT RULES:
    1. 모든 결과는 파일에 저장
    2. 반환 시 파일 경로와 줄 수만 보고
    3. 파일 내용을 응답에 절대 포함하지 않음
    4. 600줄 초과 시 추가 분리 (와이어프레임 제외)
    5. 분리 시 네이밍: {index}-{name}-{type}.md
    6. 분리 시 _index.md 필수 생성
  "
)

# 완료 후
_meta.completedSteps += "1.2"
_meta.currentStep = "1.3"
Update(_meta.json)
```

#### Step 1.3: Chapter Critique (3 Rounds)

```
# Round 1
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "
    역할: chapter-critic (Round 1/3)

    입력:
    - tmp/{sessionId}/00-requirements/requirements.md
    - tmp/{sessionId}/01-chapters/alternatives/_index.md

    작업:
    1. 누락된 요구사항 식별
    2. 기술적 리스크 분석
    3. 개선 제안

    출력 경로: tmp/{sessionId}/01-chapters/critique-round1.md

    OUTPUT RULES: (위와 동일)
  "
)

# Round 2 (Round 1 반영)
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "
    역할: chapter-critic (Round 2/3)

    입력: critique-round1.md

    작업:
    1. Round 1 피드백의 해결 여부 확인
    2. 추가 누락 사항 식별
    3. 아키텍처 일관성 검증

    출력 경로: tmp/{sessionId}/01-chapters/critique-round2.md

    OUTPUT RULES: (위와 동일)
  "
)

# Round 3 (최종)
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "
    역할: chapter-critic (Round 3/3 - Final)

    입력: critique-round1.md, critique-round2.md

    작업:
    1. 최종 품질 게이트 검증
    2. 해결되지 않은 이슈 목록
    3. 챕터 구조 최종 권고

    출력 경로: tmp/{sessionId}/01-chapters/critique-final.md

    OUTPUT RULES: (위와 동일)
  "
)

# 완료 후
_meta.completedSteps += "1.3"
_meta.currentStep = "1.4"
Update(_meta.json)
```

#### Step 1.4: Chapter Plan Finalization

```
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "
    역할: chapter-planner

    입력:
    - requirements.md
    - alternatives/_index.md
    - critique-final.md

    작업:
    1. 최종 챕터 구조 확정
    2. 각 챕터별 범위 정의
    3. 우선순위 할당 (P0/P1/P2)
    4. 챕터 간 의존관계 명시

    출력 형식:
    ## CH-00: {제목}
    - 범위: ...
    - 우선순위: P0
    - 의존: 없음

    ## CH-01: {제목}
    ...

    출력 경로: tmp/{sessionId}/01-chapters/chapter-plan-final.md

    OUTPUT RULES: (위와 동일)
  "
)

# Phase 1 완료
_meta.completedSteps += "1.4"
_meta.currentPhase = 2
_meta.currentStep = "2.1"
Update(_meta.json)

# 사용자에게 알림 (진행 상황)
Output: "
Phase 1 완료 (Design Brainstorming)
- requirements.md 생성됨
- alternatives/ 폴더에 대안 분석 완료
- 3라운드 비평 완료
- chapter-plan-final.md 확정

다음: Phase 2 (UI Architecture + Component Discovery)
"
```

---

### Phase 2: UI Architecture + Component Discovery

**병렬 실행 제한: 최대 2개씩 배치**

#### Step 2.1: Batch 1 (UI Architect + Component Auditor)

```
# 2개 에이전트 동시 실행
Task(
  subagent_type: "general-purpose",
  model: "sonnet",
  run_in_background: true,
  prompt: "
    역할: ui-architect

    입력: chapter-plan-final.md

    작업:
    1. 화면 목록 작성 (screen-list.md)
    2. 각 화면별 ASCII 와이어프레임 생성
    3. Desktop/Tablet/Mobile 반응형 고려

    출력 경로:
    - tmp/{sessionId}/02-screens/screen-list.md
    - tmp/{sessionId}/02-screens/wireframes/wireframe-{screen}.md (화면별)

    각 wireframe 파일에 SPEC-IT-{HASH}.md 도 함께 생성
    HASH = 파일경로 MD5 앞 8자리 대문자

    OUTPUT RULES: (위와 동일)
  "
)

Task(
  subagent_type: "general-purpose",
  model: "haiku",
  run_in_background: true,
  prompt: "
    역할: component-auditor

    입력: 프로젝트 루트 디렉토리 스캔

    작업:
    1. 기존 컴포넌트 스캔 (있으면)
    2. shadcn/ui 사용 가능 컴포넌트 목록
    3. 필요한 신규 컴포넌트 식별
    4. 갭 분석

    출력 경로:
    - tmp/{sessionId}/03-components/inventory.md
    - tmp/{sessionId}/03-components/gap-analysis.md

    OUTPUT RULES: (위와 동일)
  "
)

# 두 에이전트 완료 대기
Wait for both tasks

# 완료 후
_meta.completedSteps += "2.1"
_meta.currentStep = "2.2"
Update(_meta.json)
```

#### Step 2.2: Batch 2 (Component Builder + Migrator)

```
Task(
  subagent_type: "general-purpose",
  model: "sonnet",
  run_in_background: true,
  prompt: "
    역할: component-builder

    입력: gap-analysis.md

    작업:
    1. 신규 컴포넌트별 명세 작성
    2. Props 인터페이스 정의
    3. 상태 관리 방식
    4. 이벤트 핸들링

    출력 경로: tmp/{sessionId}/03-components/new/spec-{component}.md

    각 파일에 SPEC-IT-{HASH}.md 도 함께 생성

    OUTPUT RULES: (위와 동일)
  "
)

Task(
  subagent_type: "general-purpose",
  model: "sonnet",
  run_in_background: true,
  prompt: "
    역할: component-migrator

    입력: inventory.md, gap-analysis.md

    작업:
    1. 기존 컴포넌트 마이그레이션 계획 (있으면)
    2. 호환성 분석
    3. 마이그레이션 단계

    출력 경로: tmp/{sessionId}/03-components/migrations/migration-plan.md

    OUTPUT RULES: (위와 동일)
  "
)

# 두 에이전트 완료 대기
Wait for both tasks

# Phase 2 완료
_meta.completedSteps += "2.2"
_meta.currentPhase = 3
_meta.currentStep = "3.1"
Update(_meta.json)

# 컨텍스트 관리 알림
Output: "
Phase 2 완료 (UI Architecture + Components)
- {N}개 화면 와이어프레임 생성
- {N}개 컴포넌트 명세 생성

컨텍스트 상태: 중간
권장: 계속 진행 가능
"
```

---

### Phase 3: Critical Review

#### Step 3.1: Parallel Review (2개씩)

```
# Batch 1: Critical Reviewer + Ambiguity Detector
Task(
  subagent_type: "general-purpose",
  model: "opus",
  run_in_background: true,
  prompt: "
    역할: critical-reviewer

    입력:
    - chapter-plan-final.md
    - screen-list.md
    - gap-analysis.md

    작업:
    1. 시나리오 분석 (사용자 여정)
    2. IA(정보 구조) 리뷰
    3. 예외 상황 분석

    출력 경로:
    - tmp/{sessionId}/04-review/scenarios/scenario-{name}.md
    - tmp/{sessionId}/04-review/ia-review.md
    - tmp/{sessionId}/04-review/exceptions/exception-{name}.md

    OUTPUT RULES: (위와 동일)
  "
)

Task(
  subagent_type: "general-purpose",
  model: "opus",
  run_in_background: true,
  prompt: "
    역할: ambiguity-detector

    입력: 모든 Phase 1-2 출력물

    작업:
    1. 모호한 요구사항 식별
    2. 충돌하는 요구사항 식별
    3. 누락된 결정 사항 식별
    4. 각 항목에 심각도 부여 (Must Resolve / Should Resolve / Nice to Have)

    출력 경로: tmp/{sessionId}/04-review/ambiguities.md

    OUTPUT RULES: (위와 동일)
  "
)

Wait for both tasks

# 완료 후
_meta.completedSteps += "3.1"
_meta.currentStep = "3.2"
Update(_meta.json)
```

#### Step 3.2: Ambiguity Resolution (Conditional)

```
Read(tmp/{sessionId}/04-review/ambiguities.md)

IF "Must Resolve" 항목이 존재:
  # 사용자에게 질문
  AskUserQuestion(
    questions: [
      {
        question: "다음 모호한 항목들에 대해 결정해 주세요:",
        header: "Ambiguity",
        options: [
          {label: "Option A", description: "..."},
          {label: "Option B", description: "..."},
          ...
        ]
      }
    ]
  )

  # 응답을 ambiguities-resolved.md에 저장
  Write(tmp/{sessionId}/04-review/ambiguities-resolved.md, 응답 내용)
ELSE:
  # 자동 진행
  Output: "모호성 없음. 자동 진행합니다."

# Phase 3 완료
_meta.completedSteps += "3.2"
_meta.currentPhase = 4
_meta.currentStep = "4.1"
Update(_meta.json)
```

---

### Phase 4: Test Specification

#### Step 4.1: Test Spec Generation

```
Task(
  subagent_type: "general-purpose",
  model: "sonnet",
  run_in_background: true,
  prompt: "
    역할: persona-architect

    입력: requirements.md, scenarios/

    작업:
    1. 사용자 페르소나 정의
    2. 각 페르소나별 주요 시나리오
    3. 테스트 우선순위

    출력 경로: tmp/{sessionId}/05-tests/personas/persona-{name}.md

    OUTPUT RULES: (위와 동일)
  "
)

Task(
  subagent_type: "general-purpose",
  model: "sonnet",
  run_in_background: true,
  prompt: "
    역할: test-spec-writer

    입력: personas/, scenarios/, components/

    작업:
    1. 테스트 시나리오 작성 (Given-When-Then)
    2. 컴포넌트별 테스트 케이스
    3. 커버리지 맵

    출력 경로:
    - tmp/{sessionId}/05-tests/scenarios/test-{scenario}.md
    - tmp/{sessionId}/05-tests/components/test-{component}.md
    - tmp/{sessionId}/05-tests/coverage-map.md

    OUTPUT RULES: (위와 동일)
  "
)

Wait for both tasks

# Phase 4 완료
_meta.completedSteps += "4.1"
_meta.currentPhase = 5
_meta.currentStep = "5.1"
Update(_meta.json)
```

---

### Phase 5: Final Assembly

#### Step 5.1: Specification Assembly

```
Task(
  subagent_type: "general-purpose",
  model: "haiku",
  prompt: "
    역할: spec-assembler

    입력: tmp/{sessionId}/ 전체

    작업:
    1. final-spec.md 생성 (통합 명세서)
       - Executive Summary
       - 아키텍처 개요
       - 화면별 명세 (요약)
       - 컴포넌트 목록
       - 테스트 전략

    2. dev-tasks.md 생성 (개발 태스크)
       - Phase별 태스크 목록
       - 우선순위
       - 의존관계
       - 예상 소요시간

    3. SPEC-SUMMARY.md 생성 (요약)

    출력 경로:
    - tmp/{sessionId}/06-final/final-spec.md
    - tmp/{sessionId}/06-final/dev-tasks.md
    - tmp/{sessionId}/06-final/SPEC-SUMMARY.md

    OUTPUT RULES: (위와 동일)
  "
)

# Phase 5 완료
_meta.completedSteps += "5.1"
_meta.currentPhase = 6
_meta.currentStep = "6.1"
_meta.status = "pending_approval"
Update(_meta.json)
```

---

### Phase 6: Final Approval

#### Step 6.1: User Approval

```
# 통계 계산
Read(tmp/{sessionId}/06-final/SPEC-SUMMARY.md)

AskUserQuestion(
  questions: [
    {
      question: "명세서 생성이 완료되었습니다. 작업 파일을 어떻게 처리할까요?",
      header: "Cleanup",
      options: [
        {label: "Archive", description: "archive/{sessionId}/로 이동"},
        {label: "Keep", description: "tmp/ 폴더에 유지"},
        {label: "Delete", description: "tmp/ 폴더 삭제"}
      ]
    }
  ]
)

IF Archive:
  Bash(mv tmp/{sessionId} archive/{sessionId})
ELIF Delete:
  Bash(rm -rf tmp/{sessionId})
ELSE:
  # Keep - 아무것도 안함

# 완료
_meta.status = "completed"
_meta.completedSteps += "6.1"
Update(_meta.json)

Output: "
===== SPEC-IT-AUTOMATION 완료 =====

세션 ID: {sessionId}
생성된 파일:
- 06-final/final-spec.md
- 06-final/dev-tasks.md
- 06-final/SPEC-SUMMARY.md

통계:
- 챕터: {N}개
- 화면: {N}개
- 컴포넌트: {N}개
- 테스트 케이스: {N}개

다음 단계:
1. final-spec.md 검토
2. dev-tasks.md로 구현 시작
===================================
"
```

---

## Output Structure

```
tmp/{session-id}/
├── _meta.json                 # 체크포인트 (Resume 지원)
├── _status.json               # 실시간 상태 (Dashboard용)
├── 00-requirements/
│   ├── _index.md              # 분리 시 생성
│   ├── 0-overview-requirement.md
│   ├── 1-auth-requirement.md
│   └── ...
├── 01-chapters/
│   ├── alternatives/
│   │   ├── _index.md
│   │   ├── 0-state-alternative.md
│   │   ├── 1-datafetch-alternative.md
│   │   └── ...
│   ├── critique-round1.md
│   ├── critique-round2.md
│   ├── critique-final.md
│   ├── chapter-plan-final.md
│   └── decisions/
│       ├── _index.md
│       ├── 0-scope-decision.md
│       └── ...
├── 02-screens/
│   ├── _index.md
│   ├── 0-login-screen.md
│   ├── 1-dashboard-screen.md
│   └── wireframes/            # 와이어프레임은 분리 제외 (무제한)
│       ├── wireframe-{screen}.md
│       └── SPEC-IT-{HASH}.md
├── 03-components/
│   ├── inventory.md
│   ├── gap-analysis.md
│   ├── new/
│   │   ├── _index.md
│   │   ├── 0-datepicker-component.md
│   │   ├── 1-stepper-component.md
│   │   └── SPEC-IT-{HASH}.md
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
│   ├── ambiguities.md
│   └── ambiguities-resolved.md
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
    ├── dev-tasks.md
    └── SPEC-SUMMARY.md
```

---

## Error Recovery

### Context Limit 도달 시

```
현재 상태가 자동 저장되었습니다.

재개 방법:
1. 새 세션 시작
2. /frontend-skills:spec-it-automation --resume {sessionId}

저장된 상태:
- Phase: {currentPhase}
- Step: {currentStep}
- 완료된 파일: {list}
```

### Compaction 실패 시

```
/compact 실패 - 새 세션에서 재개하세요.

명령어:
/frontend-skills:spec-it-automation --resume {sessionId}
```

---

## Dashboard Integration

### 실시간 대시보드 (별도 터미널)

```bash
# 대시보드 실행
~/.claude/plugins/frontend-skills/skills/shared/dashboard/spec-it-dashboard.sh

# 특정 세션
~/.claude/plugins/frontend-skills/skills/shared/dashboard/spec-it-dashboard.sh ./tmp/20260130-123456
```

**대시보드 표시 정보:**
- 현재 Phase/Step 및 진행률
- 실행 중인 에이전트 목록
- 생성된 파일 수/줄 수
- 실행 시간
- 최근 생성된 파일

### 인라인 진행률 (Claude Code 출력)

각 Step 시작 시 자동 출력:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 2/6 [████████░░░░░░░░] 33% │ Files: 12 │ 05:32
● ui-architect [RUNNING] ○ component-auditor [PENDING]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 진행률 계산

| Phase | Steps | Progress |
|-------|-------|----------|
| 1 | 1.1-1.4 | 0-16% |
| 2 | 2.1-2.2 | 17-33% |
| 3 | 3.1-3.2 | 34-50% |
| 4 | 4.1 | 51-66% |
| 5 | 5.1 | 67-83% |
| 6 | 6.1-6.2 | 84-100% |

---

## Related Skills

- `/frontend-skills:spec-it` - Manual mode (모든 챕터 승인)
- `/frontend-skills:spec-it-complex` - Hybrid mode (마일스톤 승인)
- `/frontend-skills:init-spec-md` - 기존 코드용 SPEC-IT 생성
