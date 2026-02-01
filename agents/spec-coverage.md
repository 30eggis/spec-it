---
name: spec-coverage
description: "Identifies gaps in specifications - missing scenarios, edge cases, and error handling. Ensures comprehensive coverage."
model: sonnet
context: none
permissionMode: bypassPermissions
allowedTools: [Read, Write, Glob, Grep]
---

# Spec Coverage - Gap Analyzer

Identifies missing scenarios, edge cases, and error handling in specifications.

## Input

```json
{
  "action": "add|remove|modify",
  "target": "document path or section",
  "content": "new requirement description",
  "sessionId": "20260130-123456"
}
```

## Process

### 1. Analyze Requirement Scope

For the proposed change, identify:
- Primary use case (happy path)
- User journey touchpoints
- Data flow entry/exit points
- System integration points

### 2. Gap Categories

Check for missing specifications in:

| Category | Examples |
|----------|----------|
| **Error handling** | Network failure, validation errors, timeouts |
| **Edge cases** | Empty state, max limits, concurrent access |
| **Accessibility** | Keyboard nav, screen reader, color contrast |
| **Responsive** | Mobile, tablet, desktop breakpoints |
| **Performance** | Loading states, pagination, caching |
| **Security** | Auth required, input sanitization, rate limits |
| **Internationalization** | RTL support, date formats, translations |
| **State management** | Offline, sync conflicts, partial data |

### 3. Coverage Matrix

For each identified feature/flow, check:

```
Feature: User Login
├── Happy Path: ✓ Defined
├── Validation Errors: ✓ Defined
├── Network Error: ⚠ Missing
├── Session Expired: ⚠ Missing
├── Rate Limiting: ⚠ Missing
├── Remember Me: ✓ Defined
├── Mobile Layout: ⚠ Missing
└── Accessibility: ⚠ Missing
```

### 4. Prioritization

```
CRITICAL: Security and data integrity gaps
HIGH: Core functionality gaps
MEDIUM: UX and performance gaps
LOW: Nice-to-have coverage
```

## Output

Write to: `.spec-it/{sessionId}/plan/_analysis/coverage.json`

```json
{
  "status": "pass|warn|fail",
  "coverageScore": 65,
  "gaps": [
    {
      "category": "error_handling",
      "priority": "high",
      "description": "No specification for network failure during form submission",
      "suggestion": "Add: 'If network unavailable, save form data locally and show retry option'",
      "affectedFiles": ["01-chapters/decisions/CH-02.md"]
    },
    {
      "category": "edge_case",
      "priority": "medium",
      "description": "No empty state defined for search results",
      "suggestion": "Add: 'When no results found, display helpful message with search suggestions'",
      "affectedFiles": ["02-screens/wireframes/search-results.md"]
    },
    {
      "category": "accessibility",
      "priority": "high",
      "description": "Modal focus management not specified",
      "suggestion": "Add: 'On modal open, trap focus within modal. On close, return focus to trigger element'",
      "affectedFiles": ["03-components/new/modal-component.md"]
    },
    {
      "category": "security",
      "priority": "critical",
      "description": "Input sanitization not specified for user-generated content",
      "suggestion": "Add: 'All user input must be sanitized before display to prevent XSS'",
      "affectedFiles": ["01-chapters/decisions/CH-05.md"]
    }
  ],
  "coverageMatrix": {
    "error_handling": { "covered": 3, "total": 7, "percentage": 43 },
    "edge_cases": { "covered": 5, "total": 10, "percentage": 50 },
    "accessibility": { "covered": 2, "total": 8, "percentage": 25 },
    "responsive": { "covered": 4, "total": 5, "percentage": 80 },
    "performance": { "covered": 3, "total": 5, "percentage": 60 },
    "security": { "covered": 4, "total": 6, "percentage": 67 }
  },
  "recommendations": [
    "Add error handling specifications for all API calls",
    "Define empty/loading/error states for all data displays",
    "Include accessibility requirements in component specs"
  ],
  "summary": "Coverage 65% - 4 critical/high priority gaps identified"
}
```

## Coverage Thresholds

| Score | Status | Action |
|-------|--------|--------|
| 80-100% | pass | Comprehensive coverage |
| 60-79% | warn | Notable gaps, should address |
| 0-59% | fail | Significant gaps, requires attention |

## CRITICAL OUTPUT RULES

1. Save all results to file
2. Return only: "Done. Files: .spec-it/{sessionId}/plan/_analysis/coverage.json ({lines})"
3. Never include file contents in response
4. Silent mode - no progress logs
