# Vercel Agent Skills Reference

## Overview

This rule ensures all spec-it skills have access to Vercel's agent-skills for accurate Tailwind CSS, design patterns, and layout analysis.

**Submodule Path:** `docs/refs/agent-skills`
**Source:** https://github.com/vercel-labs/agent-skills

---

## RULE: INIT_VERCEL_SKILLS

**When:** Start of any spec-it, spec-it-execute, or hack-2-spec workflow
**Priority:** CRITICAL (blocks execution if not available)

### Auto-Initialize Submodule

Before any analysis or code generation, ensure the submodule is initialized:

```bash
# Check if submodule is initialized
if [ ! -f "docs/refs/agent-skills/README.md" ]; then
  echo "Initializing vercel-skills submodule..."
  git submodule update --init --recursive docs/refs/agent-skills
fi
```

### Verification

After initialization, verify availability:
- `docs/refs/agent-skills/` directory exists
- Contains Tailwind/design reference files

---

## RULE: TAILWIND_LAYOUT_ANALYSIS

**When:** Analyzing HTML/CSS for layout structure (hack-2-spec, spec-mirror)
**Reference:** `docs/refs/agent-skills/` Tailwind documentation

### Grid Layout Detection

| Tailwind Class | Columns | YAML Mapping |
|----------------|---------|--------------|
| `grid-cols-1` | 1 | `columns: "1fr"` |
| `grid-cols-2` | 2 | `columns: "1fr 1fr"` |
| `grid-cols-3` | 3 | `columns: "1fr 1fr 1fr"` |
| `grid-cols-4` | 4 | `columns: "repeat(4, 1fr)"` |
| `grid-cols-5` | 5 | `columns: "repeat(5, 1fr)"` |
| `lg:grid-cols-*` | Responsive | Desktop breakpoint |
| `md:grid-cols-*` | Responsive | Tablet breakpoint |
| `sm:grid-cols-*` | Responsive | Mobile breakpoint |

### Flex Layout Detection

| Tailwind Class | Direction | YAML Mapping |
|----------------|-----------|--------------|
| `flex` | Row (default) | `display: "flex"` |
| `flex-col` | Column | `flex_direction: "column"` |
| `flex-row` | Row | `flex_direction: "row"` |
| `flex-wrap` | Wrap | `flex_wrap: "wrap"` |
| `justify-between` | Space between | `justify_content: "space-between"` |
| `items-center` | Center vertically | `align_items: "center"` |

### Gap Detection

| Tailwind Class | Value | YAML Mapping |
|----------------|-------|--------------|
| `gap-1` | 4px | `gap: 4` |
| `gap-2` | 8px | `gap: 8` |
| `gap-3` | 12px | `gap: 12` |
| `gap-4` | 16px | `gap: 16` |
| `gap-6` | 24px | `gap: 24` |
| `gap-8` | 32px | `gap: 32` |

---

## RULE: WIREFRAME_GRID_MAPPING

**When:** Generating wireframe YAML from analyzed HTML
**Applies to:** hack-2-spec, spec-it wireframe generation

### Grid Areas Mapping

When source HTML uses `grid-cols-N`, map to CSS Grid areas:

**Example: 3-column layout**
```html
<!-- Source HTML -->
<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
  <div>Card A</div>
  <div>Card B</div>
  <div>Card C</div>
</div>
```

**Correct YAML Output:**
```yaml
grid:
  desktop:
    areas: |
      "card_a card_b card_c"
    columns: "1fr 1fr 1fr"
    gap: 24

  mobile:
    areas: |
      "card_a"
      "card_b"
      "card_c"
    columns: "1fr"
    gap: 24
```

### Common Mistakes to Avoid

| Wrong | Correct | Reason |
|-------|---------|--------|
| `columns: "2fr 1fr"` for 3 items | `columns: "1fr 1fr 1fr"` | Match actual column count |
| Splitting row items across rows | Keep same-row items together | Preserve visual grouping |
| Ignoring responsive classes | Map `lg:`, `md:`, `sm:` separately | Responsive fidelity |

---

## RULE: COMPONENT_STYLE_REFERENCE

**When:** Generating component code (spec-it-execute)
**Reference:** Vercel design patterns from agent-skills

### Tailwind Best Practices

1. **Use semantic spacing**: `gap-*` over manual margins
2. **Responsive-first**: Start with mobile, add breakpoint prefixes
3. **Consistent rounding**: `rounded-lg`, `rounded-xl`, `rounded-2xl`
4. **Shadow hierarchy**: `shadow-sm` < `shadow` < `shadow-lg`

### Color System

Reference Tailwind color palette for consistent theming:
- Primary: `blue-*`, `indigo-*`
- Success: `green-*`, `emerald-*`
- Warning: `amber-*`, `yellow-*`
- Danger: `red-*`, `rose-*`
- Neutral: `slate-*`, `gray-*`

---

## Skills That Must Load This Rule

| Skill | Load Point | Purpose |
|-------|------------|---------|
| `hack-2-spec` | Step 0 (before analysis) | Accurate layout detection |
| `spec-it` | Wireframe chapter | Correct grid mapping |
| `spec-it-execute` | Phase 3 (code gen) | Tailwind best practices |
| `spec-mirror` | Comparison phase | Layout verification |
| `stitch-convert` | HTML generation | Style consistency |

---

## Enforcement

If submodule is not available and cannot be initialized:

1. **Warn** the user about degraded accuracy
2. **Log** the issue to session status
3. **Continue** with built-in fallback rules (this file)
4. **Recommend** manual initialization: `git submodule update --init docs/refs/agent-skills`
