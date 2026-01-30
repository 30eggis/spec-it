# Motion Presets

Animation and micro-interaction presets for 2026 design trends.

---

## Philosophy

### Principles
1. **Purposeful**: Every animation should have a reason
2. **Quick**: Most interactions under 300ms
3. **Natural**: Use spring physics over linear easing
4. **Consistent**: Same action = same animation

### Duration Guidelines
| Type | Duration | Use Case |
|------|----------|----------|
| Micro | 100-150ms | Button press, toggles |
| Standard | 200-300ms | Page transitions, modals |
| Emphasis | 400-600ms | Success states, celebrations |
| Complex | 600-1000ms | 3D animations, storytelling |

---

## Framer Motion Presets

### Spring Configurations

```typescript
// motion-config.ts
export const springs = {
  // Snappy - buttons, toggles
  snappy: { type: "spring", stiffness: 400, damping: 30 },

  // Gentle - cards, modals
  gentle: { type: "spring", stiffness: 300, damping: 25 },

  // Bouncy - success states, playful elements
  bouncy: { type: "spring", stiffness: 500, damping: 15 },

  // Smooth - page transitions
  smooth: { type: "spring", stiffness: 200, damping: 20 },

  // Stiff - precise movements
  stiff: { type: "spring", stiffness: 600, damping: 35 },
};

export const easings = {
  easeOut: [0.0, 0.0, 0.2, 1],
  easeIn: [0.4, 0.0, 1, 1],
  easeInOut: [0.4, 0.0, 0.2, 1],
  sharp: [0.4, 0.0, 0.6, 1],
};
```

### Button Interactions

```typescript
// variants/button-variants.ts
export const buttonVariants = {
  idle: {
    scale: 1,
  },
  hover: {
    scale: 1.02,
    transition: { type: "spring", stiffness: 400, damping: 25 },
  },
  tap: {
    scale: 0.98,
    transition: { type: "spring", stiffness: 500, damping: 30 },
  },
  disabled: {
    opacity: 0.5,
    scale: 1,
  },
};

// Usage
<motion.button
  variants={buttonVariants}
  initial="idle"
  whileHover="hover"
  whileTap="tap"
>
  Click me
</motion.button>
```

### Card Animations

```typescript
// variants/card-variants.ts
export const cardVariants = {
  // Entrance animation
  hidden: {
    opacity: 0,
    y: 20,
  },
  visible: {
    opacity: 1,
    y: 0,
    transition: {
      type: "spring",
      stiffness: 300,
      damping: 25,
    },
  },
  // Hover effect
  hover: {
    y: -4,
    boxShadow: "0 20px 40px rgba(0,0,0,0.1)",
    transition: {
      type: "spring",
      stiffness: 400,
      damping: 25,
    },
  },
  // Exit animation
  exit: {
    opacity: 0,
    y: -10,
    transition: {
      duration: 0.2,
    },
  },
};

// Staggered children
export const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
      delayChildren: 0.1,
    },
  },
};
```

### Page Transitions

```typescript
// variants/page-variants.ts
export const pageVariants = {
  // Fade + slide up
  fadeSlideUp: {
    initial: { opacity: 0, y: 20 },
    animate: { opacity: 1, y: 0 },
    exit: { opacity: 0, y: -10 },
    transition: { duration: 0.3, ease: [0.0, 0.0, 0.2, 1] },
  },

  // Fade only
  fade: {
    initial: { opacity: 0 },
    animate: { opacity: 1 },
    exit: { opacity: 0 },
    transition: { duration: 0.2 },
  },

  // Slide from right
  slideRight: {
    initial: { opacity: 0, x: 20 },
    animate: { opacity: 1, x: 0 },
    exit: { opacity: 0, x: -20 },
    transition: { type: "spring", stiffness: 300, damping: 25 },
  },

  // Scale + fade
  scaleFade: {
    initial: { opacity: 0, scale: 0.95 },
    animate: { opacity: 1, scale: 1 },
    exit: { opacity: 0, scale: 0.95 },
    transition: { duration: 0.2 },
  },
};
```

### Modal Animations

