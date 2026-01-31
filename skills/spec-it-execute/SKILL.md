---
name: spec-it-execute
description: "Autopilot-style executor. Transforms spec-it specifications into working code with minimal intervention. 9-phase workflow: Load → Plan → Execute → QA → Spec-Mirror → Unit-Test → Scenario-Test → Validate → Complete."
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
argument-hint: "<spec-folder> [--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-execute: Autopilot Specification Executor

Transform spec-it specifications into **working code** with **autonomous execution** and **minimal user intervention**.

---

## Spec Format Support

Supports both YAML (preferred) and Markdown (legacy) spec formats:

| Format | Extension | Priority | Benefits |
|--------|-----------|----------|----------|
| YAML | `.yaml` | **Preferred** | -64% file size, 10x faster parsing |
| Markdown | `.md` | Fallback | Legacy support |

### Format Detection

```
1. Check _meta.json for "specFormat" field
2. If not specified, detect by file extension
3. YAML files take precedence when both exist
```

### YAML Spec Benefits

- **Structured parsing**: Direct YAML.parse vs regex
- **Shared tokens**: `_ref` to design-tokens.yaml
- **Precise values**: Exact measurements, not approximations
- **Reduced tokens**: ~80% reduction in duplicate content

---

## Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    spec-it-execute                               │
├─────────────────────────────────────────────────────────────────┤
│  Input: spec-it output (tmp/{sessionId}/06-final/)               │
│  Output: Working implementation with tests                       │
├─────────────────────────────────────────────────────────────────┤
│  Phase 0: INITIALIZE   → Session setup, dashboard launch        │
│  Phase 1: LOAD         → Load specs, validate completeness      │
│  Phase 2: PLAN         → Generate execution plan + critique     │
│  Phase 3: EXECUTE      → Implement with spec-executor           │
│  Phase 4: QA           → Build/test loop (max 5 cycles)         │
│  Phase 5: SPEC-MIRROR  → 실행 화면 기반 Spec 검증 (신규)         │
│  Phase 6: UNIT-TEST    → 테스트 구현 + 95% 커버리지 (신규)       │
│  Phase 7: SCENARIO-TEST→ Playwright E2E 100% 통과 (신규)        │
│  Phase 8: VALIDATE     → Code review + security audit           │
│  Phase 9: COMPLETE     → Final cleanup and summary              │
└─────────────────────────────────────────────────────────────────┘
```

---

## Agents Used

| Agent | Model | Phase | Role |
|-------|-------|-------|------|
| `spec-critic` | Opus | 2 | Plan validation |
| `spec-executor` | Opus/Sonnet | 3 | Multi-file implementation (complexity-based) |
| `spec-mirror-analyst` | **Sonnet** | 5 | Spec 일치 분석, 누락 항목 식별 |
| `test-implementer` | **Sonnet** | 6 | Unit Test 코드 구현 |
| `test-critic` | Opus | 6 | 테스트 품질 비판적 검수 |
| `e2e-implementer` | **Sonnet** | 7 | Playwright E2E 테스트 구현 |
| `scenario-recommender` | Sonnet | 7 | 추가 시나리오 추천 |
| `regression-checker` | Haiku | 7 | Unit Test regression 확인 |
| `code-reviewer` | Opus | 8 | Code quality review |
| `security-reviewer` | Opus | 8 | Security audit |
| `screen-vision` | Sonnet | 1 | Mockup analysis (if provided) |

## Optimized Model Routing

| Phase | Task Type | Old Model | New Model | Savings |
|-------|-----------|-----------|-----------|---------|
| 3 | 단순 컴포넌트 | Opus | Sonnet | ~60% |
| 3 | 복잡한 멀티파일 | Opus | Opus | - |
| 4 | Build 에러 수정 | Opus | **Haiku** | ~80% |
| 4 | Type 에러 수정 | Opus | **Sonnet** | ~60% |
| 5 | 시각 비교 | Opus | **Sonnet** | ~60% |
| 6 | Unit 테스트 | Opus | **Sonnet** | ~60% |
| 7 | E2E 테스트 | Opus | **Sonnet** | ~60% |
| 8 | 보안 리뷰 | Opus | Opus | - |

**Rule:** Always pass `model` parameter explicitly to Task calls based on this routing table.

---

## Live Preview Mode (Chrome DevTools MCP)

개발 과정을 실시간으로 브라우저에서 확인할 수 있습니다.

### 사용 가능한 도구 (26개)

| 카테고리 | 도구 |
|----------|------|
| **입력** | click, drag, fill, fill_form, hover, press_key, upload_file, handle_dialog |
| **네비게이션** | navigate_page, new_page, close_page, list_pages, select_page, wait_for |
| **디버깅** | evaluate_script, take_screenshot, take_snapshot, get_console_message, list_console_messages |
| **성능** | performance_start_trace, performance_stop_trace, performance_analyze_insight |
| **네트워크** | list_network_requests, get_network_request |
| **에뮬레이션** | emulate, resize_page |

### Live Preview 워크플로우

```
1. 개발 서버 시작 (npm run dev)
2. Chrome DevTools MCP로 브라우저 열기
3. 각 구현 단계마다:
   - 페이지 이동 (navigate_page)
   - 스크린샷 캡처 (take_screenshot)
   - 콘솔 에러 확인 (list_console_messages)
4. 테스트 시 사용자 인터랙션 시뮬레이션
```

---

## Smart Model Routing

| Complexity | Model | Use Case |
|------------|-------|----------|
| LOW | Haiku | Simple file reads, status checks, build errors |
| MEDIUM | Sonnet | Standard implementation, tests, visual comparison |
| HIGH | Opus | Complex multi-file changes, critical reviews, security |

**Rule:** Always pass `model` parameter explicitly to Task calls.

### Complexity Assessment Rules

```
LOW (→ Haiku):
- Single file read/status check
- Build error with clear message
- Simple regex-based fix
- Status reporting

MEDIUM (→ Sonnet):
- Single component implementation
- Type error fixes
- Unit test implementation
- E2E test implementation
- Visual comparison
- Spec file parsing

