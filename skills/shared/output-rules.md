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

---

## Output Format Selection (YAML vs Markdown)

### Format Selection Rules

| Spec Type | Preferred Format | Fallback |
|-----------|------------------|----------|
| UI Wireframe | YAML | Markdown (legacy) |
| Component Spec | YAML | Markdown (legacy) |
| Screen Spec | YAML | Markdown (legacy) |
| Layout System | YAML | Markdown (legacy) |
| Scenarios | Markdown | - |
| Test Specs | YAML | Markdown |
| Dev Tasks | Markdown | - |

### Check _meta.json for Format

```json
// Project _meta.json
{
  "specFormat": "yaml",  // "yaml" (default) or "markdown" (legacy)
  ...
}
```

### YAML Output Rules

When outputting YAML specs:

1. **Use Templates**: Always use templates from `assets/templates/*.yaml`
2. **Reference Design Tokens**: Use `_ref` for shared tokens
   ```yaml
   styles:
     _ref: "../../shared/design-tokens.yaml"
     overrides:
       card: "custom-class"
   ```
3. **No ASCII Art**: Replace ASCII wireframes with structured `grid` definitions
4. **Precise Values**: Use exact measurements (px, rem) not approximations
5. **Component IDs**: Use consistent ID format: `SCR-001`, `CMP-001`, `LYT-001`

### Benefits of YAML Format

| Metric | Markdown/ASCII | YAML | Improvement |
|--------|----------------|------|-------------|
| File Size | ~11KB | ~4KB | **-64%** |
| Parse Speed | Regex-based | YAML.parse | **10x faster** |
| Token Usage | Repeated | Shared refs | **-80% duplicates** |
| Precision | Approximate | Exact | **100% accuracy** |

### YAML Template References

```
skills/spec-it-stepbystep/assets/templates/
├── UI_WIREFRAME_TEMPLATE.yaml     ← Screen wireframes
├── COMPONENT_SPEC_TEMPLATE.yaml   ← Component definitions
├── SCREEN_SPEC_TEMPLATE.yaml      ← Screen specifications
└── LAYOUT_TEMPLATE.yaml           ← Layout systems
```

### Shared Design Tokens

All YAML specs should reference the shared design tokens:

```yaml
# Reference in spec files
styles:
  _ref: "../../shared/design-tokens.yaml"

# Available tokens:
# - colors.light.*, colors.dark.*
# - spacing.padding.*, spacing.gap.*
# - typography.size.*, typography.weight.*
# - components.card.*, components.button.*
# - effects.shadow.*, effects.radius.*
# - animations.fadeIn, animations.slideUp
```

### Migration from Markdown

Existing Markdown specs are still supported:

1. New projects default to YAML format
2. Set `specFormat: "markdown"` in _meta.json for legacy support
3. Loaders auto-detect format by file extension (.yaml vs .md)
4. Gradual migration: Convert files as they're updated
