# Style Extraction Reference

Phase 1: 각 페이지에서 outerHTML + CSS + Assets 추출

---

## 1. Overview

**핵심 원칙:**
- ✅ `evaluate_script(outerHTML)` → HTML 직접 추출
- ✅ 클래스 100% 보존 (절대 변경 금지!)
- ✅ CSS 변수/색상 수집 → 토큰 생성용
- ✅ Assets (이미지, SVG, 폰트) 수집

```
[기존 - 정보 손실]
take_snapshot() → AI 해석 → grid-cols-3 → grid-cols-12 변경 ❌

[신규 - 완전 보존]
evaluate_script(outerHTML) → JSX 문법 변환만 → grid-cols-3 그대로 ✓
```

---

## 2. outerHTML Direct Extraction (CRITICAL!)

```javascript
evaluate_script({
  function: `() => {
    // Main content area 찾기
    const selectors = [
      'main',
      '[role="main"]',
      '.main-content',
      '#main',
      '#app',
      '#root',
      '.app-content',
      'body'
    ];

    let root = null;
    for (const selector of selectors) {
      root = document.querySelector(selector);
      if (root && root.innerHTML.trim()) break;
    }

    if (!root) root = document.body;

    return {
      html: root.outerHTML,
      title: document.title,
      bodyClasses: document.body.className,
      htmlLang: document.documentElement.lang || 'en'
    };
  }`
})
```

**주의사항:**
- `outerHTML`은 클래스를 그대로 포함
- 이 HTML을 JSX로 변환할 때 클래스 값 변경 금지!

---

## 3. CSS/Style Extraction Script

토큰 생성을 위한 스타일 정보 수집:

```javascript
evaluate_script({
  function: `() => {
    const result = {
      colors: {},
      typography: {},
      spacing: {},
      borders: {},
      shadows: {},
      cssVariables: {},
      tailwindClasses: {}
    };

    // ============ CSS VARIABLES ============
    const rootStyles = getComputedStyle(document.documentElement);
    const cssVarRegex = /^--/;

    for (const prop of rootStyles) {
      if (cssVarRegex.test(prop)) {
        result.cssVariables[prop] = rootStyles.getPropertyValue(prop).trim();
      }
    }

    // ============ ELEMENT STYLES ============
    document.querySelectorAll('*').forEach(el => {
      const computed = getComputedStyle(el);
      const classes = typeof el.className === 'string' ? el.className : '';

      // Skip invisible
      if (computed.display === 'none' || computed.visibility === 'hidden') return;

      // COLORS
      ['color', 'backgroundColor', 'borderColor'].forEach(prop => {
        const value = computed[prop];
        if (value && value !== 'rgba(0, 0, 0, 0)' && value !== 'transparent') {
          const normalized = normalizeColor(value);
          if (!result.colors[normalized]) {
            result.colors[normalized] = { count: 0, contexts: [] };
          }
          result.colors[normalized].count++;
          if (!result.colors[normalized].contexts.includes(prop)) {
            result.colors[normalized].contexts.push(prop);
          }
        }
      });

      // TYPOGRAPHY
      const fontKey = [
        computed.fontFamily.split(',')[0].replace(/["']/g, '').trim(),
        computed.fontSize,
        computed.fontWeight
      ].join('|');

      if (!result.typography[fontKey]) {
        result.typography[fontKey] = {
          count: 0,
          family: computed.fontFamily,
          size: computed.fontSize,
          weight: computed.fontWeight,
          lineHeight: computed.lineHeight
        };
      }
      result.typography[fontKey].count++;

      // SPACING (gap, padding, margin)
      ['gap', 'padding', 'margin'].forEach(prop => {
        const value = computed[prop];
        if (value && value !== '0px' && value !== 'normal') {
          if (!result.spacing[value]) {
            result.spacing[value] = { count: 0, contexts: [] };
          }
          result.spacing[value].count++;
          if (!result.spacing[value].contexts.includes(prop)) {
            result.spacing[value].contexts.push(prop);
          }
        }
      });

      // BORDERS
      if (computed.borderWidth && computed.borderWidth !== '0px') {
        const borderKey = computed.borderRadius || '0px';
        if (!result.borders[borderKey]) {
          result.borders[borderKey] = { count: 0 };
        }
        result.borders[borderKey].count++;
      }

      // SHADOWS
      if (computed.boxShadow && computed.boxShadow !== 'none') {
        const shadowKey = computed.boxShadow;
        if (!result.shadows[shadowKey]) {
          result.shadows[shadowKey] = { count: 0 };
        }
        result.shadows[shadowKey].count++;
      }

      // TAILWIND CLASS COLLECTION
      if (classes) {
        classes.split(/\\s+/).forEach(cls => {
          if (cls) {
            result.tailwindClasses[cls] = (result.tailwindClasses[cls] || 0) + 1;
          }
        });
      }
    });

    // Helper: Normalize color to hex
    function normalizeColor(color) {
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

## 4. Asset Collection Script

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
          classes: img.className
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
      // Skip large SVGs (charts, decorative)
      const rect = svg.getBoundingClientRect();
      if (rect.width > 200 || rect.height > 200) return;

      const id = svg.id ||
                 svg.getAttribute('data-icon') ||
                 svg.closest('[data-icon]')?.dataset.icon ||
                 svg.querySelector('title')?.textContent?.toLowerCase().replace(/\\s+/g, '-') ||
                 'icon-' + Math.random().toString(36).slice(2, 8);

      assets.svgs.push({
        id: id,
        viewBox: svg.getAttribute('viewBox') || '',
        width: svg.getAttribute('width') || rect.width,
        height: svg.getAttribute('height') || rect.height,
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

    // @font-face rules
    try {
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
                  style: rule.style.getPropertyValue('font-style') || 'normal',
                  fromFontFace: true
                });
              }
            }
          });
        } catch (e) { /* cross-origin */ }
      });
    } catch (e) { /* no access */ }

    return assets;
  }`
})
```

