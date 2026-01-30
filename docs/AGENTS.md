# Agents Reference

This plugin includes 23+ specialized agents for different tasks.

## Design & Planning

| Agent | Model | Role |
|-------|-------|------|
| `design-interviewer` | Opus | Brainstorming Q&A facilitator |
| `divergent-thinker` | Sonnet | Alternative exploration, creative thinking |
| `chapter-planner` | Opus | Final chapter structure decisions |
| `ui-architect` | Sonnet | ASCII wireframe design |

---

## Multi-Agent Debate (Critic System)

Three critics review in parallel, then a moderator synthesizes:

```
┌─────────────┬─────────────┬─────────────┐
│critic-logic │critic-feasi.│critic-front.│  ← Parallel
└──────┬──────┴──────┬──────┴──────┬──────┘
       └─────────────┼─────────────┘
                     ▼
             critic-moderator              ← Synthesize
```

| Agent | Model | Focus Area |
|-------|-------|------------|
| `critic-logic` | Sonnet | Logic consistency, duplicates, dependencies |
| `critic-feasibility` | Sonnet | Feasibility, completion criteria, testability |
| `critic-frontend` | Sonnet | UI/UX, component reuse, responsive/a11y |
| `critic-moderator` | Opus | Consensus, conflict resolution, final verdict |

---

## Component Agents

| Agent | Model | Role |
|-------|-------|------|
| `component-auditor` | Haiku | Scan existing components, create inventory |
| `component-builder` | Sonnet | Write new component specs |
| `component-migrator` | Sonnet | Plan component migrations |

---

## Review Agents

| Agent | Model | Role |
|-------|-------|------|
| `critical-reviewer` | Opus | Scenario/IA/exception review |
| `ambiguity-detector` | Opus | Detect ambiguities, generate questions |
| `spec-critic` | Opus | Validate execution plans (4 pillars) |

---

## Test Agents

| Agent | Model | Role |
|-------|-------|------|
| `persona-architect` | Sonnet | Define user personas |
| `test-spec-writer` | Sonnet | Write TDD test specs, 80%+ coverage |

---

## Execution Agents

| Agent | Model | Role |
|-------|-------|------|
| `spec-executor` | Opus | Multi-file implementation, HTML reference support |
| `code-reviewer` | Opus | 2-stage code review (spec compliance → quality) |
| `security-reviewer` | Opus | OWASP Top 10 security audit |
| `screen-vision` | Sonnet | Screenshot/mockup analysis |

---

## Utility Agents

| Agent | Model | Role |
|-------|-------|------|
| `spec-assembler` | Haiku | Final document assembly |
| `spec-md-generator` | Haiku | Generate SPEC-IT files |
| `spec-md-maintainer` | Haiku | Maintain SPEC-IT files |

---

## Model Selection Guide

| Complexity | Model | When to Use |
|------------|-------|-------------|
| LOW | Haiku | File scans, status checks, simple assembly |
| MEDIUM | Sonnet | Standard implementation, UI design |
| HIGH | Opus | Complex reasoning, critical decisions |
