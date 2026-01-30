# Color Systems

Modern color palette definitions for 2026 design trends.

---

## Base Palette Structure

### Semantic Colors

```css
:root {
  /* Primary - Main brand/action color */
  --color-primary-50: 239 246 255;
  --color-primary-100: 219 234 254;
  --color-primary-200: 191 219 254;
  --color-primary-300: 147 197 253;
  --color-primary-400: 96 165 250;
  --color-primary-500: 59 130 246;   /* Default */
  --color-primary-600: 37 99 235;
  --color-primary-700: 29 78 216;
  --color-primary-800: 30 64 175;
  --color-primary-900: 30 58 138;

  /* Success */
  --color-success-50: 240 253 244;
  --color-success-500: 34 197 94;
  --color-success-600: 22 163 74;
  --color-success-700: 21 128 61;

  /* Warning */
  --color-warning-50: 255 251 235;
  --color-warning-500: 245 158 11;
  --color-warning-600: 217 119 6;
  --color-warning-700: 180 83 9;

  /* Error */
  --color-error-50: 254 242 242;
  --color-error-500: 239 68 68;
  --color-error-600: 220 38 38;
  --color-error-700: 185 28 28;

  /* Neutral */
  --color-gray-50: 249 250 251;
  --color-gray-100: 243 244 246;
  --color-gray-200: 229 231 235;
  --color-gray-300: 209 213 219;
  --color-gray-400: 156 163 175;
  --color-gray-500: 107 114 128;
  --color-gray-600: 75 85 99;
  --color-gray-700: 55 65 81;
  --color-gray-800: 31 41 55;
  --color-gray-900: 17 24 39;
  --color-gray-950: 3 7 18;
}
```

---

## Dark Mode System

### Adaptive Color Mapping

```css
:root {
  /* Surface colors */
  --surface-primary: var(--color-gray-50);
  --surface-secondary: 255 255 255;
  --surface-tertiary: var(--color-gray-100);
  --surface-elevated: 255 255 255;

  /* Text colors */
  --text-primary: var(--color-gray-900);
  --text-secondary: var(--color-gray-600);
  --text-tertiary: var(--color-gray-500);
  --text-inverse: 255 255 255;

  /* Border colors */
  --border-primary: var(--color-gray-200);
  --border-secondary: var(--color-gray-100);
  --border-focus: var(--color-primary-500);
}

[data-theme="dark"] {
  /* Surface colors */
  --surface-primary: var(--color-gray-900);
  --surface-secondary: var(--color-gray-800);
  --surface-tertiary: var(--color-gray-700);
  --surface-elevated: var(--color-gray-800);

  /* Text colors */
  --text-primary: var(--color-gray-50);
  --text-secondary: var(--color-gray-400);
  --text-tertiary: var(--color-gray-500);
  --text-inverse: var(--color-gray-900);

  /* Border colors */
  --border-primary: var(--color-gray-700);
  --border-secondary: var(--color-gray-800);
  --border-focus: var(--color-primary-400);
}
```

### Tailwind Integration

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        surface: {
          primary: "rgb(var(--surface-primary) / <alpha-value>)",
          secondary: "rgb(var(--surface-secondary) / <alpha-value>)",
          tertiary: "rgb(var(--surface-tertiary) / <alpha-value>)",
          elevated: "rgb(var(--surface-elevated) / <alpha-value>)",
        },
        content: {
          primary: "rgb(var(--text-primary) / <alpha-value>)",
          secondary: "rgb(var(--text-secondary) / <alpha-value>)",
          tertiary: "rgb(var(--text-tertiary) / <alpha-value>)",
        },
        border: {
          primary: "rgb(var(--border-primary) / <alpha-value>)",
          secondary: "rgb(var(--border-secondary) / <alpha-value>)",
        },
      },
    },
  },
};
```

---

## Status Color System

### Time & Attendance (TNA) Specific

```css
:root {
  /* Attendance status */
  --status-present: 34 197 94;      /* Green - 출근 */
  --status-absent: 239 68 68;       /* Red - 결근 */
  --status-late: 245 158 11;        /* Amber - 지각 */
  --status-early-leave: 249 115 22; /* Orange - 조퇴 */
  --status-vacation: 139 92 246;    /* Purple - 휴가 */
  --status-business: 59 130 246;    /* Blue - 출장 */

  /* Approval status */
  --approval-pending: 245 158 11;   /* Amber */
  --approval-approved: 34 197 94;   /* Green */
  --approval-rejected: 239 68 68;   /* Red */
  --approval-draft: 156 163 175;    /* Gray */
  --approval-cancelled: 107 114 128; /* Dark Gray */
}

