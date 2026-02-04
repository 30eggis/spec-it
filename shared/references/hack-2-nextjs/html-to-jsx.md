# HTML to JSX Conversion Rules

outerHTML을 JSX로 변환할 때의 규칙 정의.

---

## 1. Core Principle (핵심 원칙)

```
outerHTML → JSX 문법 변환만 → 클래스 값 100% 보존
```

**절대 불변 규칙:**
- 클래스 값(Tailwind 클래스 포함)은 절대 변경하지 않음
- 레이아웃 구조는 절대 재해석하지 않음
- "더 나은" 코드로 "개선"하지 않음

---

## 2. Allowed Transformations (허용 변환)

### 2.1 Attribute Name Changes

| HTML | JSX | 예시 |
|------|-----|------|
| `class` | `className` | `class="flex"` → `className="flex"` |
| `for` | `htmlFor` | `for="input-1"` → `htmlFor="input-1"` |
| `tabindex` | `tabIndex` | `tabindex="0"` → `tabIndex={0}` |
| `colspan` | `colSpan` | `colspan="2"` → `colSpan={2}` |
| `rowspan` | `rowSpan` | `rowspan="3"` → `rowSpan={3}` |
| `maxlength` | `maxLength` | `maxlength="100"` → `maxLength={100}` |
| `minlength` | `minLength` | `minlength="1"` → `minLength={1}` |
| `readonly` | `readOnly` | `readonly` → `readOnly` |
| `autocomplete` | `autoComplete` | `autocomplete="off"` → `autoComplete="off"` |
| `autofocus` | `autoFocus` | `autofocus` → `autoFocus` |
| `contenteditable` | `contentEditable` | `contenteditable="true"` → `contentEditable="true"` |
| `crossorigin` | `crossOrigin` | `crossorigin="anonymous"` → `crossOrigin="anonymous"` |
| `datetime` | `dateTime` | `datetime="2024-01-01"` → `dateTime="2024-01-01"` |
| `enctype` | `encType` | `enctype="multipart/form-data"` → `encType="multipart/form-data"` |
| `formaction` | `formAction` | `formaction="/submit"` → `formAction="/submit"` |
| `formmethod` | `formMethod` | `formmethod="post"` → `formMethod="post"` |
| `formnovalidate` | `formNoValidate` | `formnovalidate` → `formNoValidate` |
| `formtarget` | `formTarget` | `formtarget="_blank"` → `formTarget="_blank"` |
| `hreflang` | `hrefLang` | `hreflang="ko"` → `hrefLang="ko"` |
| `inputmode` | `inputMode` | `inputmode="numeric"` → `inputMode="numeric"` |
| `novalidate` | `noValidate` | `novalidate` → `noValidate` |
| `srcset` | `srcSet` | `srcset="..."` → `srcSet="..."` |
| `usemap` | `useMap` | `usemap="#map"` → `useMap="#map"` |

### 2.2 Self-Closing Tags

| HTML | JSX |
|------|-----|
| `<img>` | `<img />` |
| `<input>` | `<input />` |
| `<br>` | `<br />` |
| `<hr>` | `<hr />` |
| `<meta>` | `<meta />` |
| `<link>` | `<link />` |
| `<area>` | `<area />` |
| `<base>` | `<base />` |
| `<col>` | `<col />` |
| `<embed>` | `<embed />` |
| `<param>` | `<param />` |
| `<source>` | `<source />` |
| `<track>` | `<track />` |
| `<wbr>` | `<wbr />` |

### 2.3 Style Attribute Conversion

```html
<!-- HTML -->
<div style="color: red; font-size: 16px; background-color: #fff;">

<!-- JSX -->
<div style={{ color: 'red', fontSize: '16px', backgroundColor: '#fff' }}>
```

**CSS Property → camelCase:**
| CSS | JSX Style Object |
|-----|------------------|
| `font-size` | `fontSize` |
| `background-color` | `backgroundColor` |
| `border-radius` | `borderRadius` |
| `margin-top` | `marginTop` |
| `padding-left` | `paddingLeft` |
| `z-index` | `zIndex` |
| `line-height` | `lineHeight` |
| `text-align` | `textAlign` |
| `box-shadow` | `boxShadow` |
| `flex-direction` | `flexDirection` |

### 2.4 Event Handler Removal

```html
<!-- HTML (제거) -->
<button onclick="handleClick()">Click</button>
<a href="#" onclick="navigate()">Link</a>

<!-- JSX (이벤트 제거, 나중에 연결) -->
<button>Click</button>
<Link href="/path">Link</Link>  {/* Phase 2에서 연결 */}
```

