# Phase 4: QA (Hard Gate)

## Step 1: Automated QA
- Run lint, type-check, test, build via `scripts/qa/run-qa.sh`
- Auto-detect package manager and scripts
- Any failure blocks advancement
- After max attempts, stop and set waiting state

## Step 2: Code Review (after Step 1 passes)
- **Invoke code-reviewer agent** for two-stage review:
  - Stage 1: Spec Compliance
    - Verify ALL requirements implemented
    - Check for missing functionality
    - Check for extra (unspecified) functionality
  - Stage 2: Code Quality (only if Stage 1 passes)
    - Security analysis
    - Code quality metrics
    - Performance review
    - Best practices check
- If CRITICAL/HIGH issues → Block advancement, fix and re-run QA
- If MEDIUM/LOW only → Proceed with warnings logged

## Script

```
$HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/qa/run-qa.sh "$(pwd)"
```