HIGH (→ Opus):
- Multi-file implementation (3+ files)
- Cross-component changes
- Architectural decisions
- Security review
- Code quality review
- Plan generation/critique
```

---

## Execution Instructions

### Phase 0: Initialize

```
IF argument contains "--resume":
  → Resume mode (Phase 0.R)
ELSE:
  → New session (Phase 0.1)
```

#### Phase 0.R: Resume Mode
```bash
# 1. Load session state
Read(.spec-it/execute/{sessionId}/_state.json)

# 2. Get current phase/step
currentPhase = _state.currentPhase
currentStep = _state.currentStep

# 3. Resume from checkpoint
GOTO Phase {currentPhase}, Step {currentStep}
```

#### Phase 0.1: New Session
```bash
# Use execute-session-init.sh to initialize session and auto-launch dashboard
# This script creates:
# - .spec-it/execute/{sessionId}/ folder structure
# - _meta.json (with parentTerminal info for 'r' key feature)
# - _state.json (for resume support)
# - _status.json (for dashboard display)
# - Auto-launches dashboard in separate terminal

Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/execute-session-init.sh "{sessionId}" "{spec-folder}" "$(pwd)"

# Parse output to get session info
# Output format:
# SESSION_ID:{id}
# SESSION_DIR:{path}
# SPEC_FOLDER:{path}
# DASHBOARD:launched

# Verify initialization
Read(.spec-it/execute/{sessionId}/_state.json)
```

**State file schema (_state.json):**
```json
{
  "sessionId": "{sessionId}",
  "specSource": "{spec-folder}",
  "status": "in_progress",
  "currentPhase": 1,
  "currentStep": "1.1",
  "qaAttempts": 0,
  "maxQaAttempts": 5,
  "completedPhases": [],
  "startedAt": "{ISO timestamp}",
  "lastCheckpoint": "{ISO timestamp}",
  "livePreview": false,

  "mirrorAttempts": 0,
  "maxMirrorAttempts": 5,
  "lastMirrorReport": { "matchCount": 0, "missingCount": 0, "overCount": 0 },

  "coverageAttempts": 0,
  "maxCoverageAttempts": 5,
  "targetCoverage": 95,
  "currentCoverage": { "statements": 0, "branches": 0, "functions": 0, "lines": 0 },

  "scenarioAttempts": 0,
  "maxScenarioAttempts": 5,
  "scenarioResults": { "total": 0, "passed": 0, "failed": 0 }
}
```

#### Phase 0.2: Live Preview 설정 (Optional)

```
AskUserQuestion(
  questions: [{
    question: "개발 과정을 브라우저에서 실시간으로 확인하시겠습니까?",
    header: "Live Preview",
    options: [
      {label: "Yes", description: "Chrome DevTools MCP로 실시간 확인"},
      {label: "No", description: "터미널 출력만 확인"}
    ]
  }]
)

IF "Yes":
  # 1. 개발 서버 시작
  Task(
    subagent_type: "Bash",
    model: "haiku",
    run_in_background: true,
    prompt: "npm run dev"
  )

  # 2. Chrome 브라우저 열기 (MCP)
  # chrome-devtools MCP: new_page 도구 사용
  MCP_CALL: new_page(url: "http://localhost:3000")

  # 3. 상태 업데이트
  _state.livePreview = true
  _state.devServerPid = {pid}
  _state.previewUrl = "http://localhost:3000"
  Update(_state.json)

  Output: "
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Live Preview 활성화
  URL: http://localhost:3000
  브라우저가 열렸습니다. 개발 과정이 실시간으로 반영됩니다.
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  "
```

---

### Phase 1: LOAD (Spec Loading)

#### Step 1.1: Validate Spec Source
```
Read({spec-folder}/06-final/final-spec.md)
Read({spec-folder}/06-final/dev-tasks.md)

IF files missing:
  Output: "Error: Spec files not found. Run spec-it first."
  EXIT
```

#### Step 1.2: Extract Implementation Tasks
```
Task(
  subagent_type: "general-purpose",
  model: "haiku",
  prompt: "
    Read: {spec-folder}/06-final/dev-tasks.md

    Extract:
    1. All implementation tasks
    2. Dependencies between tasks
    3. Priority order (P0 → P1 → P2)

    Output: .spec-it/execute/{sessionId}/plans/task-list.md

    OUTPUT RULES:
    1. Write all results to file
    2. Return only: 'Done. File: {path} ({lines} lines)'
    3. Never include file contents in response
  "
)

# Update state
_state.currentStep = "1.3"
_state.lastCheckpoint = now()
Update(_state.json)
```

#### Step 1.3: UI Reference Analysis

```
# Check UI mode from spec-it _meta.json
Read({spec-folder}/_meta.json)

IF wireframes exist in {spec-folder}/02-screens/wireframes/:
  # YAML Wireframe 모드 - 구조화된 YAML 와이어프레임 사용
  Task(
    subagent_type: "general-purpose",
    model: "sonnet",
    prompt: "
      Role: screen-vision

      Analyze all YAML wireframes in {spec-folder}/02-screens/wireframes/

      Reference: skills/shared/references/yaml-ui-frame/

      Extract:
      1. Component inventory from components arrays
      2. Layout patterns from grid.areas
      3. Design tokens from designDirection.colorTokens
      4. Motion guidelines from designDirection.motionGuidelines
      5. Responsive breakpoints from responsive section

      Output: .spec-it/execute/{sessionId}/plans/visual-analysis.md

      OUTPUT RULES: (standard)
    "
  )

  _state.uiMode = "yaml"
  Update(_state.json)

# Load design style from spec-it session
IF _meta.designStyle exists:
  _state.designStyle = _meta.designStyle
  _state.designTrends = _meta.designTrends
  _state.designTrendsPath = _meta.designTrendsPath OR "$HOME/.claude/plugins/marketplaces/claude-frontend-skills/skills/design-trends-2026"
  Update(_state.json)

