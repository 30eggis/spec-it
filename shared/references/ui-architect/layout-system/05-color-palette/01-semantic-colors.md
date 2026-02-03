# Semantic Colors

시맨틱 컬러 정의.

## CSS Variables

```css
/* Primary (Blue) */
--primary-50: #EFF6FF;
--primary-100: #DBEAFE;
--primary-200: #BFDBFE;
--primary-300: #93C5FD;
--primary-400: #60A5FA;
--primary-500: #3B82F6;
--primary-600: #2563EB; /* Main primary */
--primary-700: #1D4ED8;
--primary-800: #1E40AF;
--primary-900: #1E3A8A;

/* Success (Green) */
--success-50: #F0FDF4;
--success-100: #DCFCE7;
--success-500: #22C55E;
--success-600: #16A34A; /* Main success */
--success-700: #15803D;

/* Warning (Amber) */
--warning-50: #FFFBEB;
--warning-100: #FEF3C7;
--warning-500: #F59E0B;
--warning-600: #D97706; /* Main warning */
--warning-700: #B45309;

/* Error (Red) */
--error-50: #FEF2F2;
--error-100: #FEE2E2;
--error-500: #EF4444;
--error-600: #DC2626; /* Main error */
--error-700: #B91C1C;

/* Neutral (Gray) */
--gray-50: #F9FAFB;   /* Page background */
--gray-100: #F3F4F6;  /* Section background */
--gray-200: #E5E7EB;  /* Border */
--gray-300: #D1D5DB;  /* Disabled */
--gray-400: #9CA3AF;  /* Placeholder */
--gray-500: #6B7280;  /* Secondary text */
--gray-600: #4B5563;  /* Body text */
--gray-700: #374151;  /* Heading */
--gray-800: #1F2937;  /* Primary text */
--gray-900: #111827;  /* Strong text */
```

## YAML Reference

```yaml
designDirection:
  colorTokens:
    primary:
      50: "#EFF6FF"
      100: "#DBEAFE"
      500: "#3B82F6"
      600: "#2563EB"  # Main
      700: "#1D4ED8"
    success:
      50: "#F0FDF4"
      500: "#22C55E"
      600: "#16A34A"  # Main
    warning:
      50: "#FFFBEB"
      500: "#F59E0B"
      600: "#D97706"  # Main
    error:
      50: "#FEF2F2"
      500: "#EF4444"
      600: "#DC2626"  # Main
    gray:
      50: "#F9FAFB"
      100: "#F3F4F6"
      200: "#E5E7EB"
      400: "#9CA3AF"
      500: "#6B7280"
      600: "#4B5563"
      800: "#1F2937"
```

## Tailwind Colors

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#EFF6FF',
          100: '#DBEAFE',
          500: '#3B82F6',
          600: '#2563EB',
          700: '#1D4ED8',
        },
        // Using Tailwind defaults for success/warning/error
      },
    },
  },
}
```