```typescript
// variants/modal-variants.ts
export const modalOverlayVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: { duration: 0.2 },
  },
  exit: {
    opacity: 0,
    transition: { duration: 0.15 },
  },
};

export const modalContentVariants = {
  hidden: {
    opacity: 0,
    scale: 0.95,
    y: 10,
  },
  visible: {
    opacity: 1,
    scale: 1,
    y: 0,
    transition: {
      type: "spring",
      stiffness: 300,
      damping: 25,
    },
  },
  exit: {
    opacity: 0,
    scale: 0.95,
    y: 10,
    transition: { duration: 0.15 },
  },
};

// Bottom sheet (mobile)
export const bottomSheetVariants = {
  hidden: { y: "100%" },
  visible: {
    y: 0,
    transition: {
      type: "spring",
      stiffness: 300,
      damping: 30,
    },
  },
  exit: {
    y: "100%",
    transition: { duration: 0.2 },
  },
};
```

### Success/Error States

```typescript
// variants/feedback-variants.ts
export const successVariants = {
  hidden: { scale: 0, opacity: 0 },
  visible: {
    scale: 1,
    opacity: 1,
    transition: {
      type: "spring",
      stiffness: 200,
      damping: 15,
    },
  },
};

export const checkmarkPathVariants = {
  hidden: { pathLength: 0 },
  visible: {
    pathLength: 1,
    transition: {
      delay: 0.2,
      duration: 0.4,
      ease: "easeOut",
    },
  },
};

export const shakeVariants = {
  shake: {
    x: [0, -10, 10, -10, 10, 0],
    transition: { duration: 0.5 },
  },
};

export const pulseVariants = {
  pulse: {
    scale: [1, 1.05, 1],
    transition: {
      duration: 0.3,
      repeat: 2,
    },
  },
};
```

---

## CSS Animations

### Tailwind Config Extensions

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      animation: {
        // Entrances
        "fade-in": "fadeIn 0.3s ease-out",
        "fade-in-up": "fadeInUp 0.3s ease-out",
        "fade-in-down": "fadeInDown 0.3s ease-out",
        "slide-in-right": "slideInRight 0.3s ease-out",
        "slide-in-left": "slideInLeft 0.3s ease-out",
        "scale-in": "scaleIn 0.2s ease-out",

        // Continuous
        "pulse-slow": "pulse 3s ease-in-out infinite",
        "bounce-slow": "bounce 2s ease-in-out infinite",
        "spin-slow": "spin 3s linear infinite",
        "blob": "blob 7s infinite",
        "shimmer": "shimmer 2s linear infinite",

        // Feedback
        "shake": "shake 0.5s ease-in-out",
        "wiggle": "wiggle 0.3s ease-in-out",
      },
      keyframes: {
        fadeIn: {
          "0%": { opacity: "0" },
          "100%": { opacity: "1" },
        },
        fadeInUp: {
          "0%": { opacity: "0", transform: "translateY(10px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
        fadeInDown: {
          "0%": { opacity: "0", transform: "translateY(-10px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
        slideInRight: {
          "0%": { opacity: "0", transform: "translateX(20px)" },
          "100%": { opacity: "1", transform: "translateX(0)" },
        },
        slideInLeft: {
          "0%": { opacity: "0", transform: "translateX(-20px)" },
          "100%": { opacity: "1", transform: "translateX(0)" },
        },
        scaleIn: {
          "0%": { opacity: "0", transform: "scale(0.95)" },
          "100%": { opacity: "1", transform: "scale(1)" },
        },
        blob: {
          "0%": { transform: "translate(0px, 0px) scale(1)" },
          "33%": { transform: "translate(30px, -50px) scale(1.1)" },
          "66%": { transform: "translate(-20px, 20px) scale(0.9)" },
          "100%": { transform: "translate(0px, 0px) scale(1)" },
        },
        shimmer: {
          "0%": { backgroundPosition: "-200% 0" },
          "100%": { backgroundPosition: "200% 0" },
        },
        shake: {
          "0%, 100%": { transform: "translateX(0)" },
          "25%": { transform: "translateX(-5px)" },
          "75%": { transform: "translateX(5px)" },
        },
        wiggle: {
          "0%, 100%": { transform: "rotate(-3deg)" },
          "50%": { transform: "rotate(3deg)" },
        },
      },
    },
  },
};
```

### Skeleton Loading

```css
/* Shimmer skeleton */
.skeleton {
  @apply relative overflow-hidden;
  @apply bg-gray-200 dark:bg-gray-700;
  @apply rounded;
}

.skeleton::after {
  @apply absolute inset-0;
  @apply bg-gradient-to-r from-transparent via-white/40 to-transparent;
  @apply animate-shimmer;
  content: "";
  background-size: 200% 100%;
}

/* Pulse skeleton */
.skeleton-pulse {
  @apply animate-pulse;
  @apply bg-gray-200 dark:bg-gray-700;
  @apply rounded;
}
```

### Hover Effects

```css
/* Lift on hover */
.hover-lift {
  @apply transition-all duration-200;
  @apply hover:-translate-y-1 hover:shadow-lg;
}

/* Glow on hover */
.hover-glow {
  @apply transition-shadow duration-200;
  @apply hover:shadow-[0_0_20px_rgba(59,130,246,0.3)];
}

/* Scale on hover */
.hover-scale {
  @apply transition-transform duration-200;
  @apply hover:scale-[1.02];
}

/* Border glow on hover */
.hover-border-glow {
  @apply relative;
  @apply before:absolute before:inset-0 before:rounded-inherit;
  @apply before:opacity-0 before:transition-opacity;
  @apply before:shadow-[0_0_0_2px_rgba(59,130,246,0.5)];
  @apply hover:before:opacity-100;
}
```

---

## Scroll Animations

### Intersection Observer Hook

```typescript
// hooks/use-in-view.ts
import { useEffect, useRef, useState } from "react";

interface UseInViewOptions {
  threshold?: number;
  rootMargin?: string;
  triggerOnce?: boolean;
}

export function useInView({
  threshold = 0.1,
  rootMargin = "0px",
  triggerOnce = true,
}: UseInViewOptions = {}) {
  const ref = useRef<HTMLElement>(null);
  const [isInView, setIsInView] = useState(false);

  useEffect(() => {
    const element = ref.current;
    if (!element) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsInView(true);
          if (triggerOnce) {
            observer.unobserve(element);
          }
        } else if (!triggerOnce) {
          setIsInView(false);
        }
      },
      { threshold, rootMargin }
    );

    observer.observe(element);
    return () => observer.disconnect();
  }, [threshold, rootMargin, triggerOnce]);

  return { ref, isInView };
}
```

### Scroll-Triggered Animation Component

```typescript
// components/scroll-animate.tsx
import { motion } from "framer-motion";
import { useInView } from "@/hooks/use-in-view";

