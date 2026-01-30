# Agent Output Rules

All spec-it agents MUST follow these rules:

## Response Format

Return ONLY:
```
Done. Files: {path1} ({lines}), {path2} ({lines})
```

## Constraints

1. **Save all results to files** - Never include content in response
2. **Summary only** - Return file paths and line counts
3. **Max 600 lines per file** - Split if exceeded (except wireframes)
4. **Split naming**: `{index}-{name}-{type}.md`
5. **Index file**: Create `_index.md` when splitting

## Example

Good:
```
Done. Files: 02-screens/screen-list.md (45), 02-screens/layouts/layout-system.md (120)
```

Bad:
```
Here's the screen list:
## Login Screen
...
(content included in response)
```
