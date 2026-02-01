# Overview

spec-it-execute converts a spec-it plan output into a working implementation with verification.

## Inputs

- Spec folder from plan mode (typically `tmp/06-final/`)

## Outputs

- Updated codebase
- Logs, reviews, screenshots under `.spec-it/{sessionId}/execute/`

## Phase Map

0. Initialize
1. Load
2. Plan
3. Execute
4. QA
5. Spec-Mirror
6. Unit Tests
7. E2E
8. Validate
9. Complete

## Progressive Loading

Each phase has its own doc in `skills/spec-it-execute/docs/` so the orchestrator can load only what it needs.