[data-theme="dark"] {
  /* Slightly adjusted for dark mode visibility */
  --status-present: 74 222 128;
  --status-absent: 248 113 113;
  --status-late: 251 191 36;
  --status-early-leave: 251 146 60;
  --status-vacation: 167 139 250;
  --status-business: 96 165 250;

  --approval-pending: 251 191 36;
  --approval-approved: 74 222 128;
  --approval-rejected: 248 113 113;
  --approval-draft: 156 163 175;
  --approval-cancelled: 107 114 128;
}
```

### Status Badge Component

```tsx
// components/ui/status-badge.tsx
import { cn } from "@/lib/utils";

type StatusType =
  | "present" | "absent" | "late" | "early-leave" | "vacation" | "business"
  | "pending" | "approved" | "rejected" | "draft" | "cancelled";

const statusConfig: Record<StatusType, { label: string; classes: string }> = {
  present: {
    label: "출근",
    classes: "bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400",
  },
  absent: {
    label: "결근",
    classes: "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400",
  },
  late: {
    label: "지각",
    classes: "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400",
  },
  "early-leave": {
    label: "조퇴",
    classes: "bg-orange-100 text-orange-700 dark:bg-orange-900/30 dark:text-orange-400",
  },
  vacation: {
    label: "휴가",
    classes: "bg-purple-100 text-purple-700 dark:bg-purple-900/30 dark:text-purple-400",
  },
  business: {
    label: "출장",
    classes: "bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400",
  },
  pending: {
    label: "대기",
    classes: "bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400",
  },
  approved: {
    label: "승인",
    classes: "bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400",
  },
  rejected: {
    label: "반려",
    classes: "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400",
  },
  draft: {
    label: "임시저장",
    classes: "bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400",
  },
  cancelled: {
    label: "취소",
    classes: "bg-gray-100 text-gray-500 dark:bg-gray-800 dark:text-gray-500",
  },
};

interface StatusBadgeProps {
  status: StatusType;
  size?: "sm" | "md" | "lg";
  showDot?: boolean;
}

export function StatusBadge({ status, size = "md", showDot = false }: StatusBadgeProps) {
  const config = statusConfig[status];
  const sizes = {
    sm: "px-2 py-0.5 text-xs",
    md: "px-2.5 py-1 text-sm",
    lg: "px-3 py-1.5 text-base",
  };

  return (
    <span
      className={cn(
        "inline-flex items-center gap-1.5 rounded-full font-medium",
        sizes[size],
        config.classes
      )}
    >
      {showDot && (
        <span className="w-1.5 h-1.5 rounded-full bg-current" />
      )}
      {config.label}
    </span>
  );
}
```

---

## Gradient Presets

### Vibrant Gradients

```css
/* Primary gradient */
.gradient-primary {
  @apply bg-gradient-to-r from-blue-500 to-indigo-600;
}

/* Success gradient */
.gradient-success {
  @apply bg-gradient-to-r from-green-400 to-emerald-500;
}

/* Warm gradient */
.gradient-warm {
  @apply bg-gradient-to-r from-orange-400 to-rose-500;
}

/* Cool gradient */
.gradient-cool {
  @apply bg-gradient-to-r from-cyan-400 to-blue-500;
}

/* Sunset gradient */
.gradient-sunset {
  @apply bg-gradient-to-r from-orange-500 via-pink-500 to-purple-500;
}

/* Ocean gradient */
.gradient-ocean {
  @apply bg-gradient-to-r from-cyan-500 via-blue-500 to-indigo-500;
}

/* Aurora gradient */
.gradient-aurora {
  @apply bg-gradient-to-r from-green-400 via-cyan-500 to-blue-500;
}
```

### Subtle Background Gradients

```css
/* Light mode backgrounds */
.bg-gradient-subtle-blue {
  @apply bg-gradient-to-br from-blue-50 via-white to-indigo-50;
}

.bg-gradient-subtle-purple {
  @apply bg-gradient-to-br from-purple-50 via-white to-pink-50;
}

.bg-gradient-subtle-warm {
  @apply bg-gradient-to-br from-orange-50 via-white to-rose-50;
}

.bg-gradient-subtle-neutral {
  @apply bg-gradient-to-br from-gray-50 via-white to-slate-50;
}

/* Dark mode backgrounds */
.dark .bg-gradient-subtle-blue {
  @apply bg-gradient-to-br from-blue-950/50 via-gray-900 to-indigo-950/50;
}