# Phase 1 complete
_state.completedPhases += "1"
_state.currentPhase = 2
_state.currentStep = "2.1"
Update(_state.json)

Output: "
Phase 1 Complete (LOAD)
- Spec source validated
- {N} tasks extracted
- Ready for planning
"
```

---

### Phase 2: PLAN (Execution Planning)

#### Step 2.1: Generate Execution Plan
```
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "
    Inputs:
    - .spec-it/execute/{sessionId}/plans/task-list.md
    - {spec-folder}/06-final/final-spec.md
    - {spec-folder}/03-components/gap-analysis.md

    Generate execution plan with:
    1. Task breakdown (atomic steps)
    2. File creation order
    3. Dependency graph
    4. Verification checkpoints
    5. Rollback points

    Output: .spec-it/execute/{sessionId}/plans/execution-plan.md

    Format:
    ## Task T-001: {name}
    - Files: [list]
    - Dependencies: [T-xxx]
    - Verification: [command]
    - Rollback: [steps]

    OUTPUT RULES: (standard)
  "
)

_state.currentStep = "2.2"
Update(_state.json)
```

#### Step 2.2: Plan Critique
```
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "
    Role: spec-critic

    Input: .spec-it/execute/{sessionId}/plans/execution-plan.md

    Review for:
    1. Clarity - Are tasks unambiguous?
    2. Verifiability - Can completion be measured?
    3. Completeness - Is 90%+ context present?
    4. Big Picture - WHY/WHAT/HOW clear?

    Output: .spec-it/execute/{sessionId}/reviews/plan-critique.md

    OUTPUT RULES: (standard)
  "
)

Read(.spec-it/execute/{sessionId}/reviews/plan-critique.md)

IF verdict == "[REJECT]":
  # Auto-fix and re-critique (max 3 attempts)
  FOR attempt IN 1..3:
    Task(fix plan based on critique)
    Task(re-critique)
    IF verdict == "[OKAY]": BREAK

  IF still rejected:
    AskUserQuestion(
      questions: [{
        question: "Plan failed critique 3 times. How to proceed?",
        header: "Plan Issue",
        options: [
          {label: "Review manually", description: "I'll fix the plan"},
          {label: "Force continue", description: "Proceed anyway (risky)"},
          {label: "Abort", description: "Stop execution"}
        ]
      }]
    )

# Phase 2 complete
_state.completedPhases += "2"
_state.currentPhase = 3
_state.currentStep = "3.1"
Update(_state.json)

Output: "
Phase 2 Complete (PLAN)
- Execution plan generated
- Plan critique: [OKAY]
- Ready for implementation
"
```

---

### Phase 3: EXECUTE (Implementation)

#### Step 3.0: Build Dependency Graph & Batch Tasks
```
Read(.spec-it/execute/{sessionId}/plans/execution-plan.md)
tasks = parse_tasks(plan)

# Build dependency graph from dev-tasks.md
dependencyGraph = build_dependency_graph(tasks)

# Topological sort into execution batches
# Tasks with same level (no inter-dependencies) can run in parallel
batches = topological_batch(dependencyGraph, maxParallel=4)

# Example:
# Batch 1: [T-001, T-002, T-003, T-004] (no dependencies, parallel)
# Batch 2: [T-005, T-006] (depends on Batch 1)
# Batch 3: [T-007] (depends on T-005)

