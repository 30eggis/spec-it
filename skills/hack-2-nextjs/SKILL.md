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
- **outerHTML 직접 추출 → JSX 문법 변환만** (클래스 100% 보존)
- 디자인 토큰 자동 생성 → 수정 용이

---

## Context Token Management (CRITICAL)

### 문제점 (기존)

```
Phase 0: 클릭 → 스냅샷 → 클릭 → 스냅샷 (반복)
         ↓
         컨텍스트 폭발 💥 (페이지 많으면 토큰 한도 도달)
```

### 해결책 (신규)

```
[Phase 0: Route Discovery]     ← 메인 에이전트 (가벼운 탐색)
         │
         ▼
    navigation-map.md          ← 파일 저장 (컨텍스트 해제)
         │
         ▼
[Phase 1: Parallel Extraction] ← N개 에이전트 동시 실행
    ├─ Agent 1 → page-a.html → CSS + TSX → P001.json
    ├─ Agent 2 → page-b.html → CSS + TSX → P002.json
    ├─ Agent 3 → page-c.html → CSS + TSX → P003.json
    └─ ...
         │
         ▼
[Phase 2: Integration]         ← 메인 에이전트
    ├─ 토큰 통합 (모든 JSON에서 수집)
    ├─ 네비게이션 연결
    └─ npm run dev
```

### 컨텍스트 크기 비교

| Phase | 역할 | 컨텍스트 크기 |
|-------|------|---------------|
| **0** | URL/경로만 수집 (스냅샷 NO) | 작음 |
| **1** | 각 에이전트가 1개 페이지만 담당 | 분산됨 |
| **2** | 파일에서 읽어서 통합 | 작음 |

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
├── navigation-map.md        # Phase 0 출력
├── extracted/               # Phase 1 출력 (에이전트별)
│   ├── P001.json
│   ├── P002.json
│   └── ...
├── next-frame-map.md        # 최종 맵 문서
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
[Phase 0: Route Discovery] → [Phase 1: Parallel Extraction] → [Phase 2: Integration]
```

---

## Phase 0: Route Discovery

> Reference: `shared/references/hack-2-nextjs/screen-discovery.md`

**목표:** 가볍게 URL과 경로만 수집, 파일로 저장 (스냅샷 NO!)

### 0.1 Source Type Detection

| Type | Detection | Method |
|------|-----------|--------|
| **URL** | Starts with `http://`, `https://`, `file://` | Chrome MCP |
| **Local HTML** | `*.html` file | `file://` URL로 변환 후 Chrome MCP |
| **Local Code** | Directory with `*.tsx`, `*.vue` | File parsing (fallback) |
| **Screenshot** | Image file | Vision analysis (fallback) |

### 0.2 Lightweight Navigation (NO SNAPSHOT!)

```
IF scope == "all":
  1. navigate_page(source)
  2. evaluate_script() → 클릭 가능 요소 추출 (URL/href만!)
     - <a href>, <button onclick>, [data-nav]
     - title 추출
  3. FOR each link:
     a. navigate_page(link.href)
     b. evaluate_script() → URL, title만 기록
     c. 새 링크 발견 시 재귀
  4. navigation-map.md 저장
```

**CRITICAL: 스냅샷(take_snapshot) 호출 금지!**
- 스냅샷은 컨텍스트를 크게 소모함
- Phase 0에서는 URL/title/경로 정보만 필요

### 0.3 Output: navigation-map.md

```markdown
# Navigation Map

## Pages
| ID | URL | Title | Suggested Route |
|----|-----|-------|-----------------|
| P001 | file:///mockup/index.html | HR Dashboard | /(hr) |
| P002 | file:///mockup/leave.html | Leave Mgmt | /(hr)/leave |
| P003 | file:///mockup/emp-leave.html | My Leave | /(employee)/leave |

## Navigation Graph
P001 → P002 (click: "휴가 관리")
P001 → P003 (click: "직원 모드")
P002 → P004 (click: "휴가 신청")

## Route Groups
(hr): P001, P002, P005
(employee): P003, P004, P006
```

---

## Phase 1: Parallel Extraction

> Reference: `shared/references/hack-2-nextjs/style-extraction.md`

**목표:** 각 페이지를 병렬 에이전트가 독립 처리

### 1.1 Agent Spawning

