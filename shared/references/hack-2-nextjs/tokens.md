# Phase 2: Design Tokens Reference

## 2.1 Token Aggregation

Merge all `extracted/*/computed.json` files:
1. Deduplicate colors, sum frequencies
2. Deduplicate typography combinations
3. Deduplicate spacing values
4. Deduplicate shadows
5. Deduplicate border-radius values

## 2.2 Semantic Mapping Rules

Map by frequency rank:

**Colors:**
- Rank 1-2 text colors → textPrimary, textSecondary
- Most used blue/accent → primary
- Most used light background → background
- Most used border color → border

**Typography:**
- Most frequent → body
- Larger + heavier → heading variants

**Spacing:**
- Map to 4px scale (4, 8, 12, 16, 20, 24, 32, 40, 48)

## 2.3 Output: tokens.ts

```typescript
export const tokens = {
  colors: {
    primary: '#3b82f6',
    primaryHover: '#2563eb',
    background: '#f8fafc',
    surface: '#ffffff',
    textPrimary: '#1e293b',
    textSecondary: '#64748b',
    border: '#e2e8f0',
    error: '#ef4444',
    success: '#22c55e',
  },
  typography: {
    fontFamily: { sans: ['Inter', 'sans-serif'] },
    fontSize: { xs: '12px', sm: '14px', base: '16px', lg: '18px', xl: '24px', '2xl': '32px' },
    fontWeight: { normal: 400, medium: 500, semibold: 600, bold: 700 },
    lineHeight: { tight: 1.2, normal: 1.5, relaxed: 1.75 },
  },
  spacing: { 0: '0px', 1: '4px', 2: '8px', 3: '12px', 4: '16px', 5: '20px', 6: '24px', 8: '32px', 10: '40px', 12: '48px' },
  borderRadius: { none: '0px', sm: '4px', md: '8px', lg: '12px', xl: '16px', full: '9999px' },
  shadows: {
    sm: '0 1px 2px rgba(0,0,0,0.05)',
    md: '0 4px 6px rgba(0,0,0,0.1)',
    lg: '0 10px 15px rgba(0,0,0,0.1)',
  },
} as const;

export type Tokens = typeof tokens;
```

## 2.4 Output: tokens.css

```css
:root {
  --color-primary: #3b82f6;
  --color-primary-hover: #2563eb;
  --color-background: #f8fafc;
  --color-surface: #ffffff;
  --color-text-primary: #1e293b;
  --color-text-secondary: #64748b;
  --color-border: #e2e8f0;
  --color-error: #ef4444;
  --color-success: #22c55e;

  --font-family-sans: 'Inter', sans-serif;
  --font-size-xs: 12px;
  --font-size-sm: 14px;
  --font-size-base: 16px;
  --font-size-lg: 18px;
  --font-size-xl: 24px;
  --font-size-2xl: 32px;

  --spacing-1: 4px;
  --spacing-2: 8px;
  --spacing-3: 12px;
  --spacing-4: 16px;
  --spacing-6: 24px;
  --spacing-8: 32px;

  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;

  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
}
```

## 2.5 Output: tailwind.config.ts

```typescript
import type { Config } from 'tailwindcss';
import { tokens } from './tokens';

const config: Config = {
  content: ['./app/**/*.tsx', './components/**/*.tsx'],
  theme: {
    extend: {
      colors: tokens.colors,
      fontFamily: tokens.typography.fontFamily,
      fontSize: tokens.typography.fontSize,
      spacing: tokens.spacing,
      borderRadius: tokens.borderRadius,
      boxShadow: tokens.shadows,
    },
  },
  plugins: [],
};

export default config;
```

## 2.6 Replacement Map

| Original | Token-based |
|----------|-------------|
| `bg-[#3b82f6]` | `bg-primary` |
| `text-[#1e293b]` | `text-textPrimary` |
| `text-[#64748b]` | `text-textSecondary` |
| `p-[16px]` | `p-4` |
| `rounded-[8px]` | `rounded-md` |
| `shadow-[...]` | `shadow-md` |
