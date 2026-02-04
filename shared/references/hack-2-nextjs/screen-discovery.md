# Screen Discovery Reference

Phase 0: 가벼운 경로 탐색 전용 (스냅샷 금지!)

---

## 1. Overview

**목표:** URL과 경로만 수집, 파일로 저장 → 컨텍스트 해제

**핵심 원칙:**
- ❌ `take_snapshot()` 호출 금지 → 컨텍스트 폭발 방지
- ✅ `evaluate_script()` 로 URL/href/title만 추출
- ✅ 결과를 `navigation-map.md` 파일로 저장

```
[기존 - 컨텍스트 폭발]
navigate → snapshot → click → snapshot → click → snapshot → 💥

[신규 - 가벼운 탐색]
navigate → evaluate(links) → navigate → evaluate(links) → ... → save to file ✓
```

---

## 2. Initial Navigation

```javascript
// Step 1: Open source URL
navigate_page({ url: source, type: "url" })

// Step 2: Get page info (NO SNAPSHOT!)
evaluate_script({
  function: `() => ({
    url: window.location.href,
    title: document.title,
    // 가벼운 정보만!
  })`
})
```

**Source URL 변환:**
| Input | Chrome MCP URL |
|-------|----------------|
| `https://example.com` | `https://example.com` |
| `/path/to/file.html` | `file:///path/to/file.html` |
| `./mockup/index.html` | `file://{cwd}/mockup/index.html` |

---

## 3. Lightweight Link Collection

스냅샷 없이 링크만 수집:

