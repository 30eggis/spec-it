---
name: hack-2-nextjs
description: |
  Convert existing UI sources to NextJS applications.
  Chrome MCP 기반 직접 TSX 생성 (YAML 중간 단계 제거).
  목표: 시각적 동일 (95%+) + 수정 가능 (디자인 토큰).
  Supports: URLs, local codebases (HTML/React/Vue), screenshots.
  Arguments: --source (path or url), --scope (single or all)
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion, mcp__chrome-devtools__take_snapshot, mcp__chrome-devtools__navigate_page, mcp__chrome-devtools__evaluate_script, mcp__chrome-devtools__take_screenshot, mcp__chrome-devtools__click, mcp__chrome-devtools__list_pages, mcp__chrome-devtools__new_page
---

# Hack 2 NextJS

Chrome MCP 기반 직접 TSX 생성으로 기존 UI를 NextJS 앱으로 변환.

## Core Concept

```
[기존 방식]  Source → YAML Wireframe → TSX (정보 손실 많음)
[새로운 방식] Source → TSX (직접 생성, 스타일 보존)
```

**핵심 변경:**
- YAML 와이어프레임 중간 단계 제거
- Chrome MCP로 실제 렌더링 결과에서 직접 추출
- 클래스/스타일 보존 → 시각적 동일성 95%+
- 디자인 토큰 자동 생성 → 수정 용이

---

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `source` | ✓ | - | URL, folder path, or file path |
| `scope` | ✗ | `all` | `single` = one screen, `all` = all linked screens |

**NOTE:** `designSystem` 인풋 제거 → 자동 생성으로 대체

---

## Output Structure

```
hack-2-nextjs/
├── next-frame-map.md        # 점진적 로딩용 맵 문서
├── design-system/
│   ├── tokens.ts            # 자동 생성된 디자인 토큰
│   └── tailwind.config.ts   # 토큰 기반 Tailwind 설정
└── nextjs-app/
    ├── app/
    │   ├── layout.tsx
    │   ├── page.tsx
    │   └── (groups)/        # 라우트 그룹
    │       └── */page.tsx
    ├── components/
    │   ├── layout/          # Layout 컴포넌트
    │   ├── ui/              # UI 컴포넌트
    │   └── icons/           # 추출된 SVG 아이콘
    ├── public/
    │   ├── images/          # 다운로드된 이미지
    │   └── fonts/           # 다운로드된 폰트
    ├── styles/
    │   └── globals.css
    ├── package.json
    └── tsconfig.json
```

---

## Workflow

```
[Phase 0: Screen Discovery] → [Phase 1: Extract & Generate] → [Phase 2: Connect & Run]
```

---

## Phase 0: Screen Discovery

> Reference: `shared/references/hack-2-nextjs/screen-discovery.md`

Chrome MCP로 모든 화면을 재귀적으로 탐색.

### 0.1 Source Type Detection

| Type | Detection | Method |
|------|-----------|--------|
| **URL** | Starts with `http://`, `https://`, `file://` | Chrome MCP |
| **Local HTML** | `*.html` file | `file://` URL로 변환 후 Chrome MCP |
| **Local Code** | Directory with `*.tsx`, `*.vue` | File parsing (fallback) |
| **Screenshot** | Image file | Vision analysis (fallback) |

### 0.2 Navigation Graph Building

```
IF scope == "all":
  1. navigate_page(source)
  2. take_snapshot() → 현재 화면 구조
  3. Collect clickable elements:
     - All <a href>
     - All <button onclick>
     - All elements with data-nav, data-href
  4. FOR each clickable:
     a. click(uid)
     b. take_snapshot() → 새 화면 발견?
     c. Record navigation: source → target
     d. Recurse if new screen
  5. Build navigation graph
```

### 0.3 Route Structure Decision

탐색된 화면들을 NextJS 폴더 구조로 매핑:

| 패턴 | NextJS Route |
|------|--------------|
| `index.html` (viewMode=hr) | `/(hr)/page.tsx` |
| `index.html` (viewMode=emp) | `/(employee)/page.tsx` |
| `*-management.html` | `/(hr)/*/page.tsx` |
| `emp-*.html` | `/(employee)/*/page.tsx` |
| 탭 내 화면 (URL 불변) | 같은 page.tsx 내 탭 컴포넌트 |

### 0.4 Output: Discovery Report