```python
# navigation-map.md 파싱
pages = parse_navigation_map("hack-2-nextjs/navigation-map.md")

# 병렬 Task 에이전트 실행 (최대 5개씩)
for batch in chunk(pages, 5):
    # 동시에 여러 Task 호출
    for page in batch:
        Task(
            subagent_type="general-purpose",
            prompt=f"""
            Extract and generate TSX for: {page.url}
            Page ID: {page.id}
            Suggested Route: {page.route}

            Steps:
            1. navigate_page(url)
            2. evaluate_script() → outerHTML 추출
            3. evaluate_script() → CSS 추출
            4. evaluate_script() → Assets 수집
            5. HTML → JSX 변환 (클래스 100% 보존!)
            6. Save to: hack-2-nextjs/extracted/{page.id}.json

            CRITICAL: outerHTML의 클래스를 절대 변경하지 마세요!
            - grid-cols-3 → grid-cols-3 (그대로!)
            - gap-6 → gap-6 (그대로!)
            - 허용: class→className, style 문법 변환
            """,
            run_in_background=True
        )
```

### 1.2 Per-Page Extraction (Agent Task)

> Reference: `shared/references/hack-2-nextjs/html-to-jsx.md`

```javascript
// Step 1: Navigate
navigate_page({ url: page.url })

// Step 2: outerHTML 직접 추출 (CRITICAL!)
evaluate_script({
  function: `() => {
    const main = document.querySelector('main, [role="main"], .main-content, body');
    return {
      html: main.outerHTML,
      title: document.title
    };
  }`
})

// Step 3: CSS/Style 추출
evaluate_script({ /* style extraction script */ })

// Step 4: Assets 수집
evaluate_script({ /* asset collection script */ })

// Step 5: HTML → JSX 변환 (문법만!)
// Step 6: JSON 저장
```

### 1.3 Agent Output: {page-id}.json

```json
{
  "id": "P001",
  "url": "file:///mockup/index.html",
  "title": "HR Dashboard",
  "route": "/(hr)",
  "styles": {
    "colors": { "#3b82f6": 45, "#1e293b": 120 },
    "typography": { ... },
    "spacing": { ... }
  },
  "assets": {
    "images": ["logo.png", "avatar.jpg"],
    "svgs": [{ "id": "icon-home", "html": "..." }]
  },
  "tsx": "export default function HRDashboard() { return (...); }"
}
```

---

## Phase 2: Integration

**목표:** 추출된 결과물 통합

### 2.1 Token Generation

```
1. extracted/*.json 모두 읽기
2. 모든 colors 통합 → 빈도 기반 시맨틱 토큰
3. tokens.ts, tailwind.config.ts 생성
```

> Reference: `shared/references/hack-2-nextjs/token-generation.md`

### 2.2 TSX Placement & Navigation Wiring

```
1. 각 tsx를 route에 맞게 배치
   - P001.json (route: "/(hr)") → app/(hr)/page.tsx
2. navigation-map.md 기반으로 Link 연결
   - P001 → P002 (click: "휴가 관리")
   - <button>휴가 관리</button> → <Link href="/leave">휴가 관리</Link>
3. 공통 컴포넌트 추출 (Header, Sidebar 등)
```

### 2.3 Asset Download

```bash
# Images
FOR each image in collected_images:
  curl -o public/images/{filename} {image.src}

# Fonts (if local)
FOR each font in collected_fonts:
  curl -o public/fonts/{filename} {font.src}
```

### 2.4 Project Setup & Run

```bash
cd hack-2-nextjs/nextjs-app
npm install
npm run dev
```

---

## CRITICAL: outerHTML 직접 변환 방식

> Reference: `shared/references/hack-2-nextjs/html-to-jsx.md`

### 문제점 (기존)

```
take_snapshot() → AI "해석" → 임의 변환
                    ↓
grid-cols-3 → grid-cols-12 (임의 판단) ❌
```

### 해결책 (신규)

```
evaluate_script(outerHTML) → JSX 문법 변환만 → 클래스 100% 보존
                              ↓
grid-cols-3 → grid-cols-3 (그대로!) ✓
```

### JSX 변환 규칙 (허용 목록)

