# Token Generation Reference

수집된 스타일 정보를 디자인 토큰으로 자동 변환.

---

## 1. Overview

추출된 CSS 정보에서 시맨틱 디자인 토큰을 자동 생성:
- 색상 → 시맨틱 색상 토큰
- 타이포그래피 → 폰트 토큰
- 간격 → 스페이싱 토큰
- 테두리 → 반경/테두리 토큰

---

## 2. Color Token Generation

### 2.1 Color Classification

```typescript
function classifyColor(hex: string): 'accent' | 'neutral' | 'text' | 'background' {
  const { h, s, l } = hexToHSL(hex);

  // Very light (l > 90) → background
  if (l > 90) return 'background';

  // Very dark (l < 20) or low saturation (s < 10) → text or neutral
  if (l < 20 || s < 10) {
    return l < 30 ? 'text' : 'neutral';
  }

  // Saturated → accent
  if (s > 30) return 'accent';

  return 'neutral';
}
```

### 2.2 Semantic Token Mapping

```typescript
function generateColorTokens(colorUsage: Record<string, { count: number; contexts: string[] }>) {
  const classified = {
    accent: [] as Array<{ color: string; count: number }>,
    neutral: [] as Array<{ color: string; count: number }>,
    text: [] as Array<{ color: string; count: number }>,
    background: [] as Array<{ color: string; count: number }>
  };

  // Classify all colors
  for (const [color, { count, contexts }] of Object.entries(colorUsage)) {
    const type = classifyColor(color);
    classified[type].push({ color, count });
  }

  // Sort each category by usage count
  Object.values(classified).forEach(arr => arr.sort((a, b) => b.count - a.count));

  // Generate semantic tokens
  const tokens = {
    // Primary accent (most used saturated color)
    primary: classified.accent[0]?.color || '#3b82f6',

    // Secondary accent
    secondary: classified.accent[1]?.color || '#6366f1',

    // Main text color (most used dark color)
    foreground: classified.text[0]?.color || '#1e293b',

    // Muted text
    mutedForeground: classified.neutral.find(c => isLightish(c.color))?.color || '#64748b',

    // Main background
    background: classified.background[0]?.color || '#ffffff',

    // Card/surface background
    card: classified.background[1]?.color || '#f8fafc',

    // Border color
    border: classified.neutral.find(c => isBorderLike(c.color))?.color || '#e2e8f0',

    // Success, warning, error (detect by hue)
    success: findByHue(classified.accent, 120, 60) || '#22c55e', // Green
    warning: findByHue(classified.accent, 45, 30) || '#f59e0b',  // Orange/Yellow
    destructive: findByHue(classified.accent, 0, 30) || '#ef4444', // Red
  };

  return tokens;
}

function findByHue(colors: Array<{ color: string }>, targetHue: number, tolerance: number) {
  for (const { color } of colors) {
    const { h } = hexToHSL(color);
    if (Math.abs(h - targetHue) < tolerance || Math.abs(h - targetHue + 360) < tolerance) {
      return color;
    }
  }
  return null;
}
```

---

## 3. Typography Token Generation

### 3.1 Font Family Extraction

```typescript
function generateTypographyTokens(typography: Record<string, TypographyInfo>) {
  // Find most common font families
  const families: Record<string, number> = {};
  const sizes: Record<string, number> = {};
  const weights: Record<string, number> = {};

  for (const [key, info] of Object.entries(typography)) {
    const family = normalizeFontFamily(info.family);
    families[family] = (families[family] || 0) + info.count;
    sizes[info.size] = (sizes[info.size] || 0) + info.count;
    weights[info.weight] = (weights[info.weight] || 0) + info.count;
  }

  // Sort by usage
  const sortedFamilies = Object.entries(families).sort((a, b) => b[1] - a[1]);
  const sortedSizes = Object.entries(sizes).sort((a, b) => b[1] - a[1]);

  return {
    fontFamily: {
      sans: sortedFamilies[0]?.[0] || 'system-ui, sans-serif',
      mono: sortedFamilies.find(([f]) => isMonospace(f))?.[0] || 'monospace'
    },
    fontSize: {
      xs: '12px',
      sm: '14px',
      base: detectBaseSize(sortedSizes) || '16px',
      lg: '18px',
      xl: '20px',
      '2xl': '24px',
      '3xl': '30px',
      '4xl': '36px'
    },
    fontWeight: {
      normal: '400',
      medium: '500',
      semibold: '600',
      bold: '700'
    },
    lineHeight: {
      tight: '1.25',
      normal: '1.5',
      relaxed: '1.75'
    }
  };
}

function normalizeFontFamily(family: string): string {
  // Remove quotes and fallbacks
  return family.split(',')[0].replace(/["']/g, '').trim();
}
```

---

## 4. Spacing Token Generation

### 4.1 Spacing Normalization

```typescript
function generateSpacingTokens(spacing: Record<string, { count: number }>) {
  const values: number[] = [];

  for (const [value] of Object.entries(spacing)) {
    const px = parsePixels(value);
    if (px && px > 0 && px <= 100) {
      values.push(px);
    }
  }

  // Normalize to 4px grid
  const normalized = [...new Set(values.map(v => Math.round(v / 4) * 4))].sort((a, b) => a - b);

  // Generate token map
  const tokens: Record<string, string> = {};
  const standardScale = [0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96];

  standardScale.forEach(px => {
    if (normalized.some(v => Math.abs(v - px) <= 2)) {
      const name = px === 0 ? '0' : String(px / 4);
      tokens[name] = `${px}px`;
    }
  });

  return tokens;
}

function parsePixels(value: string): number | null {
  const match = value.match(/(\d+(?:\.\d+)?)\s*px/);
  return match ? parseFloat(match[1]) : null;
}
```

