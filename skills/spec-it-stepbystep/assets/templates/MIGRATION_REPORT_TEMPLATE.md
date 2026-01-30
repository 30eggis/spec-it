# Component Migration Report: {{component_name}}

## Summary

| Item | Value |
|------|-------|
| Source | `{{source_path}}` |
| Target | `{{target_path}}` |
| Status | {{status}} |
| Migrated At | {{migrated_at}} |

## Changes Made

### Files Created

| File | Purpose |
|------|---------|
| `{{target_path}}/{{component_name}}.tsx` | Component body |
| `{{target_path}}/index.ts` | Barrel export |
{{#each additional_files}}
| `{{path}}` | {{purpose}} |
{{/each}}

### Files Modified

| File | Line | Change |
|------|------|--------|
{{#each modified_files}}
| `{{path}}` | {{line}} | {{change}} |
{{/each}}

### Files Deleted

| File | Reason |
|------|--------|
| `{{source_path}}` | Moved to common components |
{{#each deleted_files}}
| `{{path}}` | {{reason}} |
{{/each}}

## Improvements Applied

- [{{#if props_exported}}x{{else}} {{/if}}] Props interface exported
- [{{#if forward_ref}}x{{else}} {{/if}}] forwardRef applied
- [{{#if jsdoc}}x{{else}} {{/if}}] JSDoc comments added
- [{{#if display_name}}x{{else}} {{/if}}] displayName set
{{#each improvements}}
- [{{#if applied}}x{{else}} {{/if}}] {{description}}
{{/each}}

## Import Path Changes

### Before
```typescript
import { {{component_name}} } from '{{old_import_path}}';
```

### After
```typescript
import { {{component_name}} } from '{{new_import_path}}';
```

## Verification

- [{{#if ts_check}}x{{else}} {{/if}}] TypeScript: No errors
- [{{#if lint_check}}x{{else}} {{/if}}] ESLint: No warnings
- [{{#if build_check}}x{{else}} {{/if}}] Build: Success

{{#if verification_notes}}
### Notes
{{verification_notes}}
{{/if}}

## Rollback Instructions

If issues occur, rollback procedure:

```bash
git checkout {{commit_before}} -- {{source_path}}
# Modified import paths need to be restored
```
