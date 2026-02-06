---
name: mockup-analyzer
description: "Analyze Next.js mockup projects using Playwright MCP. Crawl screens, detect personas, extract navigation structure."
model: sonnet
context: fork
permissionMode: bypassPermissions
allowedTools: [Read, Write, Glob, Grep, mcp__playwright__browser_navigate, mcp__playwright__browser_snapshot, mcp__playwright__browser_click, mcp__playwright__browser_wait_for]
---

# Mockup Analyzer

A mockup crawler that uses Playwright MCP to explore Next.js projects and extract structure.

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
WebFetch or browser_navigate to localhost:PORT
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

## Navigation Links
- /attendance-records
- /leave-management
```

## Writing Location

`tmp/{session-id}/00-analysis/`
