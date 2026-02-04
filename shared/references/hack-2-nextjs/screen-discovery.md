# Screen Discovery Reference

Chrome MCP를 사용한 화면 탐색 및 네비게이션 그래프 구축.

---

## 1. Overview

Phase 0에서 모든 화면을 재귀적으로 탐색하여:
- 전체 화면 목록 수집
- 네비게이션 그래프 구축
- NextJS 라우트 구조 결정

---

## 2. Initial Navigation

```javascript
// Step 1: Open source
navigate_page({ url: source, type: "url" })

// Step 2: Get initial snapshot
take_snapshot()
```

**Source URL 변환:**
| Input | Chrome MCP URL |
|-------|----------------|
| `https://example.com` | `https://example.com` |
| `/path/to/file.html` | `file:///path/to/file.html` |
| `./mockup/index.html` | `file://{cwd}/mockup/index.html` |

---

## 3. Clickable Element Collection

```javascript
evaluate_script({
  function: `() => {
    const clickables = [];

    // Links
    document.querySelectorAll('a[href]').forEach(el => {
      const href = el.getAttribute('href');
      if (href && !href.startsWith('#') && !href.startsWith('javascript:')) {
        clickables.push({
          type: 'link',
          text: el.textContent.trim().slice(0, 50),
          href: href,
          uid: el.dataset?.uid || null
        });
      }
    });

    // Buttons with navigation
    document.querySelectorAll('button, [role="button"], [onclick]').forEach(el => {
      const onclick = el.getAttribute('onclick') || '';
      const dataNav = el.dataset?.nav || el.dataset?.href || null;
      if (onclick.includes('navigate') || onclick.includes('location') || dataNav) {
        clickables.push({
          type: 'button',
          text: el.textContent.trim().slice(0, 50),
          onclick: onclick.slice(0, 100),
          dataNav: dataNav,
          uid: el.dataset?.uid || null
        });
      }
    });

    // Tab triggers
    document.querySelectorAll('[role="tab"], [data-tab], .tab-trigger').forEach(el => {
      clickables.push({
        type: 'tab',
        text: el.textContent.trim().slice(0, 50),
        target: el.dataset?.tab || el.getAttribute('aria-controls'),
        uid: el.dataset?.uid || null
      });
    });

    // Navigation menu items
    document.querySelectorAll('nav a, [role="menuitem"], .nav-item').forEach(el => {
      if (!clickables.some(c => c.text === el.textContent.trim())) {
        clickables.push({
          type: 'nav',
          text: el.textContent.trim().slice(0, 50),
          href: el.getAttribute('href'),
          uid: el.dataset?.uid || null
        });
      }
    });

    return clickables;
  }`
})
```

---

## 4. Screen State Detection

화면이 변경되었는지 감지:

```javascript
evaluate_script({
  function: `() => ({
    url: window.location.href,
    title: document.title,
    hash: window.location.hash,
    // Content fingerprint
    mainContent: document.querySelector('main, [role="main"], .main-content')?.textContent?.slice(0, 200),
    // Active navigation
    activeNav: document.querySelector('.active, [aria-selected="true"], .selected')?.textContent,
    // Visible modal/dialog
    hasModal: !!document.querySelector('[role="dialog"]:not([hidden]), .modal:not(.hidden)')
  })`
})
```

**새 화면 판단 기준:**
1. URL 변경 (path 또는 hash)
2. Title 변경
3. Main content 변경 (70%+ 다름)
4. Active navigation 변경

---

## 5. Recursive Exploration Algorithm

```python
visited_urls = set()
visited_states = set()
screens = []
navigation_graph = []

def explore(url, parent_screen=None, trigger=None):
    # 1. Navigate
    navigate_page({ url: url })

    # 2. Get current state
    state = get_screen_state()
    state_hash = hash(state.url + state.title + state.mainContent[:100])

    # 3. Skip if visited
    if state_hash in visited_states:
        return
    visited_states.add(state_hash)

    # 4. Create screen record
    screen = {
        id: f"SCR-{len(screens)+1:03d}",
        url: state.url,
        title: state.title,
        parent: parent_screen,
        trigger: trigger
    }
    screens.append(screen)

    # 5. Record navigation edge
    if parent_screen:
        navigation_graph.append({
            from: parent_screen.id,
            to: screen.id,
            trigger: trigger
        })

    # 6. Collect clickables
    clickables = collect_clickables()

    # 7. Explore each clickable
    for clickable in clickables:
        if clickable.type == 'link' and clickable.href:
            # External link - skip
            if is_external(clickable.href):
                continue
            explore(resolve_url(url, clickable.href), screen, clickable.text)

        elif clickable.type in ['button', 'tab', 'nav']:
            # Click and check for navigation
            click({ uid: clickable.uid })
            new_state = get_screen_state()

            if is_new_screen(state, new_state):
                explore(new_state.url, screen, clickable.text)

            # Go back
            navigate_page({ type: "back" })
```

---

