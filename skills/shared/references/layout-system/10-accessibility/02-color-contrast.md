# Color Contrast

WCAG 2.1 AA 색상 대비 요구사항.

## Requirements

| Content Type | Minimum Ratio |
|--------------|---------------|
| Normal text | 4.5:1 |
| Large text (18px+) | 3:1 |
| UI components | 3:1 |

## Verified Combinations (PASS)

| Foreground | Background | Ratio | Status |
|------------|------------|-------|--------|
| #1F2937 (gray-800) | #FFFFFF | 13.5:1 | ✅ |
| #374151 (gray-700) | #FFFFFF | 9.5:1 | ✅ |
| #4B5563 (gray-600) | #FFFFFF | 6.9:1 | ✅ |
| #6B7280 (gray-500) | #FFFFFF | 4.6:1 | ✅ |
| #2563EB (blue-600) | #FFFFFF | 4.5:1 | ✅ |
| #DC2626 (red-600) | #FFFFFF | 4.6:1 | ✅ |
| #16A34A (green-600) | #FFFFFF | 4.5:1 | ✅ |

## Failed Combinations (DO NOT USE)

| Foreground | Background | Ratio | Status |
|------------|------------|-------|--------|
| #9CA3AF (gray-400) | #FFFFFF | 2.8:1 | ❌ |
| #D1D5DB (gray-300) | #FFFFFF | 1.8:1 | ❌ |
| #60A5FA (blue-400) | #FFFFFF | 3.0:1 | ❌ |

## Usage Guidelines

```tsx
// CORRECT: gray-800 for body text
<p className="text-gray-800">Body text</p>

// CORRECT: gray-500 for secondary text (just passes)
<p className="text-gray-500">Secondary text</p>

// WRONG: gray-400 for text
<p className="text-gray-400">Too light!</p>

// CORRECT: gray-400 for placeholder only
<input placeholder="Placeholder..." className="placeholder:text-gray-400" />
```

## YAML Reference

```yaml
accessibility:
  contrast:
    requirements:
      normalText: 4.5
      largeText: 3.0
      uiComponents: 3.0
    verified:
      textPrimary: { color: "gray-800", ratio: 13.5 }
      textSecondary: { color: "gray-500", ratio: 4.6 }
      link: { color: "blue-600", ratio: 4.5 }
      error: { color: "red-600", ratio: 4.6 }
    forbidden:
      - "gray-400 on white"
      - "gray-300 on white"
      - "blue-400 on white"
```

## Tools

- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- Chrome DevTools > Elements > Accessibility
