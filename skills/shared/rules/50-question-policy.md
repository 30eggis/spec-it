# Question Policy and Automation Rules

Purpose: minimize questions while preserving quality and risk controls.

## Policy Levels
- Confirm: ask at major gates and when total_score >= 4
- Hybrid: ask on hard stops or when total_score >= 7
- Auto: ask only on hard stops

## Hard Stops (Always Ask)
- secrets_required
- destructive_data
- compliance_or_security_risk
- production_change

## Risk Scoring
Dimensions: ambiguity, impact, irreversible, compliance, cost (1..5)
Total score = sum of dimensions

## Rule Format
- id
- when (boolean)
- add (dimension weights)
- action (optional)

## Core Rules

### Ambiguity
- R-A01: ambiguous terms detected -> ambiguity +2
- R-A02: missing KPI or SLO -> ambiguity +3
- R-A03: actor/owner undefined -> ambiguity +2

### Architecture / Impact
- R-AR01: requires SSR vs SPA decision -> impact +3
- R-AR02: state or data source change -> impact +2
- R-AR03: new infra or external service -> cost +2

### Risk / Irreversible
- R-R01: data migration or delete -> irreversible +5 (hard stop)
- R-R02: PII, payment, or auth -> compliance +5 (hard stop)
- R-R03: public API breaking change -> impact +3

### Frontend Constraints
- R-F01: heavy animation or render -> impact +2
- R-F02: accessibility requirement conflict -> compliance +2
- R-F03: browser support undefined -> ambiguity +2

## Profile Mapping

- spec-it-stepbystep: level=confirm, threshold=4, budget per_stage=2 total=8
- spec-it-complex: level=hybrid, threshold=7, budget per_stage=1 total=4
- spec-it-automation: level=auto, threshold=999, budget per_stage=0 total=0
- spec-it-fast-launch: level=auto, threshold=999, budget per_stage=0 total=0

## Stage Rules (Example)

```yaml
stage_rules:
  design-interviewer:
    inputs: [requirements_text]
    auto_extract: [actors, goals, constraints]
    rules:
      - id: DI-A01
        when: "actors_missing == true"
        add: { ambiguity: 2 }
      - id: DI-A02
        when: "goals_missing == true"
        add: { ambiguity: 3 }
      - id: DI-A03
        when: "constraints_missing == true"
        add: { ambiguity: 2 }
    outputs: [actors, goals, constraints]

  divergent-thinker:
    inputs: [goals, constraints]
    auto_generate:
      idea_branches: 2
    rules:
      - id: DT-AR01
        when: "branch_count < 2"
        action: "generate_more"
      - id: DT-AR02
        when: "branch_count > 3"
        action: "prune_to_top3"
    outputs: [idea_branches, quick_scores]

  critic-logic/feasibility/frontend:
    inputs: [idea_branches, constraints]
    rules:
      - id: CLF-L01
        when: "logic_gap_found == true"
        add: { ambiguity: 2 }
      - id: CLF-F01
        when: "frontend_constraint_risk == true"
        add: { impact: 2 }
      - id: CLF-Fe01
        when: "feasibility_low == true"
        add: { impact: 2 }
    outputs: [risk_notes, feasibility_flags]

  critic-moderator:
    inputs: [risk_notes, feasibility_flags]
    rules:
      - id: CM-M01
        when: "conflicting_critic_notes == true"
        action: "merge_and_rank"
      - id: CM-M02
        when: "top_risk_count > 5"
        action: "trim_to_top3"
    outputs: [ranked_risks]

  chapter-planner:
    inputs: [requirements_text, ranked_risks]
    rules:
      - id: CP-C01
        when: "section_overlap_detected == true"
        action: "merge_sections"
      - id: CP-C02
        when: "required_section_missing == true"
        add: { ambiguity: 2 }
    outputs: [doc_outline]

  ui-architect:
    inputs: [doc_outline, constraints]
    defaults:
      layout: "standard_frame"
      components: "library_first"
    rules:
      - id: UI-AR01
        when: "requires_ssr_spa_decision == true"
        add: { impact: 3 }
      - id: UI-AR02
        when: "layout_customization_high == true"
        add: { cost: 2 }
      - id: UI-A11Y
        when: "a11y_conflict == true"
        add: { compliance: 2 }
    outputs: [ui_structure, component_map]

  component-auditor:
    inputs: [changed_files, component_map]
    rules:
      - id: CA-S01
        when: "changed_files == 0"
        action: "skip_full_scan"
      - id: CA-S02
        when: "impact_scope_large == true"
        add: { impact: 2 }
      - id: CA-S03
        when: "cache_hit == true"
        action: "use_cached_metadata"
    outputs: [audit_report, impacted_components]

  critical-reviewer/ambiguity-detector:
    inputs: [doc_outline, requirements_text]
    rules:
      - id: CR-A01
        when: "ambiguous_terms_detected == true"
        add: { ambiguity: 2 }
      - id: CR-A02
        when: "missing_kpi_or_slo == true"
        add: { ambiguity: 3 }
      - id: CR-A03
        when: "ownership_undefined == true"
        add: { ambiguity: 2 }
    outputs: [ambiguity_list, clarification_candidates]

  persona-architect/test-spec-writer:
    inputs: [actors, ranked_risks]
    rules:
      - id: PT-P01
        when: "persona_count > 2"
        action: "prune_to_top2"
      - id: PT-T01
        when: "test_cases > 5"
        action: "sample_top_risk"
    outputs: [personas, test_cases]

  spec-assembler:
    inputs: [doc_outline, ui_structure, test_cases, audit_report]
    rules:
      - id: SA-M01
        when: "duplicate_sections_detected == true"
        action: "dedupe"
      - id: SA-L01
        when: "section_link_missing == true"
        action: "auto_link"
    outputs: [final_spec_document]
```