```
screens: [
  { id: "SCR-001", url: "...", route: "/", components: [...] },
  { id: "SCR-002", url: "...", route: "/leave", parentClick: "nav-leave" },
  ...
]
navigation_graph: [
  { from: "SCR-001", to: "SCR-002", trigger: "nav-leave" },
  ...
]
route_groups: {
  "(hr)": ["SCR-001", "SCR-003"],
  "(employee)": ["SCR-002", "SCR-004"]
}
```

---

## Phase 1: Extract & Generate

> Reference: `shared/references/hack-2-nextjs/style-extraction.md`

각 화면에서 스타일 추출 + TSX 생성을 동시 진행.

### 1.1 Per-Screen Extraction

```javascript
// Step 1: Navigate
navigate_page({ url: screen.url })

// Step 2: A11y Tree
take_snapshot() → component_structure

// Step 3: CSS/Style Extraction (CRITICAL)
evaluate_script({
  function: `() => {
    const result = { colors: {}, typography: {}, spacing: {}, components: [] };

    document.querySelectorAll('*').forEach(el => {
      const computed = getComputedStyle(el);
      const classes = el.className;

      // Color collection
      ['color', 'backgroundColor', 'borderColor'].forEach(prop => {
        const value = computed[prop];
        if (value && value !== 'rgba(0, 0, 0, 0)' && value !== 'transparent') {
          const key = value.replace(/\\s/g, '');
          result.colors[key] = (result.colors[key] || 0) + 1;
        }
      });

      // Typography
      const fontKey = computed.fontFamily + '|' + computed.fontSize + '|' + computed.fontWeight;
      result.typography[fontKey] = (result.typography[fontKey] || 0) + 1;

      // Spacing (gap, padding, margin)
      ['gap', 'padding', 'margin'].forEach(prop => {
        const value = computed[prop];
        if (value && value !== '0px') {
          result.spacing[value] = (result.spacing[value] || 0) + 1;
        }
      });

      // Component with layout
      if (computed.display === 'grid' || computed.display === 'flex') {
        result.components.push({
          tag: el.tagName,
          classes: typeof classes === 'string' ? classes : '',
          display: computed.display,
          gridTemplateColumns: computed.gridTemplateColumns,
          flexDirection: computed.flexDirection,
          justifyContent: computed.justifyContent,
          alignItems: computed.alignItems,
          gap: computed.gap
        });
      }
    });

    return result;
  }`
})
```

### 1.2 Asset Collection

```javascript
evaluate_script({
  function: `() => ({
    images: [...document.querySelectorAll('img')].map(img => ({
      src: img.src,
      alt: img.alt,
      width: img.width,
      height: img.height
    })),
    backgrounds: [...document.querySelectorAll('*')]
      .map(el => getComputedStyle(el).backgroundImage)
      .filter(bg => bg !== 'none' && bg.includes('url')),
    svgs: [...document.querySelectorAll('svg')].map(svg => ({
      id: svg.id || svg.closest('[id]')?.id || 'icon-' + Math.random().toString(36).slice(2, 8),
      html: svg.outerHTML,
      viewBox: svg.getAttribute('viewBox')
    })),
    fonts: document.fonts ? [...document.fonts].map(f => ({
      family: f.family,
      weight: f.weight,
      style: f.style
    })) : []
  })`
})
```

### 1.3 Design Token Auto-Generation

수집된 스타일을 시맨틱 토큰으로 자동 매핑:

```typescript
// tokens.ts 자동 생성 로직
const colorUsage = extractedColors;

// 가장 많이 사용된 accent color → primary
const primary = Object.entries(colorUsage)
  .filter(([color]) => isAccentColor(color))
  .sort((a, b) => b[1] - a[1])[0];

// 가장 많이 사용된 text color → foreground
const foreground = Object.entries(colorUsage)
  .filter(([color]) => isTextColor(color))
  .sort((a, b) => b[1] - a[1])[0];

export const tokens = {
  colors: {
    primary: primary[0],
    foreground: foreground[0],
    background: mostUsedBackground,
    // ...more semantic colors
  },
  spacing: {
    // Normalize to 4px grid
  },
  typography: {
    // Font family, sizes, weights
  }
};
```

### 1.4 TSX Generation (Per Screen)

**직접 TSX 생성 (YAML 없이):**

```
1. a11y tree에서 컴포넌트 구조 파악
2. CSS extraction 결과에서 레이아웃 정보 적용
3. Tailwind 클래스 생성 (token 참조)
4. Static TSX 작성 (no interactivity yet)
```

