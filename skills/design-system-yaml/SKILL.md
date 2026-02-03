---
name: design-system-yaml
description: |
  Extract and classify design values from designer files into structured YAML design tokens.
  Automatically categorizes colors, typography, spacing, components into proper token hierarchy.
  Use when: (1) Designer provides style guide/mockup files, (2) Need to create design-tokens.yaml, (3) Converting design specs to structured tokens.
  Input: Markdown, PDF, images, Figma exports, CSS files.
---

# Design System YAML Generator

Automatically classify and structure design values into YAML tokens.

## Classification Rules

### 1. Colors
**Detect**: `#HEX`, `rgb()`, `rgba()`, `hsl()`, color names with values

**Classify by context**:
| Context Keywords | Category |
|-----------------|----------|
| brand, primary, accent, main | `colors.brand` |
| secondary, tertiary | `colors.brand.secondary` |
| black, white, gray, grey, neutral | `colors.neutral` |
| error, danger, red (error context) | `colors.semantic.error` |
| success, green (success context) | `colors.semantic.success` |
| warning, orange, amber | `colors.semantic.warning` |
| info, blue (info context) | `colors.semantic.info` |
| text, foreground | `colors.text` |
| background, bg, surface | `colors.background` |
| border, divider, separator | `colors.border` |

**Gray scale detection**: Sequential values → `colors.neutral.gray.{50-900}`

### 2. Typography
**Detect**: `px`, `rem`, `em` sizes, font-family names, weight numbers (400-900)

**Classify**:
| Pattern | Category |
|---------|----------|
| Font family names | `typography.family` |
| Size values | `typography.size.{xs/sm/base/lg/xl/2xl...}` |
| Weight (400, 500, 600, 700) | `typography.weight` |
| Line-height (1.2, 1.5, etc) | `typography.lineHeight` |
| H1, H2, Heading, Title | `typography.headings` |
| Body, Caption, Label | `typography.body` |

**Size mapping**:
```
10-12px → xs
13-14px → sm
15-16px → base
17-18px → lg
19-20px → xl
21-24px → 2xl
25-30px → 3xl
31+px   → 4xl
```

### 3. Spacing
**Detect**: Padding, margin, gap values in px

**Classify**:
| Context | Category |
|---------|----------|
| Base unit (4px, 8px) | `spacing.base` |
| Screen edge, margin | `spacing.layout.screenEdge` |
| Section spacing | `spacing.layout.section` |
| Card/component padding | `spacing.component` |
| Gap between items | `spacing.gap` |

**Scale generation**: Detect 4px base → generate `spacing.scale.{1-12}`

### 4. Border Radius
**Detect**: `border-radius`, `rounded`, corner values

**Classify**:
```
0px      → radius.none
2-4px    → radius.sm
6-8px    → radius.md
10-16px  → radius.lg
17-24px  → radius.xl
50%, pill → radius.full
```

### 5. Shadows
**Detect**: `shadow`, `elevation`, `box-shadow` values

**Classify**: `shadows.{sm/md/lg/xl}` by blur radius

### 6. Animation
**Detect**: `duration`, `ms`, `cubic-bezier`, `ease`, `transition`

**Classify**:
- Duration → `animation.duration.{fast/normal/slow}`
- Easing → `animation.easing`

### 7. Components
**Detect**: Button, Input, Card, Modal, Avatar, Chip, Navigation specs

**Classify by component type**:
```yaml
components:
  button:
    primary: { height, radius, padding, ... }
    secondary: { ... }
  input:
    default: { height, radius, ... }
  card:
    default: { radius, padding, shadow }
```

## Output Structure

```yaml
meta:
  name: "{project name from source}"
  source: "{input file}"

colors:
  brand: { ... }
  neutral: { ... }
  semantic: { ... }
  text: { ... }
  background: { ... }

typography:
  family: { ... }
  size: { ... }
  weight: { ... }
  headings: { ... }

spacing:
  base: { value: "4px" }
  scale: { 1: "4px", 2: "8px", ... }
  layout: { ... }

radius: { ... }
shadows: { ... }
animation: { ... }
components: { ... }

breakpoints: { ... }
accessibility: { ... }
```

## Process

1. **Read** input file (use Read tool for all formats)
2. **Extract** all design values with surrounding context
3. **Classify** each value using rules above
4. **Structure** into YAML hierarchy
5. **Output** to `design-tokens.yaml`

See `references/output-schema.yaml` for complete output example.