---

## 5. Border & Shadow Tokens

### 5.1 Border Radius

```typescript
function generateBorderTokens(borders: Record<string, BorderInfo>) {
  const radii: Record<string, number> = {};

  for (const [, info] of Object.entries(borders)) {
    const radius = parsePixels(info.radius);
    if (radius !== null) {
      radii[info.radius] = (radii[info.radius] || 0) + info.count;
    }
  }

  // Map to semantic names
  const sorted = Object.entries(radii).sort((a, b) => b[1] - a[1]);

  return {
    none: '0px',
    sm: sorted.find(([r]) => parsePixels(r)! <= 4)?.[0] || '4px',
    md: sorted.find(([r]) => parsePixels(r)! > 4 && parsePixels(r)! <= 8)?.[0] || '6px',
    lg: sorted.find(([r]) => parsePixels(r)! > 8 && parsePixels(r)! <= 12)?.[0] || '8px',
    xl: sorted.find(([r]) => parsePixels(r)! > 12)?.[0] || '12px',
    full: '9999px'
  };
}
```

### 5.2 Box Shadow

```typescript
function generateShadowTokens(shadows: Record<string, { count: number }>) {
  const sorted = Object.entries(shadows).sort((a, b) => b[1] - a[1]);

  return {
    sm: sorted[2]?.[0] || '0 1px 2px 0 rgb(0 0 0 / 0.05)',
    md: sorted[1]?.[0] || '0 4px 6px -1px rgb(0 0 0 / 0.1)',
    lg: sorted[0]?.[0] || '0 10px 15px -3px rgb(0 0 0 / 0.1)'
  };
}
```

---

## 6. tokens.ts Output Format

```typescript
// design-system/tokens.ts

export const tokens = {
  colors: {
    primary: '#3b82f6',
    secondary: '#6366f1',
    foreground: '#1e293b',
    mutedForeground: '#64748b',
    background: '#ffffff',
    card: '#f8fafc',
    border: '#e2e8f0',
    success: '#22c55e',
    warning: '#f59e0b',
    destructive: '#ef4444',
  },
  typography: {
    fontFamily: {
      sans: 'Pretendard, system-ui, sans-serif',
      mono: 'JetBrains Mono, monospace',
    },
    fontSize: {
      xs: '12px',
      sm: '14px',
      base: '16px',
      lg: '18px',
      xl: '20px',
      '2xl': '24px',
      '3xl': '30px',
      '4xl': '36px',
    },
    fontWeight: {
      normal: '400',
      medium: '500',
      semibold: '600',
      bold: '700',
    },
  },
  spacing: {
    '0': '0px',
    '1': '4px',
    '2': '8px',
    '3': '12px',
    '4': '16px',
    '5': '20px',
    '6': '24px',
    '8': '32px',
    '10': '40px',
    '12': '48px',
  },
  borderRadius: {
    none: '0px',
    sm: '4px',
    md: '6px',
    lg: '8px',
    xl: '12px',
    full: '9999px',
  },
  boxShadow: {
    sm: '0 1px 2px 0 rgb(0 0 0 / 0.05)',
    md: '0 4px 6px -1px rgb(0 0 0 / 0.1)',
    lg: '0 10px 15px -3px rgb(0 0 0 / 0.1)',
  },
} as const;

export type Tokens = typeof tokens;
```

---

## 7. tailwind.config.ts Output Format

```typescript
// design-system/tailwind.config.ts

import type { Config } from 'tailwindcss';
import { tokens } from './tokens';

export default {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: tokens.colors.primary,
          foreground: '#ffffff',
        },
        secondary: {
          DEFAULT: tokens.colors.secondary,
          foreground: '#ffffff',
        },
        background: tokens.colors.background,
        foreground: tokens.colors.foreground,
        muted: {
          DEFAULT: tokens.colors.card,
          foreground: tokens.colors.mutedForeground,
        },
        card: {
          DEFAULT: tokens.colors.card,
          foreground: tokens.colors.foreground,
        },
        border: tokens.colors.border,
        destructive: {
          DEFAULT: tokens.colors.destructive,
          foreground: '#ffffff',
        },
        success: tokens.colors.success,
        warning: tokens.colors.warning,
      },
      fontFamily: {
        sans: [tokens.typography.fontFamily.sans],
        mono: [tokens.typography.fontFamily.mono],
      },
      fontSize: tokens.typography.fontSize,
      borderRadius: tokens.borderRadius,
      boxShadow: tokens.boxShadow,
    },
  },
  plugins: [],
} satisfies Config;
```

---

## 8. Token Usage in TSX

### 8.1 Before (Direct Colors)

```tsx
<div className="bg-blue-500 text-white">
  <span className="text-gray-600">Label</span>
</div>
```

### 8.2 After (Token-Based)

```tsx
<div className="bg-primary text-primary-foreground">
  <span className="text-muted-foreground">Label</span>
</div>
```

### 8.3 Token Reference Table

| Original Value | Token | Tailwind Class |
|----------------|-------|----------------|
| `#3b82f6` | `colors.primary` | `bg-primary`, `text-primary` |
| `#1e293b` | `colors.foreground` | `text-foreground` |
| `#64748b` | `colors.mutedForeground` | `text-muted-foreground` |
| `#ffffff` | `colors.background` | `bg-background` |
| `#f8fafc` | `colors.card` | `bg-card` |
| `#e2e8f0` | `colors.border` | `border-border` |
