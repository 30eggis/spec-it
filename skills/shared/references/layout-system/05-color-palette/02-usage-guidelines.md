# Color Usage Guidelines

컬러 사용 가이드.

## Context-based Usage

| Context | Color | Tailwind | Usage |
|---------|-------|----------|-------|
| Primary Action | primary-600 | `text-blue-600` | Main CTAs, links |
| Success State | success-600 | `text-green-600` | Approvals, confirmations |
| Warning State | warning-600 | `text-amber-600` | Limits approaching |
| Error State | error-600 | `text-red-600` | Validation errors |
| Background | gray-50 | `bg-gray-50` | Page background |
| Surface | white | `bg-white` | Cards, panels |
| Text Primary | gray-800 | `text-gray-800` | Body text |
| Text Secondary | gray-500 | `text-gray-500` | Helper text |
| Border | gray-200 | `border-gray-200` | Dividers, borders |

## Status Colors

| Status | Background | Text | Border |
|--------|------------|------|--------|
| Present | green-50 | green-700 | green-200 |
| Absent | red-50 | red-700 | red-200 |
| Late | amber-50 | amber-700 | amber-200 |
| Leave | blue-50 | blue-700 | blue-200 |
| Remote | purple-50 | purple-700 | purple-200 |

## Badge Colors

```tsx
// Status badge component
const badgeColors = {
  approved: "bg-green-100 text-green-800",
  pending: "bg-amber-100 text-amber-800",
  rejected: "bg-red-100 text-red-800",
  draft: "bg-gray-100 text-gray-800",
};
```

## YAML Reference

```yaml
designDirection:
  colorUsage:
    actions:
      primary: "primary-600"
      secondary: "gray-600"
      danger: "error-600"
    states:
      success: "success-600"
      warning: "warning-600"
      error: "error-600"
    text:
      primary: "gray-800"
      secondary: "gray-500"
      disabled: "gray-400"
    backgrounds:
      page: "gray-50"
      surface: "white"
      elevated: "white"
    borders:
      default: "gray-200"
      focus: "primary-400"
      error: "error-400"
```

## Contrast Requirements (WCAG 2.1 AA)

| Combination | Ratio | Status |
|-------------|-------|--------|
| gray-800 on white | 13.5:1 | ✅ Pass |
| blue-600 on white | 4.5:1 | ✅ Pass |
| red-600 on white | 4.6:1 | ✅ Pass |
| gray-400 on white | 2.8:1 | ❌ Fail |

**Never use gray-400 or lighter for text on white backgrounds.**
