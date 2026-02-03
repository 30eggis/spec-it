# Phase 0–2: Initialize, Load, Plan

## Phase 0: Initialize

- Initialize session with `scripts/core/execute-session-init.sh`
- If dashboard enabled, show absolute file path for web dashboard:
  `"⏺ Dashboard:  file://$HOME/.claude/plugins/marketplaces/claude-frontend-skills/web-dashboard/index.html  을 열어 실시간 진행 상황을 확인할 수 있습니다."`
  (URL 앞뒤 공백 필수 - 터미널에서 클릭 시 분리되도록)
- If `--resume`, load saved state and resume

## Phase 1: Load

- Validate spec files exist
- Extract task list from `dev-tasks.md`
- Analyze UI references (wireframes, design tokens)

## Phase 2: Plan

- Generate execution plan
- **Validate with spec-dev-plan-critic agent**:
  - Clarity: Is each task unambiguous?
  - Verifiability: Does each task have measurable success criteria?
  - Completeness: Is 90%+ context present to execute?
  - Big Picture: Does the plan explain WHY/WHAT/HOW?
- If REJECT → Refine plan and re-validate
- If OKAY → Complete phase and proceed to Phase 3