---

## 5. Agent Output Format

각 에이전트가 생성하는 `{page-id}.json` 형식:

```json
{
  "id": "P001",
  "url": "file:///mockup/index.html",
  "title": "HR Dashboard",
  "route": "/(hr)",

  "html": {
    "content": "<main class=\"flex min-h-screen bg-gray-50\">...</main>",
    "bodyClasses": "antialiased",
    "lang": "ko"
  },

  "styles": {
    "colors": {
      "#3b82f6": { "count": 45, "contexts": ["backgroundColor"] },
      "#1e293b": { "count": 120, "contexts": ["color"] },
      "#f8fafc": { "count": 30, "contexts": ["backgroundColor"] }
    },
    "typography": {
      "Pretendard|14px|400": { "count": 80, "family": "Pretendard, sans-serif", "size": "14px", "weight": "400" },
      "Pretendard|16px|600": { "count": 25, "family": "Pretendard, sans-serif", "size": "16px", "weight": "600" }
    },
    "spacing": {
      "16px": { "count": 45, "contexts": ["padding", "gap"] },
      "24px": { "count": 30, "contexts": ["padding", "margin"] }
    },
    "borders": {
      "8px": { "count": 20 },
      "12px": { "count": 10 }
    },
    "shadows": {
      "0 1px 3px rgba(0,0,0,0.1)": { "count": 15 }
    },
    "cssVariables": {
      "--primary": "#3b82f6",
      "--background": "#f8fafc"
    },
    "tailwindClasses": {
      "flex": 45,
      "grid": 12,
      "grid-cols-3": 4,
      "gap-6": 8,
      "p-4": 20,
      "bg-white": 15,
      "rounded-lg": 18
    }
  },

  "assets": {
    "images": [
      { "src": "logo.png", "alt": "Company Logo", "width": 120, "height": 40 }
    ],
    "svgs": [
      { "id": "icon-dashboard", "viewBox": "0 0 24 24", "html": "<svg>...</svg>" },
      { "id": "icon-calendar", "viewBox": "0 0 24 24", "html": "<svg>...</svg>" }
    ],
    "fonts": [
      { "family": "Pretendard", "weight": "400", "style": "normal" },
      { "family": "Pretendard", "weight": "600", "style": "normal" }
    ],
    "backgrounds": []
  },

  "tsx": "export default function HRDashboard() {\n  return (\n    <main className=\"flex min-h-screen bg-gray-50\">\n      ...\n    </main>\n  );\n}"
}
```

---

## 6. HTML to JSX Conversion

> 상세 규칙: `shared/references/hack-2-nextjs/html-to-jsx.md`

**변환 시 핵심 원칙:**

```
✅ 허용 (문법 변환만):
- class="..." → className="..."
- for="..." → htmlFor="..."
- <img> → <img />
- style="color: red" → style={{ color: 'red' }}
- tabindex="0" → tabIndex={0}

❌ 금지 (클래스 값 변경):
- grid-cols-3 → grid-cols-12  ← 절대 금지!
- gap-6 → gap-4  ← 절대 금지!
- p-4 → p-6  ← 절대 금지!
- flex-row → flex-col  ← 절대 금지!
```

---

## 7. Color Token Substitution (Optional)

Phase 2에서 토큰 생성 후, TSX에서 색상 치환 가능:

```
Before: className="bg-blue-500 text-white"
After:  className="bg-primary text-primary-foreground"
```

**주의:** 레이아웃 클래스(grid-*, flex-*, gap-*, p-*, m-*)는 절대 변경하지 않음!

---

## 8. Agent Task Template

Phase 1에서 각 에이전트가 수행할 작업:

```markdown
## Task: Extract Page P001

**URL:** file:///mockup/index.html
**Route:** /(hr)

### Steps:

1. **Navigate**
   ```
   navigate_page({ url: "file:///mockup/index.html" })
   ```

2. **Extract outerHTML**
   ```
   evaluate_script({ function: "outerHTML extraction script" })
   ```

3. **Extract Styles**
   ```
   evaluate_script({ function: "CSS extraction script" })
   ```

4. **Extract Assets**
   ```
   evaluate_script({ function: "asset collection script" })
   ```

5. **Convert HTML to JSX**
   - class → className
   - Self-closing tags
   - Style object conversion
   - **클래스 값은 절대 변경하지 않음!**

6. **Save Output**
   ```
   Write to: hack-2-nextjs/extracted/P001.json
   ```

### CRITICAL Rules:
- 원본 클래스 100% 보존
- grid-cols-N, gap-N, p-N, m-N 값 변경 금지
- 레이아웃 "개선" 금지
```

---

## 9. Verification Checklist

| Check | Required |
|-------|----------|
| outerHTML 추출됨 | ✓ |
| 모든 클래스 보존됨 | ✓ |
| CSS 색상 수집됨 | ✓ |
| Typography 수집됨 | ✓ |
| Assets (이미지, SVG) 수집됨 | ✓ |
| JSON 파일 생성됨 | ✓ |
| TSX 문법 올바름 | ✓ |
| 레이아웃 클래스 미변경 | ✓ |
