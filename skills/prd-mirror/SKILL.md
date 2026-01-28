---
name: prd-mirror
description: |
  Compare original PRD against actual implementation to verify spec compliance.
  Integrates with hack-2-prd skill to reverse-engineer PRD from codebase and compare.
  Use when reviewing implementation for over-spec features or missing requirements.
---

# PRD Mirror

Compare original PRD against implementation to identify over-spec/missing items.

## Workflow

```
[Original PRD] + [Codebase]
       ↓
[Generate reverse-engineered PRD via hack-2-prd]
       ↓
[Ask language preference]
       ↓
[Compare REQ items]
       ↓
[Generate report]
```

## Step 1: Confirm Inputs

Gather from user:

| Input | Description | Example |
|-------|-------------|---------|
| Original PRD | Requirements doc written before development | `docs/PRD.md` |
| Codebase | Implemented project path | `./my-project` |

## Step 2: Generate Reverse-Engineered PRD

Use hack-2-prd skill to analyze codebase:

1. Analyze codebase using hack-2-prd's "Code Analysis" method
2. Generate reverse-engineered PRD (temp path: `docs/_mirror/PRD.md`)
3. Extract requirements in same REQ-### format as original PRD

## Step 3: Ask Language Preference

Before generating report, ask user which language to use:

```
Which language would you like the report to be written in?
- English
- Korean (한국어)
- Other (please specify)
```

Store the preference and apply to the generated report.

## Step 4: Compare PRDs

Compare REQ items between original and reverse-engineered PRD:

### Comparison Criteria

| Category | Definition | Identification |
|----------|------------|----------------|
| **Match** | Original REQ properly implemented | Same/similar REQ exists in reverse PRD |
| **Missing** | Original REQ not implemented | No corresponding REQ in reverse PRD |
| **Over-spec** | Feature implemented without PRD | REQ exists only in reverse PRD |

### Matching Method

1. Direct match by REQ ID if available
2. Semantic matching by feature description if no ID
3. Mark as "Review needed" if low confidence

## Step 5: Generate Report

Use `assets/templates/MIRROR_REPORT_TEMPLATE.md` template.

Report structure:
- Summary (count of match/missing/over-spec)
- Detailed analysis (each item with explanation)
- Checklist (action items)

**Output:** `docs/MIRROR_REPORT.md`

## Usage Example

```
User: Review implementation against PRD
Assistant: Please provide the original PRD path and codebase path.

User: PRD is docs/PRD.md, code is current folder
Assistant: Which language for the report? [English/Korean/Other]

User: Korean
Assistant: [reverse-engineer via hack-2-prd] → [compare] → [generate report in Korean]
```

## Templates

- `assets/templates/MIRROR_REPORT_TEMPLATE.md` - Comparison report template
