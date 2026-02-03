# State, Role, and Auth Rules

## STATE_SYNC
Applies to: local storage, parent props, global store.
Criteria:
- If persisted state differs from current source of truth, sync once.
- Never allow UI to diverge from actual permission state.
Failure conditions:
- UI shows role A while actual state is role B.
- onChange not fired when restoring state.
Test checklist:
- Persisted role differs from current role.
- Verify state sync and UI are aligned.

## ROLE_FILTER_RECURSIVE
Applies to: menus, sidebar, route lists, nested navigation.
Criteria:
- Apply role filtering to all levels, not just top-level items.
- If any child is restricted, it must be filtered too.
Failure conditions:
- A restricted child appears under an allowed parent.
- Role checks only run at root.
Test checklist:
- Parent allowed, child restricted.
- Ensure child is not rendered.

## AUTH_PERSISTENCE_REQUIRED
Applies to: auth state, session, token storage.
Criteria:
- Auth has persistence or explicit no-persist policy.
- Token expiry is tracked; stale token is invalidated.
Failure conditions:
- Auth is only in memory with no expiry handling.
- UI shows logged-in after token expiry.
Test checklist:
- Simulate app reload and token expiry.
- Verify logout or refresh behavior.

## ROLE_SOURCE_SINGLETON
Applies to: role selection UI and permission logic.
Criteria:
- Single source of truth for role.
- UI reads from policy output, not raw local state.
Failure conditions:
- Multiple role sources drift over time.
- Policy check uses stale role.
Test checklist:
- Switch role rapidly.
- Verify all permission checks use same role state.
