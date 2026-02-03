# Critique Synthesis Format

> Referenced by: critic-analytics (exclusive)

## Purpose

Aggregates results from three parallel critics (logic, feasibility, frontend) into a unified synthesis with metrics and risk assessment.

---

## Output: critique-synthesis.md

```markdown
# Critique Synthesis Report

## Executive Summary

{{2-3 sentence summary of overall critique status}}

---

## Metrics Dashboard

### Issue Distribution

| Critic | Critical | Major | Minor | Total | Verdict |
|--------|----------|-------|-------|-------|---------|
| Logic | {{count}} | {{count}} | {{count}} | {{total}} | {{verdict}} |
| Feasibility | {{count}} | {{count}} | {{count}} | {{total}} | {{verdict}} |
| Frontend | {{count}} | {{count}} | {{count}} | {{total}} | {{verdict}} |
| **Total** | **{{sum}}** | **{{sum}}** | **{{sum}}** | **{{grand}}** | - |

### Risk Score

| Dimension | Score (1-10) | Weight | Weighted |
|-----------|--------------|--------|----------|
| Logic Consistency | {{score}} | 0.35 | {{weighted}} |
| Feasibility | {{score}} | 0.35 | {{weighted}} |
| Frontend Quality | {{score}} | 0.30 | {{weighted}} |
| **Overall Risk** | - | - | **{{total}}/10** |

### Confidence Level

| Level | Description |
|-------|-------------|
| {{level}} | {{description}} |

Levels: HIGH (>8), MEDIUM (5-8), LOW (<5)

---

## Priority Matrix

### Must Resolve (Blockers)

| ID | Source | Issue | Impact | Recommendation |
|----|--------|-------|--------|----------------|
| {{id}} | {{critic}} | {{issue}} | {{impact}} | {{rec}} |

### Should Resolve (Pre-P6)

| ID | Source | Issue | Impact | Recommendation |
|----|--------|-------|--------|----------------|
| {{id}} | {{critic}} | {{issue}} | {{impact}} | {{rec}} |

### Could Resolve (Post-P6)

| ID | Source | Issue | Impact | Recommendation |
|----|--------|-------|--------|----------------|
| {{id}} | {{critic}} | {{issue}} | {{impact}} | {{rec}} |

---

## Conflict Analysis

### Detected Conflicts

| ID | Topic | Logic Position | Feasibility Position | Frontend Position |
|----|-------|----------------|---------------------|-------------------|
| C-1 | {{topic}} | {{position}} | {{position}} | {{position}} |

### Resolution Suggestions

| Conflict ID | Suggested Resolution | Confidence | Rationale |
|-------------|---------------------|------------|-----------|
| C-1 | {{resolution}} | {{confidence}} | {{rationale}} |

---

## Cross-Critic Patterns

### Common Concerns

Issues raised by 2+ critics:

| Pattern | Critics | Chapters Affected | Severity |
|---------|---------|-------------------|----------|
| {{pattern}} | {{critics}} | {{chapters}} | {{severity}} |

### Unique Insights

Issues unique to each critic worth noting:

| Critic | Insight | Value |
|--------|---------|-------|
| Logic | {{insight}} | {{value}} |
| Feasibility | {{insight}} | {{value}} |
| Frontend | {{insight}} | {{value}} |

---

## Chapter Impact Analysis

| Chapter | Issues | Risk Level | Recommendation |
|---------|--------|------------|----------------|
| CH-00 | {{count}} | {{level}} | {{rec}} |
| CH-01 | {{count}} | {{level}} | {{rec}} |
| ... | ... | ... | ... |

---

## Action Items

### Immediate (Before P5)

1. [ ] {{action_1}}
2. [ ] {{action_2}}

### Deferred (Post-P6)

1. [ ] {{action_1}}
2. [ ] {{action_2}}

---

## Next Steps

| Condition | Action |
|-----------|--------|
| must_resolve > 0 AND step/comp mode | → critique-resolver (user input) |
| must_resolve > 0 AND auto mode | → critic-moderator (auto consensus) |
| must_resolve = 0 | → chapter-planner (P6) |

---

## Appendix: Raw Critique References

| Critic | File | Lines |
|--------|------|-------|
| Logic | `01-chapters/critique-logic.md` | {{lines}} |
| Feasibility | `01-chapters/critique-feasibility.md` | {{lines}} |
| Frontend | `01-chapters/critique-frontend.md` | {{lines}} |
```

---

## Metrics Calculation

### Risk Score Formula

```
overall_risk = (logic_score * 0.35) + (feasibility_score * 0.35) + (frontend_score * 0.30)

Where each score is calculated as:
- 10 = No issues
- 8-9 = Minor issues only
- 5-7 = Major issues, no critical
- 1-4 = Critical issues present
- 0 = Multiple critical blockers
```

### Confidence Level

```
HIGH: All critics agree, no conflicts, risk < 3
MEDIUM: Minor conflicts, risk 3-6
LOW: Major conflicts, risk > 6, or incomplete data
```

---

## Validation Rules

1. All three critic outputs must be processed
2. Every issue must be categorized (must/should/could)
3. Conflicts must have resolution suggestions
4. Risk scores must sum correctly
5. Chapter impact must cover all chapters
