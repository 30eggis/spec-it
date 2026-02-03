# Rules

## Vercel Skills Initialization (CRITICAL - MUST RUN FIRST)

Before Phase 0, ensure Vercel agent-skills submodule is available for Tailwind reference:

```bash
# Auto-initialize submodule
if [ ! -f "docs/refs/agent-skills/README.md" ]; then
  git submodule update --init --recursive docs/refs/agent-skills 2>/dev/null || echo "Warning: Could not init submodule"
fi
```

**Reference:** `shared/references/common/rules/05-vercel-skills.md` for:
- Tailwind class → CSS mapping
- Grid layout best practices
- Component style guidelines

---

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