```javascript
evaluate_script({
  function: `() => {
    const links = [];
    const seen = new Set();

    // <a href> 링크
    document.querySelectorAll('a[href]').forEach(el => {
      const href = el.getAttribute('href');
      if (href &&
          !href.startsWith('#') &&
          !href.startsWith('javascript:') &&
          !href.startsWith('mailto:') &&
          !seen.has(href)) {
        seen.add(href);
        links.push({
          type: 'link',
          text: el.textContent.trim().slice(0, 50),
          href: href,
          // 절대 URL로 변환
          absoluteUrl: new URL(href, window.location.href).href
        });
      }
    });

    // onclick navigation 버튼
    document.querySelectorAll('button[onclick], [onclick]').forEach(el => {
      const onclick = el.getAttribute('onclick') || '';
      // location.href, window.open, navigate 패턴 감지
      const hrefMatch = onclick.match(/(?:location\\.href|window\\.open)\\s*[=\\(]\\s*['"]([^'"]+)['"]/);
      if (hrefMatch && !seen.has(hrefMatch[1])) {
        seen.add(hrefMatch[1]);
        links.push({
          type: 'button',
          text: el.textContent.trim().slice(0, 50),
          href: hrefMatch[1],
          absoluteUrl: new URL(hrefMatch[1], window.location.href).href
        });
      }
    });

    // data-nav, data-href 속성
    document.querySelectorAll('[data-nav], [data-href]').forEach(el => {
      const href = el.dataset.nav || el.dataset.href;
      if (href && !seen.has(href)) {
        seen.add(href);
        links.push({
          type: 'data-attr',
          text: el.textContent.trim().slice(0, 50),
          href: href,
          absoluteUrl: new URL(href, window.location.href).href
        });
      }
    });

    return {
      currentUrl: window.location.href,
      currentTitle: document.title,
      links: links
    };
  }`
})
```

---

## 4. Recursive Exploration (NO SNAPSHOT!)

```python
visited_urls = set()
pages = []
navigation_graph = []
page_counter = 0

def explore(url, parent_id=None, trigger_text=None):
    global page_counter

    # 1. Skip if visited
    if url in visited_urls:
        return None
    visited_urls.add(url)

    # 2. Navigate (NO SNAPSHOT!)
    navigate_page({ url: url })

    # 3. Get lightweight info
    info = evaluate_script({ function: "..." })  # links collection script

    # 4. Assign page ID
    page_counter += 1
    page_id = f"P{page_counter:03d}"

    # 5. Determine route
    route = determine_route(url, info.currentTitle)

    # 6. Record page
    pages.append({
        "id": page_id,
        "url": url,
        "title": info.currentTitle,
        "route": route
    })

    # 7. Record navigation edge
    if parent_id:
        navigation_graph.append({
            "from": parent_id,
            "to": page_id,
            "trigger": trigger_text
        })

    # 8. Explore each link (recursively)
    for link in info.links:
        # Skip external links
        if is_external(link.absoluteUrl, url):
            continue
        explore(link.absoluteUrl, page_id, link.text)

    return page_id

# Start exploration
explore(source_url)

# Save to file (컨텍스트 해제!)
save_navigation_map(pages, navigation_graph)
```

---

## 5. Route Determination Logic

URL/title에서 NextJS 라우트 추론:

```python
def determine_route(url, title):
    # Extract filename from URL
    path = urlparse(url).path
    filename = path.split('/')[-1].replace('.html', '')

    # Pattern matching
    patterns = [
        # viewMode 파라미터
        (r'viewMode=hr', '/(hr)'),
        (r'viewMode=emp', '/(employee)'),

        # HR 관리 화면
        (r'index\.html.*HR|hr-|admin-', '/(hr)'),
        (r'-management$', '/(hr)/{domain}'),

        # Employee 화면
        (r'emp-', '/(employee)/{domain}'),

        # 특정 도메인
        (r'leave|휴가', '/leave'),
        (r'attendance|출퇴근', '/attendance'),
        (r'employee|직원', '/employees'),
        (r'schedule|근무', '/schedule'),
        (r'settings|설정', '/settings'),
    ]

    route_group = '/(hr)'  # default
    route_path = '/'

    for pattern, route in patterns:
        if re.search(pattern, url + title, re.I):
            if route.startswith('/('):
                route_group = route
            else:
                route_path = route

    # Combine: /(hr)/leave
    if route_path == '/':
        return route_group
    return f"{route_group}{route_path}"
```

---

## 6. External Link Detection

```python
def is_external(target_url, source_url):
    """외부 링크인지 판단"""
    source_domain = urlparse(source_url).netloc
    target_domain = urlparse(target_url).netloc

    # file:// URL의 경우
    if source_url.startswith('file://'):
        # 같은 디렉토리 또는 하위 디렉토리만 허용
        source_dir = os.path.dirname(urlparse(source_url).path)
        target_dir = os.path.dirname(urlparse(target_url).path)
        return not target_dir.startswith(source_dir)

    # http(s):// URL의 경우
    return source_domain != target_domain
```

---

## 7. Output: navigation-map.md

```markdown
# Navigation Map

Generated: 2024-01-15T10:30:00Z
Source: file:///Users/ted/project/mockup/index.html

## Pages
| ID | URL | Title | Suggested Route |
|----|-----|-------|-----------------|
| P001 | file:///mockup/index.html | HR Dashboard | /(hr) |
| P002 | file:///mockup/leave-management.html | Leave Management | /(hr)/leave |
| P003 | file:///mockup/emp-index.html | Employee Portal | /(employee) |
| P004 | file:///mockup/emp-leave.html | My Leave | /(employee)/leave |
| P005 | file:///mockup/attendance.html | Attendance | /(hr)/attendance |

## Navigation Graph
P001 → P002 (click: "휴가 관리")
P001 → P003 (click: "직원 모드")
P001 → P005 (click: "출퇴근 관리")
P002 → P004 (click: "휴가 신청")
P003 → P004 (click: "휴가 신청")

## Route Groups
(hr): P001, P002, P005
(employee): P003, P004

## Statistics
- Total pages: 5
- Navigation links: 5
- Route groups: 2
```

---

## 8. Tab Detection (In-Page Navigation)

탭은 별도 페이지가 아닌 같은 페이지 내 컴포넌트:

```javascript
evaluate_script({
  function: `() => {
    const tabs = [];

    // role="tab" 탭
    document.querySelectorAll('[role="tab"]').forEach(tab => {
      tabs.push({
        text: tab.textContent.trim(),
        id: tab.id,
        controls: tab.getAttribute('aria-controls'),
        selected: tab.getAttribute('aria-selected') === 'true'
      });
    });

    // .tab-trigger 클래스
    document.querySelectorAll('.tab-trigger, [data-tab]').forEach(tab => {
      tabs.push({
        text: tab.textContent.trim(),
        target: tab.dataset.tab
      });
    });

    return tabs;
  }`
})
```

**탭 처리:**
- 탭은 navigation-map.md에 별도 페이지로 기록하지 않음
- 대신 Phase 1에서 해당 페이지의 컴포넌트로 처리

---

## 9. SPA Detection

SPA의 경우 URL 변경 없이 컨텐츠만 변경될 수 있음:

```javascript
evaluate_script({
  function: `() => ({
    isSPA: !!(
      window.__REACT_ROOT__ ||
      window.__VUE_APP__ ||
      window.$nuxt ||
      document.querySelector('[data-reactroot]') ||
      document.querySelector('#__next')
    ),
    hashRouting: window.location.hash.length > 1,
    historyAPI: !!window.history.pushState
  })`
})
```

**SPA 처리:**
- Hash routing: `#/page` 형태의 URL 처리
- History API: `popstate` 이벤트 감지

---

## 10. Error Recovery

| Error | Recovery |
|-------|----------|
| Navigation timeout | 30초 대기 후 재시도 |
| 404 페이지 | 스킵하고 다음 링크 진행 |
| 무한 루프 감지 | 50개 페이지 또는 3회 방문 시 중단 |
| JavaScript 에러 | 스킵하고 기록 |

```javascript
// 모달이 네비게이션을 막는 경우
evaluate_script({
  function: `() => {
    const modal = document.querySelector('[role="dialog"]:not([hidden]), .modal:not(.hidden)');
    if (modal) {
      const closeBtn = modal.querySelector('[aria-label="Close"], .close-btn, button[type="button"]');
      if (closeBtn) {
        closeBtn.click();
        return { dismissed: true };
      }
    }
    return { dismissed: false };
  }`
})
```

---

## 11. Verification Checklist

| Check | Required |
|-------|----------|
| `take_snapshot()` 호출 없음 | ✓ |
| 모든 내부 링크 수집됨 | ✓ |
| navigation-map.md 생성됨 | ✓ |
| 무한 루프 방지 동작 | ✓ |
| 외부 링크 스킵됨 | ✓ |
| 라우트 그룹 분류됨 | ✓ |
