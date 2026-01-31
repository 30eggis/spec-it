---
name: spec-it-execute
description: "Autopilot-style executor. Transforms spec-it specifications into working code with minimal intervention. 5-phase workflow: Load → Plan → Execute → QA → Validate."
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
argument-hint: "<spec-folder> [--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-execute: Autopilot Specification Executor

Transform spec-it specifications into **working code** with **autonomous execution** and **minimal user intervention**.

---

## Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    spec-it-execute                          │
├─────────────────────────────────────────────────────────────┤
│  Input: spec-it output (tmp/{sessionId}/06-final/)          │
│  Output: Working implementation with tests                   │
├─────────────────────────────────────────────────────────────┤
│  Phase 1: LOAD      → Load specs, validate completeness     │
│  Phase 2: PLAN      → Generate execution plan + critique    │
│  Phase 3: EXECUTE   → Implement with spec-executor          │
│  Phase 4: QA        → Build/test loop (max 5 cycles)        │
│  Phase 5: VALIDATE  → Code review + security audit          │
└─────────────────────────────────────────────────────────────┘
```

---

## Agents Used

| Agent | Model | Phase | Role |
|-------|-------|-------|------|
| `spec-critic` | Opus | 2 | Plan validation |
| `spec-executor` | Opus | 3 | Multi-file implementation |
| `code-reviewer` | Opus | 5 | Code quality review |
| `security-reviewer` | Opus | 5 | Security audit |
| `screen-vision` | Sonnet | 1 | Mockup analysis (if provided) |

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
| LOW | Haiku | Simple file reads, status checks |
| MEDIUM | Sonnet | Standard implementation tasks |
| HIGH | Opus | Complex multi-file changes, reviews |

**Rule:** Always pass `model` parameter explicitly to Task calls.

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
# 1. Generate session ID
sessionId = $(date +%Y%m%d-%H%M%S)

# 2. Create execution workspace
mkdir -p .spec-it/execute/{sessionId}/{plans,logs,reviews,screenshots}

# 3. Initialize state file (_status.json for dashboard)
Write(.spec-it/execute/{sessionId}/_status.json):
```

```json
{
  "sessionId": "{sessionId}",
  "specSource": "{spec-folder}",
  "status": "in_progress",
  "currentPhase": 1,
  "currentStep": "1.1",
  "qaAttempts": 0,
  "progress": 0,
  "agents": [],
  "startTime": "{ISO timestamp}",
  "lastUpdate": "{ISO timestamp}"
}
```

```bash
# 4. Launch dashboard in separate terminal
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/open-dashboard.sh .spec-it/execute/{sessionId}

# 5. Initialize _state.json for resume support
```

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
  "livePreview": false
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