| HTML | JSX | 설명 |
|------|-----|------|
| `class="..."` | `className="..."` | 속성명만 변경 |
| `for="..."` | `htmlFor="..."` | 속성명만 변경 |
| `onclick="..."` | 제거 | 이벤트는 별도 처리 |
| `<img>` | `<img />` | 셀프 클로징 |
| `<input>` | `<input />` | 셀프 클로징 |
| `<br>` | `<br />` | 셀프 클로징 |
| `<hr>` | `<hr />` | 셀프 클로징 |
| `style="color: red"` | `style={{ color: 'red' }}` | 객체로 변환 |
| `tabindex="0"` | `tabIndex={0}` | camelCase |
| `colspan="2"` | `colSpan={2}` | camelCase |
| `rowspan="2"` | `rowSpan={2}` | camelCase |
| HTML comments | 제거 | `<!-- -->` 제거 |

### 금지 규칙 (CRITICAL - 절대 위반 불가!)

```markdown
❌ 절대 금지:
- grid-cols-N 값 변경
- flex-direction 변경
- gap-N 값 변경
- p-N, m-N 값 변경
- 원본에 없는 클래스 추가
- "더 나은" 레이아웃으로 "개선"
- 컴포넌트 구조 재해석
- 레이아웃 "정리"나 "최적화"

✅ 허용:
- HTML → JSX 문법 변환 (위 표 참조)
- 색상 토큰 치환 (bg-blue-500 → bg-primary)
- onclick 제거 (나중에 Link로 연결)
- SVG 내부 속성 camelCase 변환
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
| P001 | / | app/page.tsx | - | P002, P003 | Header, Sidebar, StatCards |

## Components
| Name | File | Used In |
|------|------|---------|
| Header | components/layout/header.tsx | P001, P002 |
| Sidebar | components/layout/sidebar.tsx | P001, P002 |

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
| Screen Discovery (Phase 0) | `shared/references/hack-2-nextjs/screen-discovery.md` |
| Style Extraction (Phase 1) | `shared/references/hack-2-nextjs/style-extraction.md` |
| HTML to JSX Rules | `shared/references/hack-2-nextjs/html-to-jsx.md` |
| Token Generation | `shared/references/hack-2-nextjs/token-generation.md` |
| Layout Rules | `shared/references/common/rules/07-layout-extraction-rules.md` |

---

## Verification Checklist

| Phase | Check | Required |
|-------|-------|----------|
| **Phase 0** |||
| Discovery | navigation-map.md 생성됨 | ✓ |
| Discovery | 모든 페이지 URL 수집됨 | ✓ |
| Discovery | 라우트 그룹 결정됨 | ✓ |
| Discovery | 스냅샷 호출 없음 | ✓ |
| **Phase 1** |||
| Extraction | 병렬 에이전트 실행됨 | ✓ |
| Extraction | extracted/*.json 생성됨 | ✓ |
| Extraction | outerHTML 클래스 보존됨 | ✓ |
| **Phase 2** |||
| Integration | tokens.ts 생성됨 | ✓ |
| Integration | tailwind.config.ts 생성됨 | ✓ |
| Integration | 네비게이션 Link 연결됨 | ✓ |
| Integration | Assets 다운로드됨 | ✓ |
| Run | npm install 성공 | ✓ |
| Run | npm run dev 성공 | ✓ |
| **Verification** |||
| Layout | 원본 grid-cols-N == 생성 grid-cols-N | ✓ |
| Layout | 원본 gap-N == 생성 gap-N | ✓ |
| Visual | 시각적 일치 95%+ | ✓ |

---

## Final Response Format

```
Done. Generated NextJS application:

📁 hack-2-nextjs/

Phase 0 - Route Discovery:
├── navigation-map.md
└── [N screens found, M navigation links]

Phase 1 - Parallel Extraction:
├── extracted/ [N JSON files]
└── [X agents completed]

Phase 2 - Integration:
├── design-system/
│   ├── tokens.ts (X colors, Y typography, Z spacing)
│   └── tailwind.config.ts
├── nextjs-app/
│   ├── app/ [N pages]
│   └── components/ [K components]
├── Navigation wired [M links]
└── Assets downloaded [A images, B icons]

Running at http://localhost:3000

next-frame-map.md created for progressive loading.
```

---

## Error Handling

| Error | Recovery |
|-------|----------|
| Chrome MCP not available | Try file:// URL for local files |
| Navigation fails (SPA) | Use evaluate_script to trigger navigation |
| Assets 404 | Log warning, use placeholder |
| Agent timeout | Retry with smaller batch size |
| Context limit reached | Reduce parallel agents from 5 to 3 |
