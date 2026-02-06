---
name: clone-coder
description: |
  Clone local HTML files to Next.js App Router pages with visual matching.
  Opens HTML files in Chrome, takes snapshots, and LLM directly converts to TSX.
  Iteratively refines until visual match achieved.

  Use when: (1) Converting local HTML prototypes to Next.js, (2) "clone-coder",
  (3) Need pixel-perfect HTML to Next.js conversion with visual verification.

  Requires: Chrome DevTools MCP.
---

# clone-coder

HTML 파일을 Next.js 페이지로 클론. 화면 비교로 일치할 때까지 반복.

## Prerequisites

- Chrome DevTools MCP 활성화

## Arguments

```
--source <folder>   HTML 파일이 있는 폴더 경로 (필수)
--output <folder>   Next.js 프로젝트 경로 (기본: ./nextjs-output)
--file <name>       특정 HTML 파일만 변환 (선택)
```

## Workflow

### P0: Scan HTML Files

```bash
ls -la <source-folder>/*.html
```

HTML 파일 목록 출력 후 사용자 확인.

### P1: Open in Chrome & Snapshot

각 HTML 파일에 대해:

1. Chrome DevTools MCP로 새 페이지 생성
2. `file://` 프로토콜로 HTML 열기
3. `take_snapshot` 으로 DOM 구조 캡처
4. `take_screenshot` 으로 원본 이미지 저장

```
mcp__chrome-devtools__new_page
mcp__chrome-devtools__navigate_page → file://<absolute-path>
mcp__chrome-devtools__take_snapshot → _clone/<name>_original.yaml
mcp__chrome-devtools__take_screenshot → _clone/<name>_original.png
```

### P2: Convert to Next.js App Router TSX

1. 스냅샷에서 `text/babel` 코드 추출
2. Next.js App Router TSX로 변환:
   - CDN script 태그 제거
   - `ReactDOM.render()` → `export default function Page()`
   - 상태/이벤트 사용 시 `'use client'` 추가
   - inline style/Tailwind 유지
3. `mock-map.yaml`에 매핑 정보 기록

결과:
- `page.tsx` - Next.js 페이지
- `_components/*.tsx` - 분리된 컴포넌트 (필요 시)
- `mock-map.yaml` - HTML↔TSX 매핑 (업데이트)

### P3: Create Next.js Page

1. Next.js 프로젝트 구조 확인/생성
2. 변환된 TSX를 `app/<page-name>/page.tsx` 에 저장
3. 분리된 컴포넌트가 있으면 `app/<page-name>/_components/` 에 저장

```
app/
├── <page-name>/
│   ├── page.tsx
│   └── _components/    # 필요 시
│       └── *.tsx
```

### P4: Visual Comparison Loop

1. Next.js 개발 서버 실행 (이미 실행 중이면 스킵)
2. 해당 페이지 Chrome으로 열기
3. 스크린샷 촬영 → `_clone/<name>_result.png`
4. 원본과 비교

**비교 방법:**
- 두 스크린샷을 나란히 Read tool로 확인
- 차이점 식별 후 TSX/CSS 수정
- 일치할 때까지 반복 (최대 5회)

### P5: Next File

모든 HTML 파일 처리 완료까지 P1-P4 반복.

## Output Structure

```
<output>/
├── app/
│   ├── page1/
│   │   ├── page.tsx
│   │   └── _components/  # 필요 시
│   ├── page2/
│   │   └── ...
├── _clone/               # 비교용 스냅샷
│   ├── page1_original.png
│   ├── page1_result.png
│   └── ...
├── mock-map.yaml         # HTML↔TSX 매핑
└── package.json
```

## mock-map.yaml

각 TSX 파일의 원본 HTML 소스를 추적:

```yaml
# 자동 생성됨 - clone-coder
generated: "2024-01-15T10:30:00Z"
source_folder: ~/project/html-mockups

mappings:
  - html: login.html
    tsx: app/login/page.tsx
    components:
      - app/login/_components/LoginForm.tsx
    status: completed  # completed | in_progress | failed

  - html: dashboard.html
    tsx: app/dashboard/page.tsx
    components: []
    status: completed
```

**필드 설명:**
- `html`: 원본 HTML 파일명
- `tsx`: 생성된 페이지 TSX 경로
- `components`: 분리된 컴포넌트 목록
- `status`: 변환 상태

## 변환 규칙

text/babel → Next.js App Router TSX:
- `<script src="react.development.js">` → 삭제 (Next.js 자동 처리)
- `ReactDOM.render(<App />, ...)` → `export default function Page() { return <App /> }`
- 상태(useState)/이벤트(onClick) 사용 시 → 파일 최상단에 `'use client'` 추가
- className, style, Tailwind 클래스 → 그대로 유지
- `<head>`, `<title>` → `metadata` export 또는 삭제

## App Router 구조

```
app/
├── layout.tsx          # 공통 레이아웃
├── globals.css         # 전역 스타일 (Tailwind)
├── <page-name>/
│   └── page.tsx        # 각 페이지
```

- Server Component 기본 (fetch, async 가능)
- Client Component 필요 시 `'use client'` 선언

## Quick Example

```
User: /clone-coder --source ~/project/html-mockups --output ~/project/nextjs-app
```

1. `~/project/html-mockups/` 내 모든 HTML 스캔
2. 각각 Chrome으로 열어 스냅샷
3. TSX 변환 → Next.js 페이지 생성
4. 화면 비교 → 수정 → 일치 확인
5. 완료 보고
