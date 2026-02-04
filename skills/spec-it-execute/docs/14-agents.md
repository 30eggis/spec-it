# Agents

## Plan Mode (TDD)
테스트 시나리오 생성용 (04-scenarios/)

| Agent | Model | Description |
|-------|-------|-------------|
| tdd-guide | sonnet | TDD specialist for test scenario generation |
| tdd-guide-low | haiku | Quick test suggestion (READ-ONLY advisory) |

## Phase 2: Plan
- spec-dev-plan-critic (execution plan validation)

## Phase 3: Execute (via dev-pilot skill)

### Skill
- **dev-pilot** - Parallel autopilot with file ownership partitioning

### Agents (spawned by dev-pilot)
| Agent | Model | Description |
|-------|-------|-------------|
| dev-executor-low | haiku | Simple single-file tasks, type fixes |
| dev-executor | sonnet | Standard feature implementation |
| dev-executor-high | opus | Complex multi-file architecture |
| dev-build-fixer | sonnet | Build/type error resolution |
| dev-architect | opus | Spec compliance verification (READ-ONLY) |

## Phase 4: Bringup
- dev-build-fixer (lint/typecheck/build 에러 자동 수정)

## Phase 5: Spec-Mirror
- spec-mirror skill (Spec 준수 검증)

## Phase 6: Unit Tests

### Skill
- **ultraqa** (unit mode)

### Agents
| Agent | Model | Description |
|-------|-------|-------------|
| qa-tester | sonnet | 표준 단위 테스트 작성/실행 (tmux) |
| qa-tester-high | opus | 복잡한 테스트, 보안/성능 검증 |

## Phase 7: E2E

### Skill
- **ultraqa** (e2e mode)

### Agents
| Agent | Model | Description |
|-------|-------|-------------|
| qa-tester-high | opus | E2E 테스트 작성/실행 (Playwright/Cypress) |

## Phase 8: Validate
- code-reviewer (Spec compliance + Code quality 2-stage review, **Vercel Best Practices**)
- security-reviewer (Security audit)

## Agent Summary Table

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         AGENT CATALOG                                   │
├─────────────────┬────────┬──────────────────────────────────────────────┤
│ Agent           │ Model  │ Phase / Purpose                              │
├─────────────────┼────────┼──────────────────────────────────────────────┤
│ tdd-guide       │ sonnet │ Plan: Test scenario generation               │
│ tdd-guide-low   │ haiku  │ Plan: Quick test suggestions (READ-ONLY)     │
├─────────────────┼────────┼──────────────────────────────────────────────┤
│ dev-executor-low│ haiku  │ Phase 3: Simple single-file tasks            │
│ dev-executor    │ sonnet │ Phase 3: Standard feature implementation     │
│ dev-executor-high│ opus  │ Phase 3: Complex multi-file architecture     │
│ dev-build-fixer │ sonnet │ Phase 3/4: Build/type error resolution       │
│ dev-architect   │ opus   │ Phase 3: Spec compliance (READ-ONLY)         │
├─────────────────┼────────┼──────────────────────────────────────────────┤
│ qa-tester       │ sonnet │ Phase 6: Unit tests (tmux)                   │
│ qa-tester-high  │ opus   │ Phase 6/7: Comprehensive tests, E2E          │
├─────────────────┼────────┼──────────────────────────────────────────────┤
│ code-reviewer   │ opus   │ Phase 8: 2-stage review + Vercel Best Practices│
│ security-reviewer│ opus  │ Phase 8: Security audit                      │
└─────────────────┴────────┴──────────────────────────────────────────────┘
```

## Skill Summary Table

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         SKILL CATALOG                                   │
├─────────────────┬──────────────────────────────────────────────────────┤
│ Skill           │ Phase / Purpose                                      │
├─────────────────┼──────────────────────────────────────────────────────┤
│ dev-pilot       │ Phase 3: Parallel autopilot (max 5 workers)          │
│ spec-mirror     │ Phase 5: Spec compliance verification                │
│ ultraqa         │ Phase 6/7: Test cycle orchestration                  │
│ bash-executor   │ Internal: Script execution                           │
└─────────────────┴──────────────────────────────────────────────────────┘
```

## Optional (External Use)
- security-reviewer (manual invocation for security audits)
- tdd-guide (manual TDD workflow outside spec-it)
