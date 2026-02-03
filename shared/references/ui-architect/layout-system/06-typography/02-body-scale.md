# Body Scale

본문 타이포그래피 스케일.

## Scale Definition

| Class | Size | Line Height | Usage |
|-------|------|-------------|-------|
| lg | 18px (1.125rem) | 1.75rem | Intro text |
| base | 16px (1rem) | 1.5rem | Default body |
| sm | 14px (0.875rem) | 1.25rem | Helper text |
| xs | 12px (0.75rem) | 1rem | Captions |

## CSS Classes

```css
/* Large body (intro text) */
.text-lg {
  font-size: 1.125rem;
  line-height: 1.75rem;
}

/* Default body */
.text-base {
  font-size: 1rem;
  line-height: 1.5rem;
}

/* Small body (helper text) */
.text-sm {
  font-size: 0.875rem;
  line-height: 1.25rem;
}

/* Extra small (captions) */
.text-xs {
  font-size: 0.75rem;
  line-height: 1rem;
}
```

## Tailwind Usage

```tsx
// Intro paragraph
<p className="text-lg text-gray-600">
  Introduction text goes here.
</p>

// Body text
<p className="text-base text-gray-600">
  Regular body text.
</p>

// Helper text
<span className="text-sm text-gray-500">
  Helper or description text
</span>

// Caption
<span className="text-xs text-gray-400">
  Caption or timestamp
</span>
```

## YAML Reference

```yaml
designDirection:
  typography:
    body:
      lg:
        size: "1.125rem"
        lineHeight: "1.75rem"
        usage: "Intro text, lead paragraphs"
      base:
        size: "1rem"
        lineHeight: "1.5rem"
        usage: "Default body text"
      sm:
        size: "0.875rem"
        lineHeight: "1.25rem"
        usage: "Helper text, descriptions"
      xs:
        size: "0.75rem"
        lineHeight: "1rem"
        usage: "Captions, timestamps"
```

## Font Weights for Body

| Weight | Class | Usage |
|--------|-------|-------|
| 400 | `font-normal` | Regular text |
| 500 | `font-medium` | Labels, emphasis |
| 600 | `font-semibold` | Strong emphasis |