Output: "
Execution Plan:
- Total tasks: {tasks.length}
- Batches: {batches.length}
- Estimated parallelization savings: ~{savingsPercent}%
"
```

#### Step 3.1: Execute Tasks (Batched Parallel)
```
FOR batch IN batches:
  Output: "Batch {batch.index}/{batches.length}: Executing {batch.tasks.length} tasks in parallel"

  # Execute all tasks in this batch in parallel (max 4)
  parallelTasks = []

  FOR task IN batch.tasks:

  # Determine complexity for model routing
  complexity = assess_complexity(task)
  model = complexity == "HIGH" ? "opus" : "sonnet"

  # Build UI reference context (YAML wireframe mode)
  uiRefContext = "
    UI Reference Mode: YAML (Structured Wireframe)
    Wireframes: {spec-folder}/02-screens/wireframes/*.yaml
    Reference: skills/shared/references/yaml-ui-frame/
  "

  # Build design reference context
  IF _state.designStyle:
    designRefContext = "
      === DESIGN REFERENCE (MUST READ) ===

      Design Style: {_state.designStyle}
      Applied Trends: {_state.designTrends}

      1. Read wireframe for this screen:
         {spec-folder}/02-screens/wireframes/
         → Extract 'Design Direction' section

      2. Read templates based on Component Patterns:
         - {_state.designTrendsPath}/templates/dashboard-templates.md
         - {_state.designTrendsPath}/templates/card-templates.md
         - {_state.designTrendsPath}/templates/form-templates.md
         - {_state.designTrendsPath}/templates/navigation-templates.md

      3. Read motion presets:
         - {_state.designTrendsPath}/references/motion-presets.md

      === IMPLEMENTATION RULES ===
      1. Copy Tailwind classes from templates exactly
      2. Add source comments: // Template: {path}#{section}
      3. Apply Color Tokens from wireframe's Design Direction
      4. Implement Motion Guidelines with Framer Motion
    "
  ELSE:
    designRefContext = ""

    # Add to parallel task list
    parallelTasks.append(
      Task(
        subagent_type: "general-purpose",
        model: model,
        run_in_background: true,  # Enable parallel execution
        prompt: "
          Role: spec-executor

          Task: {task.name}
          Files: {task.files}
          Spec Reference: {task.spec_ref}

          {uiRefContext}

          {designRefContext}

          Requirements:
          1. Implement exactly as specified
          2. Use TodoWrite for tracking
          3. Verify after each file change
          4. Record decisions in notepad
          5. IF HTML reference exists, match design exactly
          6. IF designRefContext exists, follow template patterns

          Verification Command: {task.verification}

          Output log: .spec-it/execute/{sessionId}/logs/task-{task.id}.md

          OUTPUT RULES:
          1. Write implementation to specified files
          2. Write log to output log path
          3. Include template source comments in code
          4. Return: 'Done. Task {id}: {status}. Files: {count}'
        "
      )
    )

  # Wait for all parallel tasks in this batch to complete
  AWAIT ALL parallelTasks

  # Update progress for batch
  FOR task IN batch.tasks:
    _state.completedTasks += task.id

  _state.lastCheckpoint = now()
  Update(_state.json)

  Output: "Batch {batch.index} complete: {batch.tasks.length} tasks"

  # Live Preview 확인 (활성화된 경우)
  IF _state.livePreview AND task involves UI changes:
    # 1. 페이지 새로고침
    MCP_CALL: navigate_page(url: _state.previewUrl + task.route)

    # 2. 렌더링 대기
    MCP_CALL: wait_for(selector: "body", timeout: 5000)

    # 3. 스크린샷 캡처
    MCP_CALL: take_screenshot(
      path: ".spec-it/execute/{sessionId}/screenshots/task-{task.id}.png"
    )

    # 4. 콘솔 에러 확인
    consoleMessages = MCP_CALL: list_console_messages(level: "error")
    IF consoleMessages.length > 0:
      Write(.spec-it/execute/{sessionId}/logs/console-errors-{task.id}.md, consoleMessages)

    Output: "
    [Live] Task {task.id} 완료
    스크린샷: screenshots/task-{task.id}.png
    콘솔 에러: {consoleMessages.length}개
    "

  # Quick verification (via spec-executor agent)
  IF task.verification:
    Task(
      subagent_type: "Bash",
      model: "haiku",
      prompt: "
        Run verification command: {task.verification}
        Return: 'PASS' or 'FAIL: {error summary}'
      "
    )
    IF result contains "FAIL":
      # Log failure, continue (QA phase will catch it)
      Write(.spec-it/execute/{sessionId}/logs/failures.md, append)

# Phase 3 complete
_state.completedPhases += "3"
_state.currentPhase = 4
_state.currentStep = "4.1"
Update(_state.json)

Output: "
Phase 3 Complete (EXECUTE)
- {N}/{total} tasks implemented
- Moving to QA phase
"
```

---

### Phase 4: QA (Quality Assurance Loop)

#### Step 4.1: QA Cycle (Max 5 Attempts)
```
WHILE _state.qaAttempts < _state.maxQaAttempts:

  _state.qaAttempts += 1

  # Run QA checks via spec-executor agent (has bypassPermissions)
  Task(
    subagent_type: "Bash",
    model: "haiku",
    prompt: "
      Run QA checks and report results:

      Commands to run:
      1. npm run lint 2>&1 || true
      2. npm run type-check 2>&1 || true
      3. npm run test 2>&1 || true
      4. npm run build 2>&1 || true

      Output format:
      LINT: [PASS/FAIL] {summary}
      TYPE: [PASS/FAIL] {summary}
      TEST: [PASS/FAIL] {summary}
      BUILD: [PASS/FAIL] {summary}
      ALL_PASSED: [true/false]

      If errors exist, include first 20 lines of each error.

      OUTPUT RULES:
      1. Return results in format above
      2. Do NOT fix anything - just report
    "
  )

  IF ALL_PASSED == true:
    Output: "QA Passed on attempt {_state.qaAttempts}"
    BREAK

  # Diagnose and fix with optimized model routing
  # Parse error types from QA results
  errorTypes = parse_error_types(QA_results)

  # Route to appropriate model based on error type
  FOR errorType IN errorTypes:
    IF errorType == "BUILD":
      # Build errors are usually straightforward
      model = "haiku"
    ELIF errorType == "TYPE":
      # Type errors need more context
      model = "sonnet"
    ELIF errorType == "LINT":
      # Lint errors are mechanical
      model = "haiku"
    ELIF errorType == "TEST":
      # Test failures may need logic understanding
      model = "sonnet"
    ELSE:
      model = "sonnet"

    Task(
      subagent_type: "general-purpose",
      model: model,
      prompt: "
        Role: spec-executor

        QA Failure Type: {errorType}
        Attempt: {_state.qaAttempts}/{maxQaAttempts}

        Error Details:
        {error_details_for_this_type}

        Instructions:
        1. Analyze root cause
        2. Fix the {errorType} errors
        3. Verify fix with appropriate command
        4. Log changes

        Output: .spec-it/execute/{sessionId}/logs/qa-{attempt}-{errorType}.md

        OUTPUT RULES:
        1. Write log to output path
        2. Return: 'Fixed {N} {errorType} issues.'
      "
    )

  Update(_state.json)

IF _state.qaAttempts >= _state.maxQaAttempts AND NOT allPassed:
  AskUserQuestion(
    questions: [{
      question: "QA failed after 5 attempts. How to proceed?",
      header: "QA Failed",
      options: [
        {label: "Fix manually", description: "I'll fix remaining issues"},
        {label: "Continue anyway", description: "Proceed to spec-mirror"},
        {label: "Abort", description: "Stop execution"}
      ]
    }]
  )

# Phase 4 complete
_state.completedPhases += "4"
_state.currentPhase = 5
_state.currentStep = "5.1"
Update(_state.json)
```

---

### Phase 5: SPEC-MIRROR (실행 화면 기반 검증)

**목적:** 개발 결과물이 Spec과 100% 일치하는지 **실제 화면**으로 검증

**왜 실행 화면 기반인가:**
- 코드베이스 검색으로는 구현 여부를 정확히 확인 불가능
- 실제 렌더링된 화면을 보고 검증해야 정확한 판단 가능

#### Step 5.1: Start Dev Server
```
# 개발 서버 실행 (아직 실행되지 않은 경우)
IF NOT _state.livePreview:
  Task(
    subagent_type: "Bash",
    model: "haiku",
    run_in_background: true,
    prompt: "npm run dev"
  )

  # Chrome 브라우저 열기
  MCP_CALL: new_page(url: "http://localhost:3000")

  _state.devServerPid = {pid}
  _state.previewUrl = "http://localhost:3000"
  Update(_state.json)
```

#### Step 5.2: Screen-by-Screen Verification (Batched)
```
WHILE _state.mirrorAttempts < _state.maxMirrorAttempts:

  _state.mirrorAttempts += 1

  # Load spec for screens
  Read({spec-folder}/02-screens/screen-list.md)
  screens = parse_screens(screen-list)

  missingItems = []
  matchedItems = []
  overSpecItems = []

  # Batch screenshots first (4 at a time for parallel capture)
  screenshotBatches = batch(screens, size=4)

  FOR batch IN screenshotBatches:
    # Capture screenshots in sequence (browser limitation)
    FOR screen IN batch:
      # 1. Navigate to screen
      MCP_CALL: navigate_page(url: _state.previewUrl + screen.route)

      # 2. Wait for load
      MCP_CALL: wait_for(text: screen.expectedText, timeout: 10000)

      # 3. Take screenshot
      MCP_CALL: take_screenshot(
        path: ".spec-it/execute/{sessionId}/screenshots/mirror-{screen.name}.png"
      )

      # 4. Get DOM snapshot and save
      snapshot = MCP_CALL: take_snapshot()
      Write(.spec-it/execute/{sessionId}/snapshots/{screen.name}.json, snapshot)

    # Analyze batch in parallel (using Sonnet for cost efficiency)
    analysisTasks = []
    FOR screen IN batch:
      analysisTasks.append(
        Task(
          subagent_type: "general-purpose",
          model: "sonnet",  # Optimized: Sonnet instead of Opus
          run_in_background: true,
          prompt: "
            Role: spec-mirror-analyst

            Compare:
            - Original Spec: {spec-folder}/02-screens/wireframes/{screen.name}.{yaml|md}
            - Screenshot: .spec-it/execute/{sessionId}/screenshots/mirror-{screen.name}.png
            - DOM Snapshot: .spec-it/execute/{sessionId}/snapshots/{screen.name}.json

            Analyze:
            1. 모든 Spec 요소가 화면에 존재하는가?
            2. 레이아웃이 일치하는가?
            3. 인터랙션이 정상 동작하는가?
            4. 추가 구현된 기능이 있는가? (over-spec, 허용됨)

            Output: .spec-it/execute/{sessionId}/analysis/mirror-{screen.name}.md

            Format:
            MATCHED: [list]
            MISSING: [list]
            OVER_SPEC: [list]

            OUTPUT RULES: (standard)
          "
        )
      )

    # Wait for all analysis tasks
    AWAIT ALL analysisTasks

    # Aggregate results from analysis files
    FOR screen IN batch:
      Read(.spec-it/execute/{sessionId}/analysis/mirror-{screen.name}.md)
      matchedItems += screen.matched
      missingItems += screen.missing
      overSpecItems += screen.overSpec

  # Generate MIRROR_REPORT
  Task(
    subagent_type: "general-purpose",
    model: "sonnet",
    prompt: "
      Generate MIRROR_REPORT using template:
      skills/spec-mirror/assets/templates/MIRROR_REPORT_TEMPLATE.md

      Data:
      - matchCount: {matchedItems.length}
      - missingCount: {missingItems.length}
      - overCount: {overSpecItems.length}
      - matched: {matchedItems}
      - missing: {missingItems}
      - over: {overSpecItems}

      Output: .spec-it/execute/{sessionId}/reviews/MIRROR_REPORT.md
    "
  )

  # Update state
  _state.lastMirrorReport = {
    matchCount: matchedItems.length,
    missingCount: missingItems.length,
    overCount: overSpecItems.length
  }
  Update(_state.json)

  # Check result
  IF missingItems.length == 0:
    Output: "
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    SPEC-MIRROR: PASS
    - 일치: {matchedItems.length}건
    - 누락: 0건
    - Over-spec: {overSpecItems.length}건 (허용됨)
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    "
    BREAK

  # Missing items exist - need to fix
  Output: "
  SPEC-MIRROR: FAIL (Attempt {_state.mirrorAttempts}/{_state.maxMirrorAttempts})
  - 누락 항목: {missingItems.length}건
  - 재개발 진행...
  "

  # Fix missing items
  Task(
    subagent_type: "general-purpose",
    model: "opus",
    prompt: "
      Role: spec-executor

      누락된 Spec 항목을 구현하세요:
      {missingItems}

      각 항목에 대해:
      1. 해당 컴포넌트/화면 스펙 로딩
         Skill(spec-component-loader {spec-folder} --name {component} --with-deps)
      2. 구현
      3. 검증

      Output: .spec-it/execute/{sessionId}/logs/mirror-fix-{attempt}.md
    "
  )

  # Re-run QA before next mirror check
  GOTO Phase 4 (QA check only, no phase update)

IF _state.mirrorAttempts >= _state.maxMirrorAttempts AND missingItems.length > 0:
  AskUserQuestion(
    questions: [{
      question: "Spec-Mirror failed after 5 attempts. {missingItems.length} items still missing.",
      header: "Mirror Failed",
      options: [
        {label: "Fix manually", description: "I'll implement missing items"},
        {label: "Continue anyway", description: "Proceed to unit tests"},
        {label: "Abort", description: "Stop execution"}
      ]
    }]
  )

# Phase 5 complete
_state.completedPhases += "5"
_state.currentPhase = 6
_state.currentStep = "6.1"
Update(_state.json)

Output: "
Phase 5 Complete (SPEC-MIRROR)
- Mirror attempts: {_state.mirrorAttempts}
- Final result: {verdict}
- Moving to Unit Test phase
"
```

---

### Phase 6: UNIT-TEST (95% 커버리지 목표)

**목적:** Unit Test 구현 및 95% 이상 코드 커버리지 달성

#### Step 6.1: Initial Test Implementation
```
# Load test specs
Task(
  subagent_type: "general-purpose",
  model: "sonnet",  # Optimized: Sonnet for test implementation
  prompt: "
    Role: test-implementer

    # Step 1: 테스트 목록 확인
    Skill(spec-test-loader {spec-folder} --list)

    # Step 2: P0 우선순위 테스트부터 시작
    Skill(spec-test-loader {spec-folder} --priority P0)

    각 테스트 스펙에 대해:
    1. Read test specification
    2. Create test file in appropriate location
    3. Implement all test cases
    4. Use AAA pattern (Arrange-Act-Assert)

    # Step 3: P1 우선순위
    Skill(spec-test-loader {spec-folder} --priority P1)

    # Step 4: P2 우선순위
    Skill(spec-test-loader {spec-folder} --priority P2)

    Output: .spec-it/execute/{sessionId}/logs/test-implementation.md
  "
)
```

#### Step 6.2: Coverage Loop
```
WHILE _state.coverageAttempts < _state.maxCoverageAttempts:

  _state.coverageAttempts += 1

  # Run coverage
  Task(
    subagent_type: "Bash",
    model: "haiku",
    prompt: "
      npm run test:coverage -- --reporter=json --outputFile=coverage.json

      Extract and return:
      STATEMENTS: {X}%
      BRANCHES: {X}%
      FUNCTIONS: {X}%
      LINES: {X}%

      Return: Coverage summary
    "
  )

  # Parse coverage results
  _state.currentCoverage = parse_coverage(result)
  Update(_state.json)

  # Check if target reached
  avgCoverage = (_state.currentCoverage.statements +
                 _state.currentCoverage.branches +
                 _state.currentCoverage.functions +
                 _state.currentCoverage.lines) / 4

  IF avgCoverage >= _state.targetCoverage:
    Output: "Coverage target reached: {avgCoverage}%"
    GOTO Step 6.3 (Quality Review)

  # Analyze gaps and add tests
  Task(
    subagent_type: "general-purpose",
    model: "sonnet",  # Optimized: Sonnet for test implementation
    prompt: "
      Role: test-implementer

      Current Coverage: {_state.currentCoverage}
      Target: {_state.targetCoverage}%
      Gap: {_state.targetCoverage - avgCoverage}%

      # 커버리지 갭 분석
      Skill(spec-test-loader {spec-folder} --coverage-gap)

      분석:
      1. 미커버리지 파일/함수 식별
      2. 해당 부분의 테스트 스펙 로딩
      3. 추가 테스트 작성

      우선순위:
      1. P0 컴포넌트 커버리지 100%
      2. Critical path 함수 커버리지 100%
      3. 나머지 95% 달성까지

      Output: .spec-it/execute/{sessionId}/logs/coverage-improvement-{attempt}.md
    "
  )

  Update(_state.json)

IF _state.coverageAttempts >= _state.maxCoverageAttempts AND avgCoverage < _state.targetCoverage:
  AskUserQuestion(
    questions: [{
      question: "Coverage is {avgCoverage}% after 5 attempts. Target: 95%",
      header: "Coverage Gap",
      options: [
        {label: "Add tests manually", description: "I'll write more tests"},
        {label: "Accept current", description: "Proceed with {avgCoverage}%"},
        {label: "Abort", description: "Stop execution"}
      ]
    }]
  )
```

#### Step 6.3: Test Quality Review
```
Task(
  subagent_type: "general-purpose",
  model: "opus",
  prompt: "
    Role: test-critic

    Analyze all test files for quality issues:

    검사 항목:
    1. 의미 없는 테스트 (항상 통과, assertion 없음)
    2. Edge case 누락
    3. Mock 남용 (실제 동작 테스트 부족)
    4. 테스트 격리 문제
    5. 불안정한 테스트 (flaky tests)

    각 문제에 대해:
    - 파일 경로
    - 문제 설명
    - 개선 제안

    Output: .spec-it/execute/{sessionId}/reviews/test-quality.md

    Verdict: [PASS] or [NEEDS_IMPROVEMENT]
  "
)

IF verdict == "[NEEDS_IMPROVEMENT]":
  # Fix quality issues
  Task(
    subagent_type: "general-purpose",
    model: "sonnet",  # Optimized: Sonnet for test fixes
    prompt: "
      Role: test-implementer

      Fix test quality issues from test-quality.md

      Focus on:
      1. Add meaningful assertions
      2. Add edge case tests
      3. Reduce mock abuse

      Output: .spec-it/execute/{sessionId}/logs/test-quality-fix.md
    "
  )

# Phase 6 complete
_state.completedPhases += "6"
_state.currentPhase = 7
_state.currentStep = "7.1"
Update(_state.json)

Output: "
Phase 6 Complete (UNIT-TEST)
- Final coverage: {_state.currentCoverage}
- Test quality: {verdict}
- Moving to Scenario Test phase
"
```

---

### Phase 7: SCENARIO-TEST (Playwright E2E 100% 통과)

**목적:** Playwright E2E 시나리오 테스트 100% 통과

#### Step 7.1: E2E Test Implementation
```
# Load scenarios
Task(
  subagent_type: "general-purpose",
  model: "sonnet",  # Optimized: Sonnet for E2E implementation
  prompt: "
    Role: e2e-implementer

    # Step 1: Critical Path 먼저 구현
    Skill(spec-scenario-loader {spec-folder} --critical-path)

    각 시나리오에 대해:
    1. Read scenario specification (Given/When/Then)
    2. Create Playwright test file
    3. Implement all steps
    4. Add proper assertions

    # Step 2: 화면별 시나리오
    FOR screen IN [dashboard, stock-detail, settings, search]:
      Skill(spec-scenario-loader {spec-folder} --screen {screen})
      → Implement E2E tests

    Output: .spec-it/execute/{sessionId}/logs/e2e-implementation.md
  "
)
```

#### Step 7.2: Additional Scenario Recommendations
```
Task(
  subagent_type: "general-purpose",
  model: "sonnet",
  prompt: "
    Role: scenario-recommender

    Analyze existing scenarios and recommend additional ones:

    고려 사항:
    1. Edge cases not covered
    2. Error scenarios
    3. Performance scenarios
    4. Accessibility scenarios
    5. Mobile responsiveness

    Output format:
    | Priority | Scenario | Rationale |

    Output: .spec-it/execute/{sessionId}/logs/scenario-recommendations.md
  "
)

# Ask user which recommendations to implement
AskUserQuestion(
  questions: [{
    question: "추가 시나리오 추천이 있습니다. 구현할 항목을 선택하세요.",
    header: "Scenarios",
    multiSelect: true,
    options: [
      {label: "Edge cases", description: "경계 조건 테스트"},
      {label: "Error scenarios", description: "에러 핸들링 테스트"},
      {label: "All recommended", description: "모든 추천 시나리오"},
      {label: "Skip", description: "추가 시나리오 건너뛰기"}
    ]
  }]
)

IF selected != "Skip":
  Task(e2e-implementer: implement selected scenarios)
```

#### Step 7.3: E2E Execution Loop
```
WHILE _state.scenarioAttempts < _state.maxScenarioAttempts:

  _state.scenarioAttempts += 1

  # Run Playwright tests
  Task(
    subagent_type: "Bash",
    model: "haiku",
    prompt: "
      npx playwright test --reporter=json 2>&1

      Return:
      TOTAL: {N}
      PASSED: {N}
      FAILED: {N}
      SKIPPED: {N}

      If failures, list:
      - Test name
      - Error message
      - Screenshot path (if available)
    "
  )

  # Parse results
  _state.scenarioResults = parse_results(result)
  Update(_state.json)

  # Write results to file for --failed loader
  Write(.spec-it/execute/{sessionId}/logs/e2e-results.json, {
    timestamp: now(),
    total: _state.scenarioResults.total,
    passed: _state.scenarioResults.passed,
    failed: _state.scenarioResults.failed,
    failures: [failure details]
  })

  IF _state.scenarioResults.failed == 0:
    Output: "All E2E scenarios passed!"
    BREAK

  # Fix failures
  Output: "
  E2E Results (Attempt {_state.scenarioAttempts}/{_state.maxScenarioAttempts}):
  - Passed: {_state.scenarioResults.passed}/{_state.scenarioResults.total}
  - Failed: {_state.scenarioResults.failed}
  "

  # Load failed scenarios
  Task(
    subagent_type: "general-purpose",
    model: "sonnet",  # Optimized: Sonnet for E2E fixes
    prompt: "
      Role: spec-executor

      # 실패한 시나리오 로딩
      Skill(spec-scenario-loader {spec-folder} --failed)

      각 실패에 대해:
      1. 원인 분석 (스크린샷, 에러 메시지)
      2. 코드 수정
      3. 로컬 검증

      Output: .spec-it/execute/{sessionId}/logs/e2e-fix-{attempt}.md
    "
  )

  # Check for unit test regression
  Task(
    subagent_type: "Bash",
    model: "haiku",
    prompt: "
      Role: regression-checker

      npm run test 2>&1

      Return: [PASS] or [REGRESSION: {details}]
    "
  )

  IF regression detected:
    Task(spec-executor: fix regression)

  Update(_state.json)

IF _state.scenarioAttempts >= _state.maxScenarioAttempts AND _state.scenarioResults.failed > 0:
  AskUserQuestion(
    questions: [{
      question: "{_state.scenarioResults.failed} E2E tests still failing after 5 attempts.",
      header: "E2E Failed",
      options: [
        {label: "Fix manually", description: "I'll fix remaining failures"},
        {label: "Continue anyway", description: "Proceed to validation"},
        {label: "Abort", description: "Stop execution"}
      ]
    }]
  )

# Phase 7 complete
_state.completedPhases += "7"
_state.currentPhase = 8
_state.currentStep = "8.1"
Update(_state.json)

Output: "
Phase 7 Complete (SCENARIO-TEST)
- E2E attempts: {_state.scenarioAttempts}
- Final result: {_state.scenarioResults.passed}/{_state.scenarioResults.total} passed
- Moving to Validation phase
"
```

---

### Phase 8: VALIDATE (Final Review)

#### Step 8.1: Code Review
```
Task(
  subagent_type: "general-purpose",
  model: "opus",
  run_in_background: true,
  prompt: "
    Role: code-reviewer

    Review all changes in this session:
    - Spec: {spec-folder}/06-final/final-spec.md
    - Implementation: [list of changed files]

    Two-stage review:
    1. Spec compliance (must pass)
    2. Code quality (if stage 1 passes)

    Output: .spec-it/execute/{sessionId}/reviews/code-review.md

    OUTPUT RULES: (standard)
  "
)
```

#### Step 8.2: Security Review
```
Task(
  subagent_type: "general-purpose",
  model: "opus",
  run_in_background: true,
  prompt: "
    Role: security-reviewer

    Audit all new/modified files for:
    - OWASP Top 10 vulnerabilities
    - Hardcoded secrets
    - Input validation
    - Authentication/authorization

    Output: .spec-it/execute/{sessionId}/reviews/security-review.md

    OUTPUT RULES: (standard)
  "
)

# Wait for both reviews
Wait for background tasks

# Check verdicts
Read(.spec-it/execute/{sessionId}/reviews/code-review.md)
Read(.spec-it/execute/{sessionId}/reviews/security-review.md)

IF codeReview.verdict == "REQUEST CHANGES" OR securityReview.verdict == "FAIL":

  # Auto-fix critical issues
  Task(
    subagent_type: "general-purpose",
    model: "opus",
    prompt: "
      Role: spec-executor

      Fix CRITICAL and HIGH issues from reviews:
      - Code Review: {criticalIssues}
      - Security Review: {criticalIssues}

      OUTPUT RULES: (standard)
    "
  )

  # Re-run QA
  GOTO Phase 4

# Phase 8 complete
_state.completedPhases += "8"
_state.currentPhase = 9
_state.currentStep = "9.1"
Update(_state.json)
```

---

### Phase 9: COMPLETE

```
# Live Preview 정리
IF _state.livePreview OR _state.devServerPid:
  # 최종 스크린샷 캡처 (전체 화면 목록)
  FOR screen IN screens:
    MCP_CALL: navigate_page(url: _state.previewUrl + screen.route)
    MCP_CALL: wait_for(selector: "body", timeout: 3000)
    MCP_CALL: take_screenshot(
      path: ".spec-it/execute/{sessionId}/screenshots/final-{screen.name}.png"
    )

  # 브라우저 닫기
  MCP_CALL: close_page()

  # 개발 서버 종료
  Task(
    subagent_type: "Bash",
    model: "haiku",
    prompt: "kill {_state.devServerPid}"
  )

# Update final state
_state.status = "completed"
_state.completedAt = now()
Update(_state.json)

Output: "
════════════════════════════════════════════════════════════
                 SPEC-IT-EXECUTE COMPLETE
════════════════════════════════════════════════════════════

Session: {sessionId}
Duration: {duration}

Phase Summary:
- QA Attempts: {qaAttempts}
- Mirror Attempts: {mirrorAttempts} → {lastMirrorReport.missingCount == 0 ? 'PASS' : 'PARTIAL'}
- Coverage: {currentCoverage.lines}% (Target: {targetCoverage}%)
- E2E: {scenarioResults.passed}/{scenarioResults.total} passed

Files Created/Modified:
{fileList}

Reviews:
- Code Review: {verdict}
- Security Review: {verdict}

Logs: .spec-it/execute/{sessionId}/logs/
Reviews: .spec-it/execute/{sessionId}/reviews/
Screenshots: .spec-it/execute/{sessionId}/screenshots/

Next Steps:
1. Review generated code
2. Run manual testing
3. Create PR when ready

════════════════════════════════════════════════════════════
"

AskUserQuestion(
  questions: [{
    question: "Execution complete. What would you like to do with session files?",
    header: "Cleanup",
    options: [
      {label: "Keep", description: "Keep all session files"},
      {label: "Archive", description: "Move to .spec-it/archive/"},
      {label: "Delete", description: "Remove session files"}
    ]
  }]
)

IF Archive:
  Task(
    subagent_type: "Bash",
    model: "haiku",
    prompt: "Run: mv .spec-it/execute/{sessionId} .spec-it/archive/{sessionId}"
  )
ELIF Delete:
  Task(
    subagent_type: "Bash",
    model: "haiku",
    prompt: "Run: rm -rf .spec-it/execute/{sessionId}"
  )
```

---

## State File Schema

```json
{
  "sessionId": "20260130-143022",
  "specSource": "tmp/20260129-120000",
  "status": "in_progress | completed | failed",
  "currentPhase": 1-9,
  "currentStep": "1.1",
  "qaAttempts": 0,
  "maxQaAttempts": 5,
  "completedPhases": ["1", "2"],
  "completedTasks": ["T-001", "T-002"],
  "startedAt": "2026-01-30T14:30:22Z",
  "lastCheckpoint": "2026-01-30T14:45:00Z",
  "completedAt": null,
  "uiMode": "yaml",
  "livePreview": true,
  "devServerPid": 12345,
  "previewUrl": "http://localhost:3000",

  "mirrorAttempts": 0,
  "maxMirrorAttempts": 5,
  "lastMirrorReport": {
    "matchCount": 0,
    "missingCount": 0,
    "overCount": 0
  },

  "coverageAttempts": 0,
  "maxCoverageAttempts": 5,
  "targetCoverage": 95,
  "currentCoverage": {
    "statements": 0,
    "branches": 0,
    "functions": 0,
    "lines": 0
  },

  "scenarioAttempts": 0,
  "maxScenarioAttempts": 5,
  "scenarioResults": {
    "total": 0,
    "passed": 0,
    "failed": 0
  }
}
```

---

## Error Recovery

### Context Limit Reached
```
State auto-saved.

Resume command:
/frontend-skills:spec-it-execute --resume {sessionId}

Saved state:
- Phase: {currentPhase}
- Step: {currentStep}
- Completed: {completedTasks.length} tasks
```

### 3-Failure Circuit Breaker

If same error occurs 3 times:
1. Stop automatic fixing
2. Log detailed diagnostics
3. Ask user for guidance

---

## Loader Skill Integration

### Agent + Loader Skill 연동 패턴

```
┌─────────────────────────────────────────────────────────────────┐
│                  Agent + Loader Skill 연동                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Phase 5: SPEC-MIRROR                                            │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ Task(spec-mirror-analyst, opus):                           │ │
│  │   → Skill(spec-component-loader {spec-folder} --list)      │ │
│  │   → 실제 화면 캡처 및 비교                                   │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  Phase 6: UNIT-TEST                                              │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ Task(test-implementer, opus):                              │ │
│  │   Skill(spec-test-loader {spec-folder} --list)             │ │
│  │   Skill(spec-test-loader {spec-folder} --priority P0)      │ │
│  │   Skill(spec-test-loader {spec-folder} --coverage-gap)     │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  Phase 7: SCENARIO-TEST                                          │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │ Task(e2e-implementer, opus):                               │ │
│  │   Skill(spec-scenario-loader {spec-folder} --critical-path)│ │
│  │   Skill(spec-scenario-loader {spec-folder} --screen X)     │ │
│  │   Skill(spec-scenario-loader {spec-folder} --failed)       │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Related Skills

- `/frontend-skills:spec-it` - Spec generator router (mode selection)
- `/frontend-skills:spec-it-stepbystep` - Generate specs (Step-by-Step)
- `/frontend-skills:spec-it-complex` - Generate specs (Hybrid)
- `/frontend-skills:spec-it-automation` - Generate specs (Full Auto)
- `/frontend-skills:spec-mirror` - Spec vs Implementation comparison
- `/frontend-skills:spec-test-loader` - Progressive test spec loading
- `/frontend-skills:spec-scenario-loader` - Progressive scenario loading
- `/frontend-skills:spec-component-loader` - Progressive component spec loading