IF _meta.uiMode == "stitch":
  # Stitch HTML 모드 - HTML 파일을 디자인 레퍼런스로 사용
  Task(
    subagent_type: "general-purpose",
    model: "sonnet",
    prompt: "
      Role: screen-vision

      Analyze Stitch HTML outputs in {spec-folder}/02-screens/html/

      Load:
      - stitch-project.json (screen metadata)
      - html/*.html (actual UI designs)
      - assets/styles.css (design system CSS)
      - assets/tokens.json (design tokens)

      Extract:
      1. HTML structure for each screen
      2. CSS classes and their styles
      3. Design tokens (colors, spacing, typography)
      4. Component patterns from HTML
      5. Responsive breakpoints

      Output: .spec-it/execute/{sessionId}/plans/html-analysis.md

      Include mapping table:
      | Screen | HTML File | Key Components | CSS Classes |
      |--------|-----------|----------------|-------------|

      OUTPUT RULES: (standard)
    "
  )

  # Save UI mode for spec-executor
  _state.uiMode = "stitch"
  _state.htmlReferencePath = "{spec-folder}/02-screens/html/"
  Update(_state.json)

ELIF mockups exist in {spec-folder}/02-screens/wireframes/:
  # ASCII Wireframe 모드
  Task(
    subagent_type: "general-purpose",
    model: "sonnet",
    prompt: "
      Role: screen-vision

      Analyze all wireframes in {spec-folder}/02-screens/wireframes/

      Extract:
      1. Component inventory
      2. Layout patterns
      3. Design tokens (colors, spacing, typography)

      Output: .spec-it/execute/{sessionId}/plans/visual-analysis.md

      OUTPUT RULES: (standard)
    "
  )

  _state.uiMode = "ascii"
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

#### Step 3.1: Execute Tasks (Sequential)
```
Read(.spec-it/execute/{sessionId}/plans/execution-plan.md)
tasks = parse_tasks(plan)

FOR task IN tasks (sorted by dependency):

  # Determine complexity for model routing
  complexity = assess_complexity(task)
  model = complexity == "HIGH" ? "opus" : "sonnet"

  # Build UI reference context based on mode
  IF _state.uiMode == "stitch":
    uiRefContext = "
      UI Reference Mode: STITCH (HTML)
      HTML Files: {_state.htmlReferencePath}
      Design System: {spec-folder}/02-screens/assets/styles.css
      Design Tokens: {spec-folder}/02-screens/assets/tokens.json

      CRITICAL: When implementing UI:
      1. Read corresponding HTML file for the screen
      2. Match HTML structure exactly in React components
      3. Use same CSS classes from styles.css
      4. Apply design tokens for colors, spacing
      5. Preserve accessibility attributes from HTML
    "
  ELSE:
    uiRefContext = "
      UI Reference Mode: ASCII (Wireframe)
      Wireframes: {spec-folder}/02-screens/wireframes/
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

  Task(
    subagent_type: "general-purpose",
    model: model,
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

  # Update progress
  _state.completedTasks += task.id
  _state.lastCheckpoint = now()
  Update(_state.json)

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

  # Diagnose and fix (needs general-purpose for file editing)
  Task(
    subagent_type: "general-purpose",
    model: "opus",
    prompt: "
      Role: spec-executor

      QA Failures (Attempt {_state.qaAttempts}/{maxQaAttempts}):

      {QA check results from previous task}

      Instructions:
      1. Analyze root cause of each failure
      2. Fix issues (prioritize: build → type → lint → test)
      3. Verify fix with same command
      4. Log all changes

      Output: .spec-it/execute/{sessionId}/logs/qa-{attempt}.md

      OUTPUT RULES:
      1. Write log to output path
      2. Return: 'Fixed {N} issues. Ready for re-check.'
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
        {label: "Continue anyway", description: "Proceed to validation"},
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

### Phase 5: VALIDATE (Final Review)

#### Step 5.1: Code Review
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

#### Step 5.2: Security Review
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

# Phase 5 complete
_state.status = "completed"
_state.completedPhases += "5"
_state.completedAt = now()
Update(_state.json)
```

---

### Phase 6: COMPLETE

```
# Live Preview 정리
IF _state.livePreview:
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

Output: "
════════════════════════════════════════════════════════════
                 SPEC-IT-EXECUTE COMPLETE
════════════════════════════════════════════════════════════

Session: {sessionId}
Duration: {duration}
QA Attempts: {qaAttempts}

Files Created/Modified:
{fileList}

Reviews:
- Code Review: {verdict}
- Security Review: {verdict}

Logs: .spec-it/execute/{sessionId}/logs/
Reviews: .spec-it/execute/{sessionId}/reviews/

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
  "currentPhase": 1-5,
  "currentStep": "1.1",
  "qaAttempts": 0,
  "maxQaAttempts": 5,
  "completedPhases": ["1", "2"],
  "completedTasks": ["T-001", "T-002"],
  "startedAt": "2026-01-30T14:30:22Z",
  "lastCheckpoint": "2026-01-30T14:45:00Z",
  "completedAt": null,
  "uiMode": "ascii | stitch",
  "htmlReferencePath": "tmp/{sessionId}/02-screens/html/",
  "livePreview": true,
  "devServerPid": 12345,
  "previewUrl": "http://localhost:3000"
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

## Related Skills

- `/frontend-skills:spec-it` - Spec generator router (mode selection)
- `/frontend-skills:spec-it-stepbystep` - Generate specs (Step-by-Step)
- `/frontend-skills:spec-it-complex` - Generate specs (Hybrid)
- `/frontend-skills:spec-it-automation` - Generate specs (Full Auto)