### 2.5 Comment Removal

```html
<!-- HTML 주석 제거 -->
<!-- This is a comment -->
<div>Content</div>

<!-- JSX (주석 없음) -->
<div>Content</div>
```

### 2.6 Boolean Attributes

```html
<!-- HTML -->
<input disabled>
<input checked>
<button disabled="disabled">

<!-- JSX -->
<input disabled />
<input checked />
<button disabled>
```

---

## 3. SVG Specific Transformations

SVG 내부 속성도 camelCase로 변환:

| SVG Attribute | JSX |
|---------------|-----|
| `stroke-width` | `strokeWidth` |
| `stroke-linecap` | `strokeLinecap` |
| `stroke-linejoin` | `strokeLinejoin` |
| `fill-rule` | `fillRule` |
| `clip-rule` | `clipRule` |
| `clip-path` | `clipPath` |
| `font-family` | `fontFamily` |
| `font-size` | `fontSize` |
| `text-anchor` | `textAnchor` |
| `xlink:href` | `xlinkHref` (deprecated, use `href`) |
| `xmlns:xlink` | 제거 가능 |

```html
<!-- HTML SVG -->
<svg stroke-width="2" stroke-linecap="round" fill-rule="evenodd">

<!-- JSX SVG -->
<svg strokeWidth={2} strokeLinecap="round" fillRule="evenodd">
```

---

## 4. FORBIDDEN Transformations (금지 변환)

### 4.1 Layout Class Changes (절대 금지!)

```
❌ NEVER DO THIS:
grid-cols-3 → grid-cols-4
grid-cols-3 → grid-cols-12
gap-6 → gap-4
gap-6 → gap-8
flex-row → flex-col
flex → grid
items-center → items-start
justify-between → justify-around
```

### 4.2 Spacing Class Changes (절대 금지!)

```
❌ NEVER DO THIS:
p-4 → p-6
p-4 → p-2
m-2 → m-4
px-4 → px-6
py-2 → py-4
space-x-4 → space-x-2
```

### 4.3 Size Class Changes (절대 금지!)

```
❌ NEVER DO THIS:
w-full → w-1/2
h-screen → h-full
max-w-7xl → max-w-6xl
min-h-screen → min-h-0
```

### 4.4 Adding/Removing Classes (금지!)

```
❌ NEVER DO THIS:
className="flex" → className="flex flex-col"
className="grid grid-cols-3" → className="grid grid-cols-3 gap-4"
className="p-4 bg-white" → className="p-4"
```

### 4.5 Layout "Improvements" (금지!)

```
❌ NEVER DO THIS:
- "더 나은 레이아웃"으로 변경
- "반응형 개선"을 위한 클래스 추가
- "가독성 향상"을 위한 구조 변경
- "모범 사례"에 맞춘 수정
```

---

## 5. Conversion Algorithm

```javascript
function htmlToJsx(html) {
  let jsx = html;

  // Step 1: Self-closing tags
  const selfClosingTags = ['img', 'input', 'br', 'hr', 'meta', 'link', 'area', 'base', 'col', 'embed', 'param', 'source', 'track', 'wbr'];
  selfClosingTags.forEach(tag => {
    // <tag> → <tag />
    jsx = jsx.replace(new RegExp(`<${tag}([^>]*?)(?<!/)>`, 'gi'), `<${tag}$1 />`);
  });

  // Step 2: class → className
  jsx = jsx.replace(/\bclass=/g, 'className=');

  // Step 3: for → htmlFor
  jsx = jsx.replace(/\bfor=/g, 'htmlFor=');

  // Step 4: Numeric attributes
  const numericAttrs = ['tabindex', 'colspan', 'rowspan', 'maxlength', 'minlength'];
  numericAttrs.forEach(attr => {
    const camelCase = attr.replace(/([a-z])([a-z]*)/gi, (m, p1, p2, i) =>
      i === 0 ? p1.toLowerCase() + p2 : p1.toUpperCase() + p2
    );
    jsx = jsx.replace(new RegExp(`${attr}="(\\d+)"`, 'gi'), `${camelCase}={$1}`);
  });

  // Step 5: Remove onclick, onchange, etc.
  jsx = jsx.replace(/\s+on\w+="[^"]*"/gi, '');

  // Step 6: Remove HTML comments
  jsx = jsx.replace(/<!--[\s\S]*?-->/g, '');

  // Step 7: Convert inline style
  jsx = jsx.replace(/style="([^"]*)"/g, (match, styleStr) => {
    const styleObj = styleStr.split(';')
      .filter(s => s.trim())
      .map(s => {
        const [prop, val] = s.split(':').map(x => x.trim());
        const camelProp = prop.replace(/-([a-z])/g, (m, p1) => p1.toUpperCase());
        return `${camelProp}: '${val}'`;
      })
      .join(', ');
    return `style={{ ${styleObj} }}`;
  });

  // Step 8: SVG attributes (stroke-width → strokeWidth)
  const svgAttrs = [
    'stroke-width', 'stroke-linecap', 'stroke-linejoin', 'fill-rule',
    'clip-rule', 'clip-path', 'font-family', 'font-size', 'text-anchor'
  ];
  svgAttrs.forEach(attr => {
    const camelCase = attr.replace(/-([a-z])/g, (m, p1) => p1.toUpperCase());
    jsx = jsx.replace(new RegExp(attr, 'g'), camelCase);
  });

  return jsx;
}
```

