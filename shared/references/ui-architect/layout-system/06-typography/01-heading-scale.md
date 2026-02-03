# Heading Scale

제목 타이포그래피 스케일.

## Scale Definition

| Class | Size | Line Height | Weight | Letter Spacing |
|-------|------|-------------|--------|----------------|
| display | 60px (3.75rem) | 1 | 700 | -0.02em |
| h1 | 36px (2.25rem) | 2.5rem | 700 | -0.01em |
| h2 | 30px (1.875rem) | 2.25rem | 600 | 0 |
| h3 | 24px (1.5rem) | 2rem | 600 | 0 |
| h4 | 20px (1.25rem) | 1.75rem | 600 | 0 |
| h5 | 18px (1.125rem) | 1.75rem | 600 | 0 |

## CSS Classes

```css
/* Display (Hero sections only) */
.text-display {
  font-size: 3.75rem;
  line-height: 1;
  font-weight: 700;
  letter-spacing: -0.02em;
}

/* H1 (Page titles) */
.text-h1 {
  font-size: 2.25rem;
  line-height: 2.5rem;
  font-weight: 700;
  letter-spacing: -0.01em;
}

/* H2 (Section titles) */
.text-h2 {
  font-size: 1.875rem;
  line-height: 2.25rem;
  font-weight: 600;
}

/* H3 (Card titles) */
.text-h3 {
  font-size: 1.5rem;
  line-height: 2rem;
  font-weight: 600;
}

/* H4 (Subsection titles) */
.text-h4 {
  font-size: 1.25rem;
  line-height: 1.75rem;
  font-weight: 600;
}

/* H5 (Small titles) */
.text-h5 {
  font-size: 1.125rem;
  line-height: 1.75rem;
  font-weight: 600;
}
```

## Tailwind Usage

```tsx
// Display
<h1 className="text-6xl font-bold tracking-tight">Hero</h1>

// H1
<h1 className="text-4xl font-bold tracking-tight">Page Title</h1>

// H2
<h2 className="text-3xl font-semibold">Section Title</h2>

// H3
<h3 className="text-2xl font-semibold">Card Title</h3>

// H4
<h4 className="text-xl font-semibold">Subsection</h4>

// H5
<h5 className="text-lg font-semibold">Small Title</h5>
```

## YAML Reference

```yaml
designDirection:
  typography:
    headings:
      display:
        size: "3.75rem"
        lineHeight: 1
        weight: 700
        letterSpacing: "-0.02em"
      h1:
        size: "2.25rem"
        lineHeight: "2.5rem"
        weight: 700
        letterSpacing: "-0.01em"
      h2:
        size: "1.875rem"
        lineHeight: "2.25rem"
        weight: 600
      h3:
        size: "1.5rem"
        lineHeight: "2rem"
        weight: 600
      h4:
        size: "1.25rem"
        lineHeight: "1.75rem"
        weight: 600
      h5:
        size: "1.125rem"
        lineHeight: "1.75rem"
        weight: 600
```
