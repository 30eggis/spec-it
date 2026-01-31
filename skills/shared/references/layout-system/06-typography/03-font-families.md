# Font Families

폰트 패밀리 정의.

## CSS Variables

```css
/* Primary (Sans-serif) */
--font-sans: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont,
  "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;

/* Monospace (Code, Data) */
--font-mono: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas,
  "Liberation Mono", monospace;
```

## Usage

| Context | Font Family | Tailwind |
|---------|-------------|----------|
| UI Text | Sans-serif | `font-sans` |
| Code | Monospace | `font-mono` |
| Data/Numbers | Monospace | `font-mono` |

## Examples

```tsx
// UI Text (default)
<p className="font-sans">Regular text</p>

// Code snippet
<code className="font-mono text-sm bg-gray-100 px-2 py-1 rounded">
  npm install
</code>

// Data display
<span className="font-mono text-lg tabular-nums">
  42:30:15
</span>
```

## Tailwind Config

```js
// tailwind.config.js
module.exports = {
  theme: {
    fontFamily: {
      sans: ['ui-sans-serif', 'system-ui', '-apple-system', 'BlinkMacSystemFont', '"Segoe UI"', 'Roboto', '"Helvetica Neue"', 'Arial', 'sans-serif'],
      mono: ['ui-monospace', 'SFMono-Regular', '"SF Mono"', 'Menlo', 'Consolas', '"Liberation Mono"', 'monospace'],
    },
  },
}
```

## YAML Reference

```yaml
designDirection:
  typography:
    fontFamilies:
      sans:
        stack: "ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif"
        usage: "All UI text"
      mono:
        stack: "ui-monospace, SFMono-Regular, 'SF Mono', Menlo, Consolas, 'Liberation Mono', monospace"
        usage: "Code, data, timestamps"
```

## Number Display

For tabular numbers (aligned digits):

```tsx
<span className="font-mono tabular-nums">
  12,345.67
</span>
```
