# Style Extraction Reference

Chrome MCP를 사용한 CSS 스타일 추출 및 TSX 생성.

---

## 1. Overview

Phase 1에서 각 화면에 대해:
1. CSS/스타일 정보 추출
2. Assets (이미지, SVG, 폰트) 수집
3. 직접 TSX 생성 (YAML 없이)

---

## 2. Comprehensive Style Extraction Script

```javascript
evaluate_script({
  function: `() => {
    const result = {
      colors: {},
      typography: {},
      spacing: {},
      borders: {},
      shadows: {},
      components: [],
      classUsage: {}
    };

    document.querySelectorAll('*').forEach(el => {
      const computed = getComputedStyle(el);
      const classes = typeof el.className === 'string' ? el.className : '';

      // Skip invisible elements
      if (computed.display === 'none' || computed.visibility === 'hidden') {
        return;
      }

      // ============ COLORS ============
      ['color', 'backgroundColor', 'borderColor', 'outlineColor'].forEach(prop => {
        const value = computed[prop];
        if (value && value !== 'rgba(0, 0, 0, 0)' && value !== 'transparent') {
          const normalized = normalizeColor(value);
          if (!result.colors[normalized]) {
            result.colors[normalized] = { count: 0, contexts: [] };
          }
          result.colors[normalized].count++;
          result.colors[normalized].contexts.push(prop);
        }
      });

      // ============ TYPOGRAPHY ============
      const fontFamily = computed.fontFamily;
      const fontSize = computed.fontSize;
      const fontWeight = computed.fontWeight;
      const lineHeight = computed.lineHeight;
      const letterSpacing = computed.letterSpacing;

      const typoKey = [fontFamily, fontSize, fontWeight].join('|');
      if (!result.typography[typoKey]) {
        result.typography[typoKey] = {
          count: 0,
          family: fontFamily,
          size: fontSize,
          weight: fontWeight,
          lineHeight: lineHeight,
          letterSpacing: letterSpacing
        };
      }
      result.typography[typoKey].count++;

      // ============ SPACING ============
      ['padding', 'margin', 'gap'].forEach(prop => {
        const value = computed[prop];
        if (value && value !== '0px' && value !== 'normal') {
          if (!result.spacing[value]) {
            result.spacing[value] = { count: 0, contexts: [] };
          }
          result.spacing[value].count++;
          result.spacing[value].contexts.push(prop);
        }
      });

      // ============ BORDERS ============
      const borderWidth = computed.borderWidth;
      const borderRadius = computed.borderRadius;
      if (borderWidth && borderWidth !== '0px') {
        const borderKey = borderWidth + '|' + borderRadius;
        if (!result.borders[borderKey]) {
          result.borders[borderKey] = {
            count: 0,
            width: borderWidth,
            radius: borderRadius,
            style: computed.borderStyle
          };
        }
        result.borders[borderKey].count++;
      }

      // ============ SHADOWS ============
      const boxShadow = computed.boxShadow;
      if (boxShadow && boxShadow !== 'none') {
        if (!result.shadows[boxShadow]) {
          result.shadows[boxShadow] = { count: 0 };
        }
        result.shadows[boxShadow].count++;
      }

      // ============ LAYOUT COMPONENTS ============
      if (computed.display === 'grid' || computed.display === 'flex') {
        result.components.push({
          tag: el.tagName,
          classes: classes,
          id: el.id,
          role: el.getAttribute('role'),
          display: computed.display,
          // Grid properties
          gridTemplateColumns: computed.gridTemplateColumns,
          gridTemplateRows: computed.gridTemplateRows,
          gridGap: computed.gap,
          // Flex properties
          flexDirection: computed.flexDirection,
          flexWrap: computed.flexWrap,
          justifyContent: computed.justifyContent,
          alignItems: computed.alignItems,
          // Size
          width: computed.width,
          height: computed.height,
          minHeight: computed.minHeight,
          // Text preview
          textPreview: el.textContent?.trim().slice(0, 50)
        });
      }

      // ============ CLASS USAGE ============
      if (classes) {
        classes.split(/\\s+/).forEach(cls => {
          if (cls) {
            result.classUsage[cls] = (result.classUsage[cls] || 0) + 1;
          }
        });
      }
    });

    // Helper function
    function normalizeColor(color) {
      // Convert rgb/rgba to hex for consistency
      const match = color.match(/rgba?\\((\\d+),\\s*(\\d+),\\s*(\\d+)/);
      if (match) {
        const r = parseInt(match[1]).toString(16).padStart(2, '0');
        const g = parseInt(match[2]).toString(16).padStart(2, '0');
        const b = parseInt(match[3]).toString(16).padStart(2, '0');
        return '#' + r + g + b;
      }
      return color;
    }

    return result;
  }`
})
```

---

## 3. Asset Collection Script

```javascript
evaluate_script({
  function: `() => {
    const assets = {
      images: [],
      svgs: [],
      fonts: [],
      backgrounds: []
    };

    // ============ IMAGES ============
    document.querySelectorAll('img').forEach(img => {
      if (img.src) {
        assets.images.push({
          src: img.src,
          alt: img.alt || '',
          width: img.naturalWidth || img.width,
          height: img.naturalHeight || img.height,
          classes: img.className,
          loading: img.loading
        });
      }
    });

    // ============ BACKGROUND IMAGES ============
    document.querySelectorAll('*').forEach(el => {
      const bg = getComputedStyle(el).backgroundImage;
      if (bg && bg !== 'none') {
        const urlMatch = bg.match(/url\\(["']?([^"')]+)["']?\\)/);
        if (urlMatch) {
          assets.backgrounds.push({
            url: urlMatch[1],
            element: el.tagName,
            classes: el.className
          });
        }
      }
    });

    // ============ SVG ICONS ============
    document.querySelectorAll('svg').forEach(svg => {
      // Skip large SVGs (likely decorative or charts)
      const bbox = svg.getBBox ? svg.getBBox() : { width: 0, height: 0 };
      if (bbox.width > 200 || bbox.height > 200) return;

      const id = svg.id ||
                 svg.getAttribute('data-icon') ||
                 svg.closest('[data-icon]')?.dataset.icon ||
                 svg.querySelector('title')?.textContent ||
                 'icon-' + Math.random().toString(36).slice(2, 8);

      assets.svgs.push({
        id: id.replace(/\\s+/g, '-').toLowerCase(),
        viewBox: svg.getAttribute('viewBox') || '',
        width: svg.getAttribute('width') || bbox.width,
        height: svg.getAttribute('height') || bbox.height,
        html: svg.outerHTML,
        classes: svg.className?.baseVal || ''
      });
    });

    // ============ FONTS ============
    if (document.fonts) {
      document.fonts.forEach(font => {
        assets.fonts.push({
          family: font.family.replace(/["']/g, ''),
          weight: font.weight,
          style: font.style,
          status: font.status
        });
      });
    }

    // Also check @font-face rules
    [...document.styleSheets].forEach(sheet => {
      try {
        [...sheet.cssRules].forEach(rule => {
          if (rule.type === CSSRule.FONT_FACE_RULE) {
            const src = rule.style.getPropertyValue('src');
            const family = rule.style.getPropertyValue('font-family');
            if (src && family) {
              assets.fonts.push({
                family: family.replace(/["']/g, ''),
                src: src,
                weight: rule.style.getPropertyValue('font-weight') || 'normal',
                style: rule.style.getPropertyValue('font-style') || 'normal'
              });
            }
          }
        });
      } catch (e) {
        // Cross-origin stylesheet, skip
      }
    });

    return assets;
  }`
})
```

---

## 4. DOM Structure Extraction

컴포넌트 구조를 직접 추출:

```javascript
evaluate_script({
  function: `() => {
    function extractTree(el, depth = 0) {
      if (depth > 10) return null; // Prevent too deep recursion

      const computed = getComputedStyle(el);
      if (computed.display === 'none') return null;

      const node = {
        tag: el.tagName.toLowerCase(),
        role: el.getAttribute('role'),
        classes: el.className || '',
        id: el.id || null,
        text: el.childNodes.length === 1 && el.childNodes[0].nodeType === 3
              ? el.textContent.trim().slice(0, 100)
              : null,
        // Layout info
        display: computed.display,
        position: computed.position,
        // Interactive
        interactive: el.tagName === 'BUTTON' ||
                     el.tagName === 'A' ||
                     el.tagName === 'INPUT' ||
                     el.getAttribute('onclick') ||
                     el.getAttribute('role') === 'button',
        children: []
      };

      // Extract meaningful children only
      [...el.children].forEach(child => {
        const childNode = extractTree(child, depth + 1);
        if (childNode) {
          node.children.push(childNode);
        }
      });

      return node;
    }

    // Start from main content area
    const root = document.querySelector('main, [role="main"], #app, #root, body');
    return extractTree(root);
  }`
})
```

---

## 5. TSX Generation Rules

### 5.1 Component Identification

A11y snapshot과 DOM 구조에서 컴포넌트 식별:

| Pattern | Component |
|---------|-----------|
| `role="navigation"` | `<nav>` or `<Navigation>` |
| `role="main"` | `<main>` |
| `role="banner"` | `<header>` or `<Header>` |
| Card-like (shadow + border-radius + padding) | `<Card>` |
| Grid of cards | `<CardGrid>` |
| Table structure | `<Table>` or `<DataTable>` |
| Form with inputs | `<Form>` |
| List of items | `<List>` |

### 5.2 Layout to Tailwind Mapping

```typescript
function layoutToTailwind(component: LayoutComponent): string {
  const classes: string[] = [];

  // Display
  if (component.display === 'flex') {
    classes.push('flex');

    // Direction
    if (component.flexDirection === 'column') {
      classes.push('flex-col');
    }

    // Justify
    const justifyMap: Record<string, string> = {
      'flex-start': 'justify-start',
      'flex-end': 'justify-end',
      'center': 'justify-center',
      'space-between': 'justify-between',
      'space-around': 'justify-around',
      'space-evenly': 'justify-evenly'
    };
    if (justifyMap[component.justifyContent]) {
      classes.push(justifyMap[component.justifyContent]);
    }

    // Align
    const alignMap: Record<string, string> = {
      'flex-start': 'items-start',
      'flex-end': 'items-end',
      'center': 'items-center',
      'stretch': 'items-stretch',
      'baseline': 'items-baseline'
    };
    if (alignMap[component.alignItems]) {
      classes.push(alignMap[component.alignItems]);
    }
  }

  if (component.display === 'grid') {
    classes.push('grid');

    // Grid columns
    const cols = parseGridColumns(component.gridTemplateColumns);
    if (cols) {
      classes.push(`grid-cols-${cols}`);
    }
  }

  // Gap
  const gap = parsePixels(component.gap);
  if (gap) {
    const gapClass = pixelsToTailwind(gap, 'gap');
    if (gapClass) classes.push(gapClass);
  }

  return classes.join(' ');
}

function pixelsToTailwind(px: number, prefix: string): string {
  const map: Record<number, string> = {
    4: '1', 8: '2', 12: '3', 16: '4', 20: '5', 24: '6', 32: '8', 40: '10', 48: '12'
  };
  const nearest = Object.keys(map).map(Number).reduce((a, b) =>
    Math.abs(b - px) < Math.abs(a - px) ? b : a
  );
  return `${prefix}-${map[nearest]}`;
}
```

### 5.3 Color to Token Mapping

```typescript
function colorToToken(color: string, tokens: DesignTokens): string {
  // Exact match
  for (const [name, value] of Object.entries(tokens.colors)) {
    if (normalizeColor(value) === normalizeColor(color)) {
      return name; // e.g., 'primary', 'foreground'
    }
  }

  // Approximate match (within delta 10)
  for (const [name, value] of Object.entries(tokens.colors)) {
    if (colorDistance(color, value) < 10) {
      return name;
    }
  }

  // Fallback: return Tailwind color or raw hex
  return colorToTailwind(color) || color;
}
```

---

## 6. TSX Template Generation

### 6.1 Page Template

```typescript
// app/{route}/page.tsx
import { Header } from "@/components/layout/header";
import { Sidebar } from "@/components/layout/sidebar";
// ... more imports

export default function PageName() {
  return (
    <div className="min-h-screen bg-background">
      <Header />
      <div className="flex">
        <Sidebar />
        <main className="flex-1 p-6">
          {/* Page content */}
        </main>
      </div>
    </div>
  );
}
```

### 6.2 Component Template

```typescript
// components/ui/stat-card.tsx
import { cn } from "@/lib/utils";

interface StatCardProps {
  title: string;
  value: string | number;
  icon?: React.ReactNode;
  className?: string;
}

export function StatCard({ title, value, icon, className }: StatCardProps) {
  return (
    <div className={cn("rounded-lg border bg-card p-6 shadow-sm", className)}>
      {icon && <div className="mb-2">{icon}</div>}
      <div className="text-2xl font-bold">{value}</div>
      <div className="text-sm text-muted-foreground">{title}</div>
    </div>
  );
}
```

---

## 7. Class Preservation Strategy

원본 클래스를 최대한 보존하면서 토큰화:

### 7.1 Tailwind Classes

```
원본: bg-blue-500 text-white p-4 rounded-lg
토큰화: bg-primary text-primary-foreground p-4 rounded-lg
        ↑ 토큰 참조      ↑ 토큰 참조      ↑ 유지  ↑ 유지
```

### 7.2 Custom Classes

```
원본: .custom-header { ... }
처리: 1. 계산된 스타일 추출
      2. Tailwind 클래스로 변환
      3. 원본 클래스 제거
```

### 7.3 Inline Styles

```
원본: style="color: #3b82f6; padding: 16px"
처리: className="text-primary p-4"
```

---

## 8. Output Files

### 8.1 Per Screen

```
app/{route}/page.tsx
```

### 8.2 Shared Components

```
components/
├── layout/
│   ├── header.tsx
│   ├── sidebar.tsx
│   └── footer.tsx
├── ui/
│   ├── button.tsx
│   ├── card.tsx
│   ├── stat-card.tsx
│   └── data-table.tsx
└── icons/
    ├── dashboard.tsx
    ├── calendar.tsx
    └── ...
```

### 8.3 Design System Files

```
design-system/
├── tokens.ts
└── tailwind.config.ts
```