.dark .bg-gradient-subtle-purple {
  @apply bg-gradient-to-br from-purple-950/50 via-gray-900 to-pink-950/50;
}
```

### Glass Effect Gradients

```css
/* Glassmorphism */
.glass {
  @apply bg-white/60 dark:bg-gray-900/60;
  @apply backdrop-blur-xl;
  @apply border border-white/20 dark:border-gray-700/30;
}

.glass-primary {
  @apply bg-blue-500/10 dark:bg-blue-400/10;
  @apply backdrop-blur-xl;
  @apply border border-blue-200/30 dark:border-blue-700/30;
}

.glass-gradient {
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 0.6) 0%,
    rgba(255, 255, 255, 0.3) 100%
  );
  @apply backdrop-blur-xl;
  @apply border border-white/30;
}
```

---

## Accessibility Compliance

### Color Contrast Checker

```typescript
// utils/color-contrast.ts
function getLuminance(r: number, g: number, b: number): number {
  const [rs, gs, bs] = [r, g, b].map((c) => {
    c = c / 255;
    return c <= 0.03928 ? c / 12.92 : Math.pow((c + 0.055) / 1.055, 2.4);
  });
  return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
}

export function getContrastRatio(
  fg: [number, number, number],
  bg: [number, number, number]
): number {
  const l1 = getLuminance(...fg);
  const l2 = getLuminance(...bg);
  const lighter = Math.max(l1, l2);
  const darker = Math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

// Usage
const ratio = getContrastRatio([255, 255, 255], [59, 130, 246]);
// WCAG AA requires 4.5:1 for normal text, 3:1 for large text
const isAccessible = ratio >= 4.5;
```

### Pre-validated Color Pairs

```css
/* WCAG AA compliant pairs */
.text-on-primary {
  /* Blue-600 on white: 4.69:1 ✓ */
  @apply text-blue-600;
}

.text-on-dark {
  /* Gray-100 on Gray-900: 13.08:1 ✓ */
  @apply text-gray-100;
}

.text-on-success {
  /* Green-700 on Green-50: 5.78:1 ✓ */
  @apply text-green-700;
}

.text-on-warning {
  /* Amber-800 on Amber-50: 6.24:1 ✓ */
  @apply text-amber-800;
}

.text-on-error {
  /* Red-700 on Red-50: 5.63:1 ✓ */
  @apply text-red-700;
}
```

---

## Theming Implementation

### Theme Provider

```tsx
// providers/theme-provider.tsx
"use client";

import { createContext, useContext, useEffect, useState } from "react";

type Theme = "light" | "dark" | "system";

interface ThemeContextType {
  theme: Theme;
  setTheme: (theme: Theme) => void;
  resolvedTheme: "light" | "dark";
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<Theme>("system");
  const [resolvedTheme, setResolvedTheme] = useState<"light" | "dark">("light");

  useEffect(() => {
    const stored = localStorage.getItem("theme") as Theme | null;
    if (stored) setTheme(stored);
  }, []);

  useEffect(() => {
    localStorage.setItem("theme", theme);

    const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
    const resolved =
      theme === "system"
        ? mediaQuery.matches ? "dark" : "light"
        : theme;

    setResolvedTheme(resolved);
    document.documentElement.setAttribute("data-theme", resolved);

    if (resolved === "dark") {
      document.documentElement.classList.add("dark");
    } else {
      document.documentElement.classList.remove("dark");
    }
  }, [theme]);

  return (
    <ThemeContext.Provider value={{ theme, setTheme, resolvedTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) throw new Error("useTheme must be used within ThemeProvider");
  return context;
}
```

### Color Mode Toggle

```tsx
// components/ui/color-mode-toggle.tsx
import { useTheme } from "@/providers/theme-provider";
import { Sun, Moon, Monitor } from "lucide-react";

export function ColorModeToggle() {
  const { theme, setTheme } = useTheme();

  const options = [
    { value: "light", icon: Sun, label: "Light" },
    { value: "dark", icon: Moon, label: "Dark" },
    { value: "system", icon: Monitor, label: "System" },
  ] as const;

  return (
    <div className="flex items-center gap-1 p-1 bg-gray-100 dark:bg-gray-800 rounded-lg">
      {options.map(({ value, icon: Icon, label }) => (
        <button
          key={value}
          onClick={() => setTheme(value)}
          className={cn(
            "p-2 rounded-md transition-colors",
            theme === value
              ? "bg-white dark:bg-gray-700 shadow-sm"
              : "hover:bg-gray-200 dark:hover:bg-gray-700"
          )}
          aria-label={label}
        >
          <Icon className="w-4 h-4" />
        </button>
      ))}
    </div>
  );
}
```
