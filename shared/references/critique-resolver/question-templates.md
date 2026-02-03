# Critique Resolver Question Templates

> Referenced by: critique-resolver (exclusive)

## Purpose

Templates for presenting critique issues to users for resolution in step-by-step and complex modes.

---

## Question Structure

### Single Issue Question

```
{
  question: "{{issue_title}}: {{brief_description}}?",
  header: "{{category}}",  // max 12 chars: "Scope", "Data Flow", "Auth", etc.
  options: [
    {
      label: "{{option_1}} (Recommended)",
      description: "{{detailed_explanation_of_option_1}}"
    },
    {
      label: "{{option_2}}",
      description: "{{detailed_explanation_of_option_2}}"
    },
    {
      label: "{{option_3}}",
      description: "{{detailed_explanation_of_option_3}}"
    },
    {
      label: "Defer",
      description: "Address in later phase"
    }
  ],
  multiSelect: false
}
```

### Multi-Select Issue Question

```
{
  question: "Which {{category}} issues should be prioritized?",
  header: "Priority",
  options: [
    {label: "{{issue_1}}", description: "{{impact}}"},
    {label: "{{issue_2}}", description: "{{impact}}"},
    {label: "{{issue_3}}", description: "{{impact}}"}
  ],
  multiSelect: true
}
```

---

## Category-Specific Templates

### Logic Consistency Issues

**Scope Overlap:**
```
{
  question: "Chapters {{ch_a}} and {{ch_b}} both cover {{topic}}. How should we separate?",
  header: "Scope",
  options: [
    {label: "Keep in {{ch_a}}", description: "{{ch_b}} will reference {{ch_a}}"},
    {label: "Keep in {{ch_b}}", description: "{{ch_a}} will reference {{ch_b}}"},
    {label: "Split by {{criteria}}", description: "Divide based on {{criteria}}"},
    {label: "Merge chapters", description: "Combine into single chapter"}
  ]
}
```

**Coverage Gap:**
```
{
  question: "{{requirement}} is not covered by any chapter. Where should it belong?",
  header: "Coverage",
  options: [
    {label: "Add to {{ch_suggested}}", description: "Best fit based on scope"},
    {label: "Create new chapter", description: "Significant enough for own chapter"},
    {label: "Out of scope", description: "Exclude from MVP"},
    {label: "Defer to Phase 2", description: "Address post-MVP"}
  ]
}
```

**Dependency Order:**
```
{
  question: "{{ch_a}} depends on {{ch_b}}, but {{ch_b}} comes later. How to resolve?",
  header: "Dependency",
  options: [
    {label: "Reorder chapters", description: "Move {{ch_b}} before {{ch_a}}"},
    {label: "Extract shared", description: "Create shared foundation chapter"},
    {label: "Decouple", description: "Remove dependency with {{approach}}"}
  ]
}
```

### Feasibility Issues

**Technical Complexity:**
```
{
  question: "{{feature}} may be too complex for MVP. How to proceed?",
  header: "Complexity",
  options: [
    {label: "Simplify (Recommended)", description: "Reduce to {{simplified_version}}"},
    {label: "Keep as is", description: "Accept higher development cost"},
    {label: "Phase 2", description: "Defer to post-MVP"},
    {label: "Alternative approach", description: "Use {{alternative}}"}
  ]
}
```

**Resource Constraint:**
```
{
  question: "{{feature}} requires {{resource}} not currently available. How to handle?",
  header: "Resource",
  options: [
    {label: "Add resource", description: "Acquire {{resource}}"},
    {label: "Workaround", description: "Use {{alternative}} instead"},
    {label: "Defer", description: "Wait until resource available"},
    {label: "Remove feature", description: "Exclude from scope"}
  ]
}
```

### Frontend Issues

**Component Reuse:**
```
{
  question: "{{component}} appears in {{count}} screens with variations. Standardize?",
  header: "Component",
  options: [
    {label: "Single variant", description: "Use {{recommended_variant}} everywhere"},
    {label: "Variant system", description: "Create {{count}} documented variants"},
    {label: "Per-screen custom", description: "Keep variations (higher cost)"}
  ]
}
```

**Responsive Design:**
```
{
  question: "{{screen}} has complex layout. How to handle mobile?",
  header: "Responsive",
  options: [
    {label: "Simplified mobile", description: "Reduce features on mobile"},
    {label: "Full parity", description: "All features on all devices"},
    {label: "Desktop only", description: "No mobile support for this screen"},
    {label: "Mobile-first redesign", description: "Redesign for mobile priority"}
  ]
}
```

**Accessibility:**
```
{
  question: "{{interaction}} may have accessibility issues. How to address?",
  header: "A11y",
  options: [
    {label: "Fix now (Recommended)", description: "Add {{a11y_fix}}"},
    {label: "Alternative interaction", description: "Use {{accessible_alternative}}"},
    {label: "Document limitation", description: "Note as known limitation"}
  ]
}
```

---

## Conflict Resolution Templates

**Two Critics Disagree:**
```
{
  question: "{{critic_a}} suggests {{suggestion_a}}, but {{critic_b}} suggests {{suggestion_b}}. Which approach?",
  header: "Conflict",
  options: [
    {label: "{{critic_a}} approach", description: "Prioritize {{priority_a}}"},
    {label: "{{critic_b}} approach", description: "Prioritize {{priority_b}}"},
    {label: "Hybrid", description: "{{hybrid_approach}}"},
    {label: "Need more info", description: "Investigate before deciding"}
  ]
}
```

**Three Critics Disagree:**
```
{
  question: "All critics have different views on {{topic}}. Select preferred approach:",
  header: "3-Way",
  options: [
    {label: "Logic-first", description: "{{logic_approach}}"},
    {label: "Feasibility-first", description: "{{feasibility_approach}}"},
    {label: "UX-first", description: "{{frontend_approach}}"},
    {label: "Custom balance", description: "Specify custom approach"}
  ]
}
```

---

## Batch Question Template

For multiple related issues:

```
{
  questions: [
    {
      question: "How should we handle {{category}} issues?",
      header: "{{category}}",
      options: [...],
      multiSelect: false
    },
    {
      question: "Which {{category}} items to prioritize?",
      header: "Priority",
      options: [...],
      multiSelect: true
    }
  ]
}
```

---

## Response Processing

### Recording User Decisions

```markdown
## Decision Record

| Question ID | Category | User Choice | Applied To |
|-------------|----------|-------------|------------|
| Q-001 | Scope | Option 1 | CH-02, CH-05 |
| Q-002 | Complexity | Simplify | Feature X |

## Impact

- Chapters modified: {{list}}
- Features deferred: {{list}}
- New constraints: {{list}}
```

---

## Validation Rules

1. Maximum 4 questions per batch
2. Maximum 4 options per question
3. Header must be ≤12 characters
4. Every option must have description
5. "Defer" option required for non-critical issues
