---
name: mockup-analyzer
description: "Analyze Next.js mockup projects using Playwright MCP. Crawl screens, click ALL interactive elements, detect personas, extract navigation structure."
model: sonnet
context: fork
permissionMode: bypassPermissions
allowedTools: [Read, Write, Glob, Grep, mcp__playwright__browser_navigate, mcp__playwright__browser_snapshot, mcp__playwright__browser_click, mcp__playwright__browser_wait_for, mcp__playwright__browser_take_screenshot, mcp__playwright__browser_hover, mcp__playwright__browser_evaluate, mcp__playwright__browser_press_key]
---

# Mockup Analyzer

A mockup crawler that uses **Playwright MCP** to explore Next.js projects and extract structure.

> **CRITICAL**: This agent MUST use Playwright MCP for ALL analysis. Never rely on code reading alone. Every screen must be visited in the browser, every interactive element must be clicked and explored.

## Input

- Project path (Next.js app directory)
- Dev server URL (default: http://localhost:3000)

## Process

### Step 1: Project Type Detection

```
Read: package.json
Detect: Next.js (App Router / Pages Router)
Glob: app/**/page.tsx OR pages/**/*.tsx
```

### Step 2: Dev Server Check

```
browser_navigate: http://localhost:PORT
IF connection refused:
  Output: "Dev server not running. Start with: npm run dev"
  STOP
```

### Step 3: Main Page Crawl

```
browser_navigate: http://localhost:PORT
browser_snapshot: Extract initial structure

Detect persona switcher:
- Look for dropdown/tabs with user roles
- Extract URL prefixes (e.g., /employee, /admin, /hr)
```

### Step 4: Navigation Extraction

```
FOR each persona:
  browser_navigate: /{persona-prefix}
  browser_snapshot: Extract nav elements

  Extract:
  - Menu items (link text + href)
  - Sidebar structure
  - Top navigation
  - Breadcrumbs
```

### Step 5: Screen Inventory

```
FOR each URL discovered:
  browser_navigate: URL
  browser_snapshot: Full page

  Classify elements:
  - Forms (input, select, textarea)
  - Tables (table, columnheader, row)
  - Action buttons (button text: 승인, 반려, 신청, etc.)
  - Cards/Widgets (heading + data)
  - Stats displays
```

### Step 5.5: Recursive Deep Exploration (MANDATORY)

> **This step is REQUIRED for every screen. Do NOT skip.**
> **CRITICAL**: Explore to FULL DEPTH. When clicking an element reveals new content (sub-menu panel, tab content, nested tabs), you MUST recursively explore that new content too. Time is not a constraint — completeness is.

For every screen visited in Step 5, perform **recursive** interactive exploration using Playwright MCP.

#### Core Concept: State Tree Exploration

```
A screen is NOT just its initial render. It is a TREE of states:

/management (initial)
  ├─ 관리 메뉴: 기본 설정 (active by default)
  │   ├─ Tab: 일반 (active by default) → forms, checkboxes, dropdowns
  │   ├─ Tab: 알림 → explore ALL elements here
  │   ├─ Tab: 보안 → explore ALL elements here
  │   └─ Tab: 고급 옵션 → explore ALL elements here
  ├─ 관리 메뉴: 조직 인사관리 (click to switch)
  │   ├─ Sub-tabs? → explore each
  │   └─ Forms/tables/buttons → explore all
  ├─ 관리 메뉴: 근무 시간관리 (click to switch)
  │   └─ ...
  └─ ...

Every leaf node must be visited and recorded.
```

#### 5.5.0: State Tracking Setup

```
Initialize per screen:
  visitedStates = Set()  # Track explored states to prevent infinite loops
  stateKey = function(snapshot) → hash of visible interactive element uids + text
  explorationPath = []   # Breadcrumb trail: ["기본 설정", "알림"]
```

#### 5.5.1: Recursive Explore Function

```
FUNCTION deepExplore(contextLabel, depth=0):
  IF depth > 5: RETURN  # Safety limit

  browser_snapshot: Get full element tree with uids
  currentStateKey = stateKey(snapshot)

  IF currentStateKey IN visitedStates: RETURN
  ADD currentStateKey TO visitedStates

  # Collect ALL interactive elements in current view
  interactiveElements = Parse snapshot for:
  - <button> elements (any)
  - <a> links (internal page links only, skip external navigation)
  - Elements with role="button", role="tab", role="menuitem", role="link"
  - Elements with aria-expanded, aria-haspopup
  - Elements with onClick handlers (visible in snapshot as clickable)
  - <select> dropdowns
  - Checkbox / radio inputs
  - Any element with cursor:pointer styling

  # Categorize elements BEFORE clicking
  panelSwitchers = []  # Elements that switch content panels (sub-menus, tabs)
  actions = []         # Buttons that trigger modals/toasts/state changes
  formElements = []    # Inputs, selects, checkboxes (record without clicking)
  navLinks = []        # Links that navigate away (record URL only)

  FOR each element:
    Categorize by type:
    - button with tab-like text / role="tab" → panelSwitchers
    - button in sidebar/sub-nav / role="menuitem" → panelSwitchers
    - <a> with href to different page → navLinks (record, don't follow)
    - <select>, <input>, checkbox → formElements
    - Other buttons → actions

  # Phase A: Record form elements (no click needed)
  FOR each formElement:
    Record: element type, label, current value, options (for select/radio)

  # Phase B: Record nav links (no click needed)
  FOR each navLink:
    Record: link text, href URL

  # Phase C: Explore panel switchers WITH RECURSION
  FOR each panelSwitcher:
    Record: explorationPath + [panelSwitcher.text]
    browser_click(panelSwitcher.uid)
    browser_wait_for: Brief wait for content change

    # RECURSE into the new panel content
    deepExplore(
      contextLabel = contextLabel + " > " + panelSwitcher.text,
      depth = depth + 1
    )

    # Return to parent state if needed (click back to previous panel)
    # Use the parent panelSwitcher or browser_navigate to restore

  # Phase D: Explore action elements (modals, toggles, etc.)
  FOR each action:
    browser_click(action.uid)
    browser_wait_for: Brief wait
    browser_snapshot: Capture result

    Record what happened:
    - Modal/dialog opened? → Record modal content and actions
    - Dropdown appeared? → Record all options
    - Toast/notification? → Record message
    - Content expanded/collapsed? → Record hidden content
    - State toggle? → Record before/after state

    IF modal/dialog opened:
      Explore modal contents:
      - Record all form fields, labels, buttons
      - browser_click action buttons inside modal (record results)
      - IF modal contains tabs/sub-panels → deepExplore(modal context, depth+1)
      - Dismiss modal (click close/cancel or press Escape)

    IF dropdown appeared:
      Record all dropdown options
      browser_press_key: Escape to close

    Restore element to original state if toggled

END FUNCTION
```

#### 5.5.2: Detect Hidden Interactive Elements

```
Some elements may not be properly componentized but visually appear as buttons.
Use browser_evaluate to find elements that LOOK like buttons:

browser_evaluate: () => {
  const allElements = document.querySelectorAll('div, span, p, td');
  const buttonLike = [];
  allElements.forEach(el => {
    const style = window.getComputedStyle(el);
    const text = el.innerText?.trim();
    if (text && text.length < 30 &&
        (style.cursor === 'pointer' ||
         style.borderRadius !== '0px' ||
         el.classList.toString().match(/btn|button|chip|tag|badge|action|clickable/i))) {
      buttonLike.push({
        text: text,
        tag: el.tagName,
        classes: el.className
      });
    }
  });
  return buttonLike;
}

FOR each button-like element NOT already explored:
  Try browser_click on the element
  browser_snapshot: Check for any state change
  IF new content panel appeared → deepExplore(element.text, depth+1)
  Record results
```

#### 5.5.3: Execute the Exploration

```
FOR each screen:
  browser_snapshot: Get initial state

  # Start recursive exploration from the root
  deepExplore(contextLabel = screenName, depth = 0)

  # After deepExplore, run hidden element detection (5.5.2)
  # This catches elements missed by snapshot-based detection

  Record total exploration stats:
  - Total states explored: visitedStates.size
  - Total interactive elements found
  - Exploration tree depth reached
```

#### Example: Expected Exploration for /management

```
deepExplore("/management", depth=0)
  panelSwitchers found: [기본 설정(active), 조직 인사관리, 근무 시간관리, 휴가 요청관리, 리포트]
  actions found: [저장]
  formElements found: [회사명 input, 국가 select, ...]

  → Click "기본 설정" (or already active)
    deepExplore("/management > 기본 설정", depth=1)
      panelSwitchers found: [일반(active), 알림, 보안, 고급 옵션]

      → Click "일반" (or already active)
        deepExplore("/management > 기본 설정 > 일반", depth=2)
          formElements: [회사명, 국가, 회사 로고, 관리 단위, ...]
          actions: [저장, 파일 선택, Excel 업로드, 추가하기]
          → Click each action, record modals/results

      → Click "알림"
        deepExplore("/management > 기본 설정 > 알림", depth=2)
          Record ALL content, forms, toggles, buttons

      → Click "보안"
        deepExplore("/management > 기본 설정 > 보안", depth=2)
          Record ALL content

      → Click "고급 옵션"
        deepExplore("/management > 기본 설정 > 고급 옵션", depth=2)
          Record ALL content

  → Click "조직 인사관리"
    deepExplore("/management > 조직 인사관리", depth=1)
      panelSwitchers? → Explore each sub-tab/panel
      formElements? → Record all
      actions? → Click and record

  → Click "근무 시간관리"
    deepExplore("/management > 근무 시간관리", depth=1)
      ...

  → Click "휴가 요청관리"
    deepExplore("/management > 휴가 요청관리", depth=1)
      ...

  → Click "리포트"
    deepExplore("/management > 리포트", depth=1)
      ...
```

### Step 6: Persona Inference

```
Analyze button/form patterns:
- "승인/반려" buttons → Manager/Admin persona
- "신청" forms → Employee persona
- "설정", "규칙 관리" → Admin persona
- "내 ~", "개인 ~" → Employee persona
```

## Output

### 00-analysis/_index.md

```markdown
# Mockup Analysis Summary

## Project Info
- Type: Next.js (App Router)
- Port: 3000
- Total Screens: {count}
- Personas Detected: {count}

## Quick Links
- [Navigation Structure](./navigation-structure.md)
- [Screens](./screens/)
```

### 00-analysis/navigation-structure.md

```markdown
# Navigation Structure

## Persona: {name}
| Menu | URL | Type |
|------|-----|------|
| 대시보드 | / | Dashboard |
| 출퇴근 기록 | /attendance-records | Table |

## Persona-Screen Matrix
| Screen | HR Admin | Employee |
|--------|----------|----------|
| Dashboard | ✅ (/) | ✅ (/employee) |
```

### 00-analysis/screens/{screen-name}.md

```markdown
---
id: P1-SCR-001
title: HR Dashboard
phase: P1
type: screen-analysis
path: /
persona: hr-admin
---

# {Screen Name}

## Overview
- Path: /
- Persona: HR Admin
- Type: Dashboard

## Components Detected
| Type | Count | Details |
|------|-------|---------|
| StatCard | 5 | 출근, 지각, 미출근, 연장, 휴가 |
| AlertWidget | 2 | 누락, 52시간 위험 |
| DataTable | 1 | 승인 대기 |

## Actions Available
- 전체 보기 (link)
- 승인 (button)
- 반려 (button)

## Interactive Exploration Results

### State Tree
Total states explored: {N} | Max depth: {N}

### Panel: {default panel name}
#### Tab: {default tab name}
| Element | Type | Click Result |
|---------|------|-------------|
| 승인 button | button | Opens confirmation modal with "승인하시겠습니까?" |
| 반려 button | button | Opens rejection modal with textarea for reason |

#### Tab: {tab2 name}
| Element | Type | Click Result |
|---------|------|-------------|
| ... | ... | ... |

### Panel: {panel2 name}
#### Tab: {sub-tab name}
| Element | Type | Click Result |
|---------|------|-------------|
| ... | ... | ... |

## Hidden UI Discovered
- Confirmation modal: "승인하시겠습니까?" with [확인, 취소]
- Rejection modal: textarea + [제출, 취소]
- Dropdown filter: [전체, 부서별, 기간별]

## Navigation Links
- /attendance-records
- /leave-management
```

## Writing Location

`tmp/{session-id}/00-analysis/`
