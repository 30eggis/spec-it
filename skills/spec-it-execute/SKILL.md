---
name: spec-it-execute
description: "Autopilot executor that turns spec-it output into working code (9 phases)."
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
argument-hint: "<spec-folder> [--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-execute

Autopilot execution engine that turns spec-it output into working code with minimal user intervention.

## Quick Start

```
/frontend-skills:spec-it-execute <spec-folder>
/frontend-skills:spec-it-execute <spec-folder> --resume <sessionId>
```

## What This Skill Does

- Loads spec output from plan mode
- Generates an execution plan
- Implements code in batches
- Runs QA and spec-mirror verification
- Implements tests and validates quality

## Doc Index (progressive loading)

- `skills/spec-it-execute/docs/00-overview.md`
- `skills/spec-it-execute/docs/01-rules.md`
- `skills/spec-it-execute/docs/02-phase-0-2-init-load-plan.md`
- `skills/spec-it-execute/docs/03-phase-3-execute.md`
- `skills/spec-it-execute/docs/04-phase-4-qa.md`
- `skills/spec-it-execute/docs/05-phase-5-mirror.md`
- `skills/spec-it-execute/docs/06-phase-6-unit-tests.md`
- `skills/spec-it-execute/docs/07-phase-7-e2e.md`
- `skills/spec-it-execute/docs/08-phase-8-validate.md`
- `skills/spec-it-execute/docs/09-phase-9-complete.md`
- `skills/spec-it-execute/docs/10-live-preview.md`
- `skills/spec-it-execute/docs/11-model-routing.md`
- `skills/spec-it-execute/docs/12-state-schema.md`
- `skills/spec-it-execute/docs/13-error-recovery.md`
- `skills/spec-it-execute/docs/14-agents.md`

## Critical Rules (must follow)

- No phase skipping. Phases must execute in order.
- Phase completion uses `scripts/core/status-update.sh` only.
- QA, Spec-Mirror, and E2E are hard gates. Failures stop execution.
- Main orchestrator must not write files via Bash redirection.

See full details in `skills/spec-it-execute/docs/01-rules.md`.
