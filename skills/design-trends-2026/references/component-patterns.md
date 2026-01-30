# Component Patterns by Design Trend

Ready-to-use component patterns applying 2026 design trends.

---

## Organic Shapes

### Organic Card

```tsx
// components/ui/organic-card.tsx
import { cn } from "@/lib/utils";

interface OrganicCardProps {
  children: React.ReactNode;
  variant?: "default" | "gradient" | "glass";
  className?: string;
}

export function OrganicCard({
  children,
  variant = "default",
  className
}: OrganicCardProps) {
  const variants = {
    default: "bg-white shadow-lg shadow-gray-200/50",
    gradient: "bg-gradient-to-br from-blue-50 via-white to-purple-50",
    glass: "bg-white/70 backdrop-blur-xl border border-white/50"
  };

  return (
    <div
      className={cn(
        "rounded-[28px] p-6",
        "transition-all duration-300",
        "hover:shadow-xl hover:shadow-gray-200/60",
        "hover:-translate-y-1",
        variants[variant],
        className
      )}
    >
      {children}
    </div>
  );
}
```

### Blob Background

```tsx
// components/ui/blob-background.tsx
export function BlobBackground() {
  return (
    <div className="absolute inset-0 -z-10 overflow-hidden">
      {/* Primary blob */}
      <div
        className="absolute top-1/4 -left-1/4 w-[600px] h-[600px]
          bg-gradient-to-r from-purple-400 to-pink-400
          rounded-full blur-3xl opacity-20
          animate-blob"
      />
      {/* Secondary blob */}
      <div
        className="absolute bottom-1/4 -right-1/4 w-[500px] h-[500px]
          bg-gradient-to-r from-blue-400 to-cyan-400
          rounded-full blur-3xl opacity-20
          animate-blob animation-delay-2000"
      />
      {/* Tertiary blob */}
      <div
        className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2
          w-[400px] h-[400px]
          bg-gradient-to-r from-amber-300 to-orange-400
          rounded-full blur-3xl opacity-15
          animate-blob animation-delay-4000"
      />
    </div>
  );
}

// Add to tailwind.config.js
// animation: {
//   blob: "blob 7s infinite",
// },
// keyframes: {
//   blob: {
//     "0%": { transform: "translate(0px, 0px) scale(1)" },
//     "33%": { transform: "translate(30px, -50px) scale(1.1)" },
//     "66%": { transform: "translate(-20px, 20px) scale(0.9)" },
//     "100%": { transform: "translate(0px, 0px) scale(1)" },
//   },
// },
```

---

## Light Skeuomorphism

### Neumorphic Card

```tsx
// components/ui/neo-card.tsx
import { cn } from "@/lib/utils";

interface NeoCardProps {
  children: React.ReactNode;
  pressed?: boolean;
  className?: string;
}

export function NeoCard({ children, pressed = false, className }: NeoCardProps) {
  return (
    <div
      className={cn(
        "bg-gray-100 rounded-2xl p-6",
        "transition-shadow duration-200",
        pressed
          ? "shadow-[inset_6px_6px_12px_#d1d1d1,inset_-6px_-6px_12px_#ffffff]"
          : "shadow-[8px_8px_16px_#d1d1d1,-8px_-8px_16px_#ffffff]",
        className
      )}
    >
      {children}
    </div>
  );
}
```

### Neumorphic Button

