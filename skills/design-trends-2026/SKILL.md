---
name: design-trends-2026
description: "2026 Design Trends & Templates. Apply trendy UI patterns to wireframes and components. Reference for ui-architecture agents."
allowed-tools: Read, Write, Edit, Glob, Grep
argument-hint: "[component|page|dashboard|form] [--style <organic|minimal|immersive>]"
permissionMode: default
---

# design-trends-2026: Modern UI Design Templates

Apply 2026 design trends to UI components, pages, and layouts.

## Overview

This skill provides:
1. **Design Trend Guidelines** - What each trend means and when to use it
2. **Component Templates** - Ready-to-use Tailwind/CSS patterns
3. **Motion Presets** - Animation configurations
4. **Color Systems** - Modern palette generators

## References

- [trends-summary.md](./references/trends-summary.md) - All 2026 trends overview
- [component-patterns.md](./references/component-patterns.md) - Trend-specific component styles
- [motion-presets.md](./references/motion-presets.md) - Animation and micro-interaction presets
- [color-systems.md](./references/color-systems.md) - Modern color palette definitions

## Templates

- [card-templates.md](./templates/card-templates.md) - Card component variations
- [dashboard-templates.md](./templates/dashboard-templates.md) - Dashboard layout patterns
- [form-templates.md](./templates/form-templates.md) - Form and input styles
- [navigation-templates.md](./templates/navigation-templates.md) - Nav and menu patterns

---

## Quick Usage

### 1. Apply Trend to Component

```
Input: "Apply organic shapes to this card component"
→ Read: references/component-patterns.md#organic-shapes
→ Output: Tailwind classes + CSS for organic card
```

### 2. Generate Dashboard Style

```
Input: "Create immersive dashboard layout"
→ Read: templates/dashboard-templates.md#immersive
→ Output: Full layout with 3D elements, glassmorphism
```

### 3. Add Micro-Interactions

```
Input: "Add meaningful motion to button"
→ Read: references/motion-presets.md#button-interactions
→ Output: Framer Motion / CSS animation code
```

---

## Trend Categories

### Visual Trends
| Trend | Key Feature | Best For |
|-------|-------------|----------|
| Organic Shapes | Fluid curves, anti-grid | Landing pages, creative apps |
| Light Skeuomorphism | Subtle shadows, soft emboss | Cards, buttons, inputs |
| 3D Visuals | WebGL, React Three Fiber | Hero sections, product demos |
| Dark Mode+ | Adaptive palettes | All SaaS applications |

### Interaction Trends
| Trend | Key Feature | Best For |
|-------|-------------|----------|
| Micro-Animations | Meaningful motion cues | Buttons, cards, transitions |
| Voice UI | Conversational flows | Search, navigation |
| Hyper-Personalization | Adaptive layouts | Dashboards, content apps |
| Gamification | Progress, achievements | Onboarding, engagement |

### UX Trends
| Trend | Key Feature | Best For |
|-------|-------------|----------|
| AI-Driven UI | Predictive interfaces | SaaS tools, productivity |
| Mobile-First | Touch-optimized | All applications |
| Accessibility Core | WCAG 2.2 AA minimum | All applications |
| Data Visualization | Interactive charts | Analytics, reports |

---

## Integration with UI Architecture

When generating wireframes or components, reference this skill:

```markdown
## Design Direction

Applying trends from design-trends-2026:
- Primary: Light Skeuomorphism (cards, inputs)
- Secondary: Micro-Animations (button feedback, page transitions)
- Color: Dark Mode+ (adaptive palette)

See: skills/design-trends-2026/references/component-patterns.md
```

---

## Style Presets

### --style organic
- Fluid shapes, curved corners (rounded-3xl, rounded-full)
- Gradient backgrounds with blur
- Asymmetric layouts
- Nature-inspired colors

### --style minimal
- Clean lines, generous whitespace
- Monochrome with single accent
- Grid-based but breathable
- Typography-focused

### --style immersive
- 3D elements, depth layers
- Glassmorphism effects
- Rich animations
- Bold color contrasts
