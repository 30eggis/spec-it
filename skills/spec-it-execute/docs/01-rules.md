# Rules

## Main Orchestrator File Writing (CRITICAL)

Do not write files via Bash redirection in the main orchestrator.

Forbidden examples:

- `cat > file << EOF`
- `echo ... > file`

Allowed alternatives:

- Status updates via `scripts/core/status-update.sh`
- Regular file writes via `Write`
- Large files via subagent `Task`

## Phase Order (CRITICAL)

- Phases must run in order. No skipping.
- Phase completion must call `status-update.sh`.

## Hard Gates (CRITICAL)

- QA fails → stop and wait
- Spec-Mirror fails → stop and wait
- E2E fails → stop and wait

## Permissions

- Ensure MCP permissions are registered once via `scripts/setup-permissions.sh`.