```tsx
// components/ui/neo-button.tsx
import { cn } from "@/lib/utils";
import { forwardRef } from "react";

interface NeoButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "raised" | "flat";
  size?: "sm" | "md" | "lg";
}

export const NeoButton = forwardRef<HTMLButtonElement, NeoButtonProps>(
  ({ className, variant = "raised", size = "md", children, ...props }, ref) => {
    const sizes = {
      sm: "px-4 py-2 text-sm",
      md: "px-6 py-3 text-base",
      lg: "px-8 py-4 text-lg",
    };

    const variants = {
      raised: `
        shadow-[6px_6px_12px_#d1d1d1,-6px_-6px_12px_#ffffff]
        hover:shadow-[4px_4px_8px_#d1d1d1,-4px_-4px_8px_#ffffff]
        active:shadow-[inset_4px_4px_8px_#d1d1d1,inset_-4px_-4px_8px_#ffffff]
      `,
      flat: `
        shadow-[2px_2px_4px_#d1d1d1,-2px_-2px_4px_#ffffff]
        hover:shadow-[4px_4px_8px_#d1d1d1,-4px_-4px_8px_#ffffff]
        active:shadow-[inset_2px_2px_4px_#d1d1d1,inset_-2px_-2px_4px_#ffffff]
      `,
    };

    return (
      <button
        ref={ref}
        className={cn(
          "bg-gray-100 rounded-xl font-medium",
          "text-gray-700",
          "transition-all duration-150",
          "focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2",
          sizes[size],
          variants[variant],
          className
        )}
        {...props}
      >
        {children}
      </button>
    );
  }
);
NeoButton.displayName = "NeoButton";
```

### Neumorphic Input

```tsx
// components/ui/neo-input.tsx
import { cn } from "@/lib/utils";
import { forwardRef } from "react";

interface NeoInputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
}

export const NeoInput = forwardRef<HTMLInputElement, NeoInputProps>(
  ({ className, label, error, ...props }, ref) => {
    return (
      <div className="space-y-2">
        {label && (
          <label className="text-sm font-medium text-gray-600">
            {label}
          </label>
        )}
        <input
          ref={ref}
          className={cn(
            "w-full bg-gray-100 rounded-xl px-4 py-3",
            "shadow-[inset_3px_3px_6px_#d1d1d1,inset_-3px_-3px_6px_#ffffff]",
            "text-gray-700 placeholder:text-gray-400",
            "border-none outline-none",
            "focus:shadow-[inset_4px_4px_8px_#d1d1d1,inset_-4px_-4px_8px_#ffffff]",
            "transition-shadow duration-150",
            error && "ring-2 ring-red-400",
            className
          )}
          {...props}
        />
        {error && (
          <p className="text-sm text-red-500">{error}</p>
        )}
      </div>
    );
  }
);
NeoInput.displayName = "NeoInput";
```

---

## Glassmorphism

### Glass Card

```tsx
// components/ui/glass-card.tsx
import { cn } from "@/lib/utils";

interface GlassCardProps {
  children: React.ReactNode;
  blur?: "sm" | "md" | "lg" | "xl";
  className?: string;
}

export function GlassCard({
  children,
  blur = "lg",
  className
}: GlassCardProps) {
  const blurLevels = {
    sm: "backdrop-blur-sm",
    md: "backdrop-blur-md",
    lg: "backdrop-blur-lg",
    xl: "backdrop-blur-xl",
  };

  return (
    <div
      className={cn(
        "bg-white/60 dark:bg-gray-900/60",
        blurLevels[blur],
        "rounded-2xl",
        "border border-white/30 dark:border-gray-700/30",
        "shadow-lg shadow-gray-200/20 dark:shadow-black/20",
        "p-6",
        className
      )}
    >
      {children}
    </div>
  );
}
```

### Glass Navigation

```tsx
// components/ui/glass-nav.tsx
export function GlassNav({ children }: { children: React.ReactNode }) {
  return (
    <nav
      className="
        fixed top-4 left-1/2 -translate-x-1/2 z-50
        px-6 py-3
        bg-white/70 dark:bg-gray-900/70
        backdrop-blur-xl
        rounded-full
        border border-white/30 dark:border-gray-700/30
        shadow-lg shadow-gray-200/30
      "
    >
      {children}
    </nav>
  );
}
```

---

## Micro-Interactions

### Animated Button

```tsx
// components/ui/animated-button.tsx
import { motion } from "framer-motion";
import { cn } from "@/lib/utils";

interface AnimatedButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: "primary" | "secondary" | "ghost";
  className?: string;
}

export function AnimatedButton({
  children,
  onClick,
  variant = "primary",
  className,
}: AnimatedButtonProps) {
  const variants = {
    primary: "bg-blue-600 text-white hover:bg-blue-700",
    secondary: "bg-gray-100 text-gray-700 hover:bg-gray-200",
    ghost: "bg-transparent text-gray-600 hover:bg-gray-100",
  };

  return (
    <motion.button
      className={cn(
        "px-6 py-3 rounded-xl font-medium",
        "transition-colors duration-200",
        "focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2",
        variants[variant],
        className
      )}
      onClick={onClick}
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
      transition={{ type: "spring", stiffness: 400, damping: 17 }}
    >
      {children}
    </motion.button>
  );
}
```

### Card with Hover Effect

```tsx
// components/ui/hover-card.tsx
import { motion } from "framer-motion";
import { cn } from "@/lib/utils";

interface HoverCardProps {
  children: React.ReactNode;
  className?: string;
}

export function HoverCard({ children, className }: HoverCardProps) {
  return (
    <motion.div
      className={cn(
        "bg-white rounded-2xl p-6",
        "border border-gray-100",
        "shadow-sm",
        className
      )}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      whileHover={{
        y: -4,
        boxShadow: "0 20px 40px rgba(0,0,0,0.08)",
        transition: { duration: 0.2 },
      }}
      transition={{ duration: 0.3 }}
    >
      {children}
    </motion.div>
  );
}
```

### Success Animation

```tsx
// components/ui/success-check.tsx
import { motion } from "framer-motion";

export function SuccessCheck() {
  return (
    <motion.div
      className="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center"
      initial={{ scale: 0 }}
      animate={{ scale: 1 }}
      transition={{ type: "spring", stiffness: 200, damping: 15 }}
    >
      <motion.svg
        className="w-8 h-8 text-green-600"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth={3}
        strokeLinecap="round"
        strokeLinejoin="round"
      >
        <motion.path
          d="M5 13l4 4L19 7"
          initial={{ pathLength: 0 }}
          animate={{ pathLength: 1 }}
          transition={{ delay: 0.2, duration: 0.4 }}
        />
      </motion.svg>
    </motion.div>
  );
}
```

---

## Dark Mode

### Theme Toggle

```tsx
// components/ui/theme-toggle.tsx
import { motion } from "framer-motion";
import { useTheme } from "next-themes";
import { Sun, Moon } from "lucide-react";

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  const isDark = theme === "dark";

  return (
    <button
      onClick={() => setTheme(isDark ? "light" : "dark")}
      className="
        relative w-14 h-8 rounded-full
        bg-gray-200 dark:bg-gray-700
        transition-colors duration-300
        focus:outline-none focus:ring-2 focus:ring-blue-400
      "
      aria-label="Toggle theme"
    >
      <motion.div
        className="
          absolute top-1 w-6 h-6 rounded-full
          bg-white shadow-md
          flex items-center justify-center
        "
        animate={{ left: isDark ? "calc(100% - 28px)" : "4px" }}
        transition={{ type: "spring", stiffness: 500, damping: 30 }}
      >
        {isDark ? (
          <Moon className="w-4 h-4 text-gray-700" />
        ) : (
          <Sun className="w-4 h-4 text-amber-500" />
        )}
      </motion.div>
    </button>
  );
}
```

### Adaptive Card

```tsx
// components/ui/adaptive-card.tsx
import { cn } from "@/lib/utils";

interface AdaptiveCardProps {
  children: React.ReactNode;
  className?: string;
}

export function AdaptiveCard({ children, className }: AdaptiveCardProps) {
  return (
    <div
      className={cn(
        // Light mode
        "bg-white border-gray-100 shadow-gray-200/50",
        // Dark mode
        "dark:bg-gray-800 dark:border-gray-700 dark:shadow-black/20",
        // Common
        "rounded-xl border shadow-lg p-6",
        "transition-colors duration-300",
        className
      )}
    >
      {children}
    </div>
  );
}
```

---

## Data Visualization

### Stat Card with Trend

```tsx
// components/ui/stat-card.tsx
import { cn } from "@/lib/utils";
import { TrendingUp, TrendingDown, Minus } from "lucide-react";

interface StatCardProps {
  title: string;
  value: string | number;
  trend?: number; // percentage change
  trendLabel?: string;
  icon?: React.ReactNode;
}

export function StatCard({
  title,
  value,
  trend,
  trendLabel,
  icon
}: StatCardProps) {
  const getTrendIcon = () => {
    if (!trend) return <Minus className="w-4 h-4" />;
    return trend > 0
      ? <TrendingUp className="w-4 h-4" />
      : <TrendingDown className="w-4 h-4" />;
  };

  const getTrendColor = () => {
    if (!trend) return "text-gray-500 bg-gray-100";
    return trend > 0
      ? "text-green-600 bg-green-100 dark:bg-green-900/30"
      : "text-red-600 bg-red-100 dark:bg-red-900/30";
  };

  return (
    <div className="bg-white dark:bg-gray-800 rounded-xl p-6 border border-gray-100 dark:border-gray-700">
      <div className="flex items-center justify-between mb-4">
        <span className="text-sm font-medium text-gray-500 dark:text-gray-400">
          {title}
        </span>
        {icon && (
          <div className="p-2 bg-blue-50 dark:bg-blue-900/30 rounded-lg">
            {icon}
          </div>
        )}
      </div>

      <div className="space-y-2">
        <p className="text-3xl font-bold text-gray-900 dark:text-white font-mono">
          {value}
        </p>

        {trend !== undefined && (
          <div className="flex items-center gap-2">
            <span className={cn(
              "inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs font-medium",
              getTrendColor()
            )}>
              {getTrendIcon()}
              {Math.abs(trend)}%
            </span>
            {trendLabel && (
              <span className="text-xs text-gray-500">
                {trendLabel}
              </span>
            )}
          </div>
        )}
      </div>
    </div>
  );
}
```

### Mini Sparkline

```tsx
// components/ui/sparkline.tsx
interface SparklineProps {
  data: number[];
  color?: string;
  height?: number;
}

export function Sparkline({
  data,
  color = "#3b82f6",
  height = 40
}: SparklineProps) {
  const max = Math.max(...data);
  const min = Math.min(...data);
  const range = max - min || 1;

  const points = data
    .map((value, index) => {
      const x = (index / (data.length - 1)) * 100;
      const y = height - ((value - min) / range) * height;
      return `${x},${y}`;
    })
    .join(" ");

  return (
    <svg
      viewBox={`0 0 100 ${height}`}
      className="w-full"
      preserveAspectRatio="none"
    >
      <polyline
        points={points}
        fill="none"
        stroke={color}
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}
```

---

## Gamification

### Progress Ring

```tsx
// components/ui/progress-ring.tsx
import { cn } from "@/lib/utils";

interface ProgressRingProps {
  progress: number; // 0-100
  size?: number;
  strokeWidth?: number;
  color?: string;
  label?: string;
}

export function ProgressRing({
  progress,
  size = 80,
  strokeWidth = 8,
  color = "#3b82f6",
  label,
}: ProgressRingProps) {
  const radius = (size - strokeWidth) / 2;
  const circumference = radius * 2 * Math.PI;
  const offset = circumference - (progress / 100) * circumference;

  return (
    <div className="relative inline-flex items-center justify-center">
      <svg width={size} height={size} className="-rotate-90">
        {/* Background circle */}
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke="currentColor"
          strokeWidth={strokeWidth}
          className="text-gray-200 dark:text-gray-700"
        />
        {/* Progress circle */}
        <circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          fill="none"
          stroke={color}
          strokeWidth={strokeWidth}
          strokeDasharray={circumference}
          strokeDashoffset={offset}
          strokeLinecap="round"
          className="transition-all duration-500 ease-out"
        />
      </svg>
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <span className="text-lg font-bold">{progress}%</span>
        {label && (
          <span className="text-xs text-gray-500">{label}</span>
        )}
      </div>
    </div>
  );
}
```

### Achievement Badge

```tsx
// components/ui/achievement-badge.tsx
import { cn } from "@/lib/utils";
import { motion } from "framer-motion";

interface AchievementBadgeProps {
  icon: string;
  title: string;
  unlocked?: boolean;
  rarity?: "common" | "rare" | "epic" | "legendary";
}

export function AchievementBadge({
  icon,
  title,
  unlocked = false,
  rarity = "common",
}: AchievementBadgeProps) {
  const rarityColors = {
    common: "from-gray-400 to-gray-500",
    rare: "from-blue-400 to-blue-600",
    epic: "from-purple-400 to-purple-600",
    legendary: "from-amber-400 to-orange-500",
  };

  return (
    <motion.div
      className={cn(
        "relative flex flex-col items-center gap-2 p-4",
        !unlocked && "opacity-50 grayscale"
      )}
      whileHover={unlocked ? { scale: 1.05 } : {}}
    >
      <div
        className={cn(
          "w-16 h-16 rounded-full",
          "flex items-center justify-center",
          "bg-gradient-to-br shadow-lg",
          rarityColors[rarity]
        )}
      >
        <span className="text-2xl">{icon}</span>
      </div>
      <span className="text-sm font-medium text-center">{title}</span>
      {unlocked && rarity !== "common" && (
        <div className="absolute -top-1 -right-1">
          <span className="flex h-3 w-3">
            <span className={cn(
              "animate-ping absolute inline-flex h-full w-full rounded-full opacity-75",
              rarity === "rare" && "bg-blue-400",
              rarity === "epic" && "bg-purple-400",
              rarity === "legendary" && "bg-amber-400"
            )} />
            <span className={cn(
              "relative inline-flex rounded-full h-3 w-3",
              rarity === "rare" && "bg-blue-500",
              rarity === "epic" && "bg-purple-500",
              rarity === "legendary" && "bg-amber-500"
            )} />
          </span>
        </div>
      )}
    </motion.div>
  );
}
```