## 6. SPA Navigation Handling

Single Page App에서는 URL이 변경되지 않을 수 있음:

```javascript
// SPA 네비게이션 감지
evaluate_script({
  function: `() => {
    // Check for router state
    const reactRouter = window.__REACT_ROUTER_HISTORY__;
    const vueRouter = window.$nuxt?.$router || document.querySelector('[data-vue-router]');

    // Check for hash-based routing
    const hashRouting = window.location.hash.length > 1;

    // Check for visible content change
    const mainSelector = 'main, [role="main"], .page-content, #app';
    const mainContent = document.querySelector(mainSelector)?.innerHTML;

    return {
      isSPA: !!(reactRouter || vueRouter),
      hashRouting: hashRouting,
      contentHash: mainContent ? hashCode(mainContent) : null
    };
  }`
})
```

---

## 7. Tab vs Page Detection

탭은 별도 페이지가 아닌 같은 페이지 내 컴포넌트:

| Signal | Tab | Page |
|--------|-----|------|
| URL 변경 | ✗ | ✓ |
| `role="tab"` | ✓ | ✗ |
| Parent container `role="tablist"` | ✓ | ✗ |
| Content in same DOM | ✓ | ✗ |

**탭 발견 시:**
```yaml
# screen.yaml에 탭으로 기록
components:
  - id: "settings-tabs"
    type: "Tabs"
    items:
      - { label: "일반", panel: "general-panel" }
      - { label: "알림", panel: "notifications-panel" }
      - { label: "보안", panel: "security-panel" }
```

---

## 8. Route Structure Mapping

발견된 화면들을 NextJS 라우트로 매핑:

### 8.1 Pattern Matching

```python
def determine_route(screen):
    url = screen.url
    title = screen.title

    # Pattern: index with viewMode param
    if 'viewMode=hr' in url or 'HR' in title:
        return '/(hr)/page.tsx'
    if 'viewMode=emp' in url or 'Employee' in title:
        return '/(employee)/page.tsx'

    # Pattern: *-management.html → /(hr)/*/
    if '-management' in url:
        domain = url.split('-management')[0].split('/')[-1]
        return f'/(hr)/{domain}/page.tsx'

    # Pattern: emp-*.html → /(employee)/*/
    if '/emp-' in url:
        domain = url.split('emp-')[1].split('.')[0]
        return f'/(employee)/{domain}/page.tsx'

    # Default: use path
    path = urlparse(url).path
    return f'/app{path}/page.tsx'
```

### 8.2 Route Grouping

```python
def group_routes(screens):
    groups = {}

    for screen in screens:
        # Determine group by access level
        if is_admin_screen(screen):
            group = '(hr)'
        elif is_employee_screen(screen):
            group = '(employee)'
        else:
            group = '(shared)'

        if group not in groups:
            groups[group] = []
        groups[group].append(screen.id)

    return groups
```

---

## 9. Output Format

### 9.1 Screens List

```json
{
  "screens": [
    {
      "id": "SCR-001",
      "url": "file:///path/mockup/index.html",
      "title": "HR Dashboard",
      "route": "/(hr)/page.tsx",
      "parent": null,
      "trigger": null,
      "components": ["Header", "Sidebar", "StatCards", "DataTable"]
    },
    {
      "id": "SCR-002",
      "url": "file:///path/mockup/leave-management.html",
      "title": "Leave Management",
      "route": "/(hr)/leave/page.tsx",
      "parent": "SCR-001",
      "trigger": "nav-leave",
      "components": ["Header", "Sidebar", "FilterBar", "LeaveTable"]
    }
  ]
}
```

### 9.2 Navigation Graph

```json
{
  "navigation_graph": [
    { "from": "SCR-001", "to": "SCR-002", "trigger": "휴가 관리", "type": "nav" },
    { "from": "SCR-001", "to": "SCR-003", "trigger": "출퇴근 관리", "type": "nav" },
    { "from": "SCR-002", "to": "SCR-004", "trigger": "휴가 신청", "type": "button" }
  ]
}
```

### 9.3 Route Groups

```json
{
  "route_groups": {
    "(hr)": ["SCR-001", "SCR-002", "SCR-003"],
    "(employee)": ["SCR-004", "SCR-005"],
    "(shared)": ["SCR-006"]
  }
}
```

---

## 10. Error Recovery

| Error | Recovery |
|-------|----------|
| Navigation timeout | Retry with longer timeout (30s) |
| Element not found | Skip and continue with next clickable |
| Infinite loop detected | Break after 50 screens or 3 visits to same state |
| Modal blocks navigation | Dismiss modal and retry |

```javascript
// Modal dismissal
evaluate_script({
  function: `() => {
    const modal = document.querySelector('[role="dialog"], .modal');
    if (modal) {
      const closeBtn = modal.querySelector('[aria-label="Close"], .close-btn, button');
      if (closeBtn) closeBtn.click();
      return true;
    }
    return false;
  }`
})
```
