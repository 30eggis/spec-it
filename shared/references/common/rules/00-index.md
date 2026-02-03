# Spec-It Rules Reference (Progressive Load)

Load order is intentional. Each file is under 400 lines.

0) `shared/references/common/rules/05-vercel-skills.md` ← **MUST LOAD FIRST** (submodule init)
1) `shared/references/common/rules/10-core-safety.md`
2) `shared/references/common/rules/20-state-role-auth.md`
3) `shared/references/common/rules/30-ui-ssr-time.md`
4) `shared/references/common/rules/40-test-checklists.md`
5) `shared/references/common/rules/50-question-policy.md`

Usage:
- Include the rule keywords in spec-it or spec-it-execute prompts.
- Enforce failure conditions during execute.
- Add tests listed in the checklists when touching related code.

Template (example):
```
[spec-it] rules: BOUNDARY_GUARD, CLAMP_RANGE, STATE_SYNC
[spec-it-execute] enforce: ROLE_FILTER_RECURSIVE, DOM_MEASURE_RESYNC
```
