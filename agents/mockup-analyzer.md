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

### Step 5.5: Interactive Element Exploration (MANDATORY)

> **This step is REQUIRED for every screen. Do NOT skip.**

For every screen visited in Step 5, perform exhaustive interactive exploration using Playwright MCP:

```
FOR each screen:
  browser_snapshot: Get full element tree with uids

  ## 5.5.1: Click all components with onClick / interactive attributes
  Parse snapshot for ALL elements that are:
  - <button> elements (any)
  - <a> links (any)
  - Elements with role="button", role="tab", role="menuitem", role="link"
  - Elements with aria-expanded, aria-haspopup
  - Elements with onClick handlers (visible in snapshot as clickable)
  - <select> dropdowns
  - Checkbox / radio inputs
  - Any element with cursor:pointer styling

  FOR each interactive element found:
    browser_click(ref): Click the element
    browser_wait_for: Brief wait for UI response
    browser_snapshot: Capture state change

    Record what happened:
    - Modal/dialog opened? → Record modal content and actions
    - Dropdown appeared? → Record all options
    - Navigation occurred? → Record destination URL
    - Content expanded/collapsed? → Record hidden content
    - Toast/notification? → Record message
    - State toggle? → Record before/after state

    IF modal/dialog opened:
      Explore modal contents:
      - browser_click all buttons inside modal
      - Record form fields
      - Dismiss modal (click close/cancel or press Escape)

    IF dropdown appeared:
      Record all dropdown options
      browser_press_key: Escape to close

    browser_navigate back to original screen state if needed

  ## 5.5.2: Click center of button-like visual elements
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

  FOR each button-like element:
    Try browser_click on the element or its parent
    browser_snapshot: Check for any state change
    Record results

  ## 5.5.3: Explore tab/navigation components
  IF tabs detected:
    browser_click EACH tab
    browser_snapshot after each tab switch
    Record content shown per tab

  IF pagination detected:
    browser_click next/prev page
    Record if content changes

  IF accordion/collapsible sections detected:
    Expand ALL sections
    Record hidden content
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
| Element | Type | Click Result |
|---------|------|-------------|
| 승인 button | button | Opens confirmation modal with "승인하시겠습니까?" |
| 반려 button | button | Opens rejection modal with textarea for reason |
| 전체 보기 | link | Navigates to /attendance-records |
| StatCard(출근) | div.clickable | Navigates to /attendance-records?filter=present |
| Tab(주간) | role=tab | Shows weekly view |
| Tab(월간) | role=tab | Shows monthly view |

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