---

## 6. Color Token Substitution (Phase 2)

Phase 2에서 토큰 생성 후, 색상 클래스만 치환 가능:

```javascript
const colorMap = {
  'bg-blue-500': 'bg-primary',
  'bg-blue-600': 'bg-primary',
  'text-white': 'text-primary-foreground',
  'text-gray-600': 'text-muted-foreground',
  'bg-gray-50': 'bg-muted',
  'bg-white': 'bg-card',
  'border-gray-200': 'border-border',
};

function substituteColorTokens(className) {
  return className.split(' ').map(cls => colorMap[cls] || cls).join(' ');
}
```

**주의:** 색상 토큰 치환만 허용. 레이아웃 클래스는 절대 변경 안 함!

---

## 7. Example Conversions

### Example 1: Basic Card

```html
<!-- Original HTML -->
<div class="bg-white rounded-lg shadow-md p-4">
  <h2 class="text-lg font-semibold text-gray-900">Title</h2>
  <p class="text-sm text-gray-600 mt-2">Description</p>
</div>
```

```jsx
// Converted JSX
<div className="bg-white rounded-lg shadow-md p-4">
  <h2 className="text-lg font-semibold text-gray-900">Title</h2>
  <p className="text-sm text-gray-600 mt-2">Description</p>
</div>
```

### Example 2: Grid Layout

```html
<!-- Original HTML -->
<div class="grid grid-cols-3 gap-6">
  <div class="bg-white p-4">Card 1</div>
  <div class="bg-white p-4">Card 2</div>
  <div class="bg-white p-4">Card 3</div>
</div>
```

```jsx
// Converted JSX (grid-cols-3, gap-6 그대로!)
<div className="grid grid-cols-3 gap-6">
  <div className="bg-white p-4">Card 1</div>
  <div className="bg-white p-4">Card 2</div>
  <div className="bg-white p-4">Card 3</div>
</div>
```

### Example 3: Form with Input

```html
<!-- Original HTML -->
<form>
  <label for="email" class="block text-sm font-medium">Email</label>
  <input type="email" id="email" class="mt-1 block w-full rounded-md border-gray-300" maxlength="100">
  <button type="submit" class="mt-4 bg-blue-500 text-white px-4 py-2 rounded" onclick="submit()">Submit</button>
</form>
```

```jsx
// Converted JSX
<form>
  <label htmlFor="email" className="block text-sm font-medium">Email</label>
  <input type="email" id="email" className="mt-1 block w-full rounded-md border-gray-300" maxLength={100} />
  <button type="submit" className="mt-4 bg-blue-500 text-white px-4 py-2 rounded">Submit</button>
</form>
```

### Example 4: SVG Icon

```html
<!-- Original HTML -->
<svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
  <path d="M12 4v16m8-8H4"></path>
</svg>
```

```jsx
// Converted JSX
<svg className="w-6 h-6" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round">
  <path d="M12 4v16m8-8H4" />
</svg>
```

---

## 8. Verification Checklist

| Check | Required |
|-------|----------|
| `class` → `className` 변환됨 | ✓ |
| Self-closing tags 처리됨 | ✓ |
| 이벤트 핸들러 제거됨 | ✓ |
| Style 객체로 변환됨 | ✓ |
| SVG 속성 camelCase 변환됨 | ✓ |
| **레이아웃 클래스 미변경** | ✓ |
| **grid-cols-N 값 동일** | ✓ |
| **gap-N 값 동일** | ✓ |
| **p-N, m-N 값 동일** | ✓ |
| **flex 관련 클래스 동일** | ✓ |
