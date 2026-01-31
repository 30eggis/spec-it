# States

화면 상태 (loading, empty, error) 정의.

## Loading State

```yaml
states:
  loading:
    showSkeleton: true
    skeletonComponents:
      - type: "SkeletonCard"
        count: 4
        layout: "grid grid-cols-4 gap-4"

      - type: "SkeletonTable"
        rows: 10
        columns: 5

      - type: "SkeletonText"
        lines: 3
```

## Empty State

```yaml
states:
  empty:
    showEmptyState: true
    emptyComponent:
      icon: "Inbox"              # Lucide icon name
      title: "데이터가 없습니다"
      description: "새 항목을 추가해보세요"
      action:
        label: "항목 추가"
        onClick: "openCreateModal"
        variant: "primary"
```

## Error State

```yaml
states:
  error:
    showErrorBoundary: true
    errorComponent:
      icon: "AlertTriangle"
      title: "오류가 발생했습니다"
      description: "잠시 후 다시 시도해주세요"
      retryAction: true
      retryLabel: "다시 시도"
      supportLink: "/support"
```

## Partial States

특정 컴포넌트만 상태 변경:

```yaml
components:
  - id: "user-list"
    type: "DataTable"
    states:
      loading:
        type: "inline"           # inline | overlay | skeleton
        message: "로딩 중..."
      empty:
        type: "inline"
        message: "사용자가 없습니다"
        action: { label: "초대하기", onClick: "inviteUser" }
      error:
        type: "inline"
        retryable: true
```

## Optimistic Updates

```yaml
states:
  optimistic:
    enabled: true
    rollbackOnError: true
    indicators:
      - element: "[data-testid='save-btn']"
        pendingText: "저장 중..."
        successText: "저장됨"
        errorText: "실패"
```

## Skeleton Patterns

```yaml
# 미리 정의된 스켈레톤 패턴
skeletonPatterns:
  cardGrid:
    layout: "grid grid-cols-4 gap-4"
    item:
      height: "200px"
      borderRadius: "rounded-lg"

  tableRows:
    rowHeight: "48px"
    columns: 5
    headerHeight: "56px"

  listItems:
    itemHeight: "64px"
    avatarSize: "40px"
    lines: 2
```
