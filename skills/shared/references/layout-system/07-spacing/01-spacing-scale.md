# Spacing Scale

간격 스케일 정의.

## Tailwind Spacing Scale

| Key | Value (px) | Value (rem) |
|-----|------------|-------------|
| 0 | 0px | 0 |
| 0.5 | 2px | 0.125rem |
| 1 | 4px | 0.25rem |
| 1.5 | 6px | 0.375rem |
| 2 | 8px | 0.5rem |
| 2.5 | 10px | 0.625rem |
| 3 | 12px | 0.75rem |
| 4 | 16px | 1rem |
| 5 | 20px | 1.25rem |
| 6 | 24px | 1.5rem |
| 8 | 32px | 2rem |
| 10 | 40px | 2.5rem |
| 12 | 48px | 3rem |
| 16 | 64px | 4rem |
| 20 | 80px | 5rem |
| 24 | 96px | 6rem |
| 32 | 128px | 8rem |

## Common Patterns

| Pattern | Spacing | Usage |
|---------|---------|-------|
| Tight | 1-2 (4-8px) | Icon + text, inline elements |
| Normal | 3-4 (12-16px) | Component internal spacing |
| Relaxed | 6-8 (24-32px) | Section separation |
| Loose | 12-16 (48-64px) | Major section breaks |

## YAML Reference

```yaml
designDirection:
  spacing:
    scale:
      0: "0px"
      1: "4px"
      2: "8px"
      3: "12px"
      4: "16px"
      5: "20px"
      6: "24px"
      8: "32px"
      10: "40px"
      12: "48px"
      16: "64px"
    patterns:
      tight: "1-2"
      normal: "3-4"
      relaxed: "6-8"
      loose: "12-16"
```

## Usage Examples

```tsx
// Tight spacing (icon + text)
<div className="flex items-center gap-2">
  <Icon className="w-4 h-4" />
  <span>Label</span>
</div>

// Normal spacing (card content)
<div className="p-4 space-y-4">
  <h3>Title</h3>
  <p>Content</p>
</div>

// Relaxed spacing (sections)
<div className="space-y-8">
  <section>...</section>
  <section>...</section>
</div>
```
