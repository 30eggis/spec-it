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
  - **SCOPE COVERAGE (Critical)**: Does plan include ALL chapters and screens?
- If REJECT → Refine plan and re-validate
- If OKAY → Complete phase and proceed to Phase 3

### CRITICAL: Scope Verification in Phase 2

Before executing dev-pilot, Phase 2 MUST verify:

```yaml
scope_check:
  1_count_chapters:
    - Read: 01-chapters/chapter-plan-final.md
    - Extract: Total chapter count (e.g., CH-00 to CH-11 = 12 chapters)

  2_count_screens:
    - Read: 02-wireframes/screen-list.md
    - Extract: Total screen count + modal count

  3_verify_dev_plan:
    - Read: dev-plan/development-map.md
    - Verify: ALL chapters have corresponding tasks
    - Verify: ALL screens have implementation coverage
    - Verify: NO "MVP only" or "deferred" language

  4_reject_if:
    - chapters_in_plan < chapters_in_spec → REJECT
    - screens_in_plan < screens_in_spec → REJECT
    - any_priority_excluded → REJECT
    - mvp_scope_limitation_detected → REJECT
```

### Scope Rejection Example

```markdown
❌ SCOPE CHECK FAILED

Expected: 12 chapters (CH-00 to CH-11)
Found: 7 chapters (CH-00 to CH-06)
Missing: CH-07, CH-08, CH-09, CH-10, CH-11

Expected: 25 screens + 9 modals
Found: 14 screens
Missing: 11 screens (Settings, Reports, Company Rules, etc.)

ACTION: Regenerate dev-plan with FULL SCOPE
```
