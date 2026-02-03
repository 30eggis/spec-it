---
name: spec-mirror
description: |
  Compare original Spec against actual implementation to verify spec compliance.
  Integrates with hack-2-spec skill to reverse-engineer Spec from codebase and compare.
  Use when reviewing implementation for over-spec features or missing requirements.
permissionMode: bypassPermissions
---

# Spec Mirror

Compare original Spec against implementation to identify over-spec/missing items.

## Workflow

```
[Original Spec] + [Codebase]
       ↓
[Generate reverse-engineered Spec via hack-2-spec]
       ↓
[Ask language preference]
       ↓
[Compare REQ items]
       ↓
[Generate report]
```

## Step 0: Initialize Vercel Skills (Auto)

**CRITICAL:** Before comparison, ensure Vercel agent-skills submodule is available for accurate layout analysis.

```bash
# Auto-initialize submodule
if [ ! -f "docs/refs/agent-skills/README.md" ]; then
  git submodule update --init --recursive docs/refs/agent-skills 2>/dev/null || echo "Warning: Could not init submodule"
fi
```

**Reference:** `skills/shared/rules/05-vercel-skills.md` for Tailwind layout mapping.

---

## Step 1: Confirm Inputs

Gather from user:

| Input | Description | Example |
|-------|-------------|---------|
| Original Spec | Requirements doc written before development | `docs/SPEC.md` |
| Codebase | Implemented project path | `./my-project` |

## Step 2: Generate Reverse-Engineered Spec

Use hack-2-spec skill to analyze codebase:

1. Analyze codebase using hack-2-spec's "Code Analysis" method
2. Generate reverse-engineered Spec (temp path: `docs/_mirror/SPEC.md`)
3. Extract requirements in same REQ-### format as original Spec

## Step 3: Ask Language Preference

Before generating report, ask user which language to use:

```
Which language would you like the report to be written in?
- English
- Korean (한국어)
- Other (please specify)
```

Store the preference and apply to the generated report.

## Step 4: Compare Specs

Compare REQ items between original and reverse-engineered Spec:

### Comparison Criteria

| Category | Definition | Identification | Verdict |
|----------|------------|----------------|---------|
| **Match** | Original REQ properly implemented | Same/similar REQ exists in reverse Spec | PASS |
| **Missing** | Original REQ not implemented | No corresponding REQ in reverse Spec | FAIL |
| **Over-spec** | Feature implemented without Spec | REQ exists only in reverse Spec | PASS (허용) |

### Over-spec 허용 정책

> **중요:** Over-spec 항목은 FAIL이 아닙니다.
> - Spec에 없지만 구현된 추가 기능은 허용됩니다
> - Missing 항목만이 실패 조건입니다
> - Over-spec은 정보 제공 목적으로 리포트에 포함됩니다

### Matching Method

1. Direct match by REQ ID if available
2. Semantic matching by feature description if no ID
3. Mark as "Review needed" if low confidence

## Step 5: Generate Report

Use `assets/templates/MIRROR_REPORT_TEMPLATE.md` template.

Report structure:
- Summary (count of match/missing/over-spec)
- Detailed analysis (each item with explanation)
- Verdict (PASS if missing_count == 0, regardless of over-spec count)
- Checklist (action items for missing items only)

**Output:** `docs/MIRROR_REPORT.md`

## Verdict Rules

```
IF missing_count == 0:
  verdict = "PASS"
  message = "모든 Spec이 구현되었습니다. (over-spec {N}건 허용)"
ELSE:
  verdict = "FAIL"
  message = "누락된 요구사항 {N}건이 있습니다."
```

## Usage Example

```
User: Review implementation against Spec
Assistant: Please provide the original Spec path and codebase path.

User: Spec is docs/SPEC.md, code is current folder
Assistant: Which language for the report? [English/Korean/Other]

User: Korean
Assistant: [reverse-engineer via hack-2-spec] → [compare] → [generate report in Korean]
```

## Integration with spec-it-execute

When called from spec-it-execute Phase 5:

1. **Input**: spec-folder path (from _state.specSource)
2. **Action**: Compare implementation against original spec
3. **Output**: MIRROR_REPORT with match/missing/over-spec counts
4. **Return**: `{ matchCount, missingCount, overCount, verdict }`

```
# spec-it-execute Phase 5 호출 패턴
Skill(spec-mirror {spec-folder} --codebase .)

# 결과 확인
IF missingCount > 0:
  → 누락 항목 재개발 → Phase 4 QA → Phase 5 재검증
ELSE:
  → Phase 6 진행 (over-spec은 허용)
```

## Templates

- `assets/templates/MIRROR_REPORT_TEMPLATE.md` - Comparison report template