interface ScrollAnimateProps {
  children: React.ReactNode;
  animation?: "fadeUp" | "fadeIn" | "slideRight" | "scale";
  delay?: number;
  className?: string;
}

const animations = {
  fadeUp: {
    hidden: { opacity: 0, y: 30 },
    visible: { opacity: 1, y: 0 },
  },
  fadeIn: {
    hidden: { opacity: 0 },
    visible: { opacity: 1 },
  },
  slideRight: {
    hidden: { opacity: 0, x: -30 },
    visible: { opacity: 1, x: 0 },
  },
  scale: {
    hidden: { opacity: 0, scale: 0.9 },
    visible: { opacity: 1, scale: 1 },
  },
};

export function ScrollAnimate({
  children,
  animation = "fadeUp",
  delay = 0,
  className,
}: ScrollAnimateProps) {
  const { ref, isInView } = useInView({ threshold: 0.2 });

  return (
    <motion.div
      ref={ref}
      initial="hidden"
      animate={isInView ? "visible" : "hidden"}
      variants={animations[animation]}
      transition={{
        duration: 0.5,
        delay,
        ease: [0.0, 0.0, 0.2, 1],
      }}
      className={className}
    >
      {children}
    </motion.div>
  );
}
```

---

## Reduced Motion

Always respect user preferences:

```typescript
// hooks/use-reduced-motion.ts
import { useEffect, useState } from "react";

export function useReducedMotion() {
  const [reducedMotion, setReducedMotion] = useState(false);

  useEffect(() => {
    const mediaQuery = window.matchMedia("(prefers-reduced-motion: reduce)");
    setReducedMotion(mediaQuery.matches);

    const handler = (e: MediaQueryListEvent) => setReducedMotion(e.matches);
    mediaQuery.addEventListener("change", handler);
    return () => mediaQuery.removeEventListener("change", handler);
  }, []);

  return reducedMotion;
}

// Usage in component
const reducedMotion = useReducedMotion();

<motion.div
  animate={{ scale: reducedMotion ? 1 : 1.02 }}
  transition={reducedMotion ? { duration: 0 } : { duration: 0.2 }}
>
```

```css
/* CSS fallback */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```