**클래스 변환 예시:**
```
원본: bg-blue-500 → 생성: bg-primary (tokens.colors.primary = blue-500 equivalent)
원본: gap-4 → 생성: gap-4 (또는 gap-base if tokenized)
```

### 1.5 Output: Per Screen

```
hack-2-nextjs/nextjs-app/
├── app/{route}/page.tsx     # Static TSX
└── components/ui/*.tsx      # Extracted components
```

---

## Phase 2: Connect & Run

### 2.1 Navigation Wiring

Navigation graph를 기반으로 Link 연결:

```typescript
// Before (static)
<button>휴가 관리</button>

// After (wired)
<Link href="/leave">휴가 관리</Link>
```

### 2.2 Asset Download

```bash
# Images
FOR each image in collected_images:
  curl -o public/images/{filename} {image.src}

# Fonts
FOR each font in collected_fonts:
  # Download or configure Google Fonts
```

### 2.3 Project Setup & Run

```bash
cd hack-2-nextjs/nextjs-app
npm install
npm run dev
```

### 2.4 Verification

```
1. Open http://localhost:3000
2. Compare with original source
3. Check all navigation links
4. Verify visual fidelity (95%+ match)
```

---

## next-frame-map.md Structure

점진적 컨텍스트 로딩을 위한 맵 문서:

```markdown
# Screen Map

## Navigation Graph
\`\`\`mermaid
graph TD
  SCR-001[Dashboard] --> SCR-002[Leave Management]
  SCR-001 --> SCR-003[Attendance]
  SCR-002 --> SCR-004[Leave Request]
\`\`\`

## Screens
| ID | Route | File | Parent | Children | Components |
|----|-------|------|--------|----------|------------|
| SCR-001 | / | app/page.tsx | - | SCR-002, SCR-003 | Header, Sidebar, StatCards |

## Components
| Name | File | Used In |
|------|------|---------|
| Header | components/layout/header.tsx | SCR-001, SCR-002 |
| Sidebar | components/layout/sidebar.tsx | SCR-001, SCR-002 |

## Design Tokens
| Category | File | Section |
|----------|------|---------|
| Colors | design-system/tokens.ts | colors |
| Typography | design-system/tokens.ts | typography |

## Assets
| Type | Location |
|------|----------|
| Images | public/images/ |
| Icons | components/icons/ |
| Fonts | public/fonts/ |
```

---

## Reference Documents

| Topic | File |
|-------|------|
| Screen Discovery Details | `shared/references/hack-2-nextjs/screen-discovery.md` |
| Style Extraction Scripts | `shared/references/hack-2-nextjs/style-extraction.md` |
| Token Generation Logic | `shared/references/hack-2-nextjs/token-generation.md` |
| Layout Rules | `shared/references/common/rules/07-layout-extraction-rules.md` |

---

## Verification Checklist

| Phase | Check | Required |
|-------|-------|----------|
| **Phase 0** |||
| Discovery | All screens found | ✓ |
| Discovery | Navigation graph complete | ✓ |
| Discovery | Route structure decided | ✓ |
| **Phase 1** |||
| Extraction | Colors collected | ✓ |
| Extraction | Typography collected | ✓ |
| Extraction | Assets collected | ✓ |
| Generation | tokens.ts created | ✓ |
| Generation | tailwind.config.ts created | ✓ |
| Generation | All pages generated | ✓ |
| **Phase 2** |||
| Connect | Navigation wired | ✓ |
| Connect | Assets downloaded | ✓ |
| Run | npm install succeeds | ✓ |
| Run | npm run dev starts | ✓ |
| Run | Visual match 95%+ | ✓ |

---

## Final Response Format

```
Done. Generated NextJS application:

📁 hack-2-nextjs/

Phase 0 - Discovery:
└── [N screens found, M navigation links]

Phase 1 - Extract & Generate:
├── design-system/
│   ├── tokens.ts (X colors, Y typography, Z spacing)
│   └── tailwind.config.ts
└── nextjs-app/
    ├── app/ [N pages]
    └── components/ [K components]

Phase 2 - Connect & Run:
├── Navigation wired [M links]
├── Assets downloaded [A images, B icons]
└── Running at http://localhost:3000

next-frame-map.md created for progressive loading.
```

---

## Error Handling

| Error | Recovery |
|-------|----------|
| Chrome MCP not available | Try file:// URL for local files |
| Navigation fails (SPA) | Use evaluate_script to trigger navigation |
| Assets 404 | Log warning, use placeholder |
| Style extraction incomplete | Use take_screenshot for visual reference |
