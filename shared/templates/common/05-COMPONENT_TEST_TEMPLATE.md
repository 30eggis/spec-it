# Component 테스트: {{component_name}}

## 문서 정보
| 항목 | 내용 |
|------|------|
| 컴포넌트 ID | {{component_id}} |
| 작성일 | {{date}} |
| Phase | {{phase}} |
| 우선순위 | {{priority}} |

---

## 컴포넌트 개요

### 책임 (Responsibilities)
{{#each responsibilities}}
- {{this}}
{{/each}}

### Props Interface
```typescript
{{props_interface}}
```

---

## Unit Tests

{{#each unit_tests}}
### {{test_id}}: {{title}}

**우선순위**: {{priority}}
**유형**: Unit

#### Given
```typescript
{{given_code}}
```

#### When
```typescript
{{when_code}}
```

#### Then
```typescript
{{then_code}}
```

{{#if coverage}}
**커버리지**: {{coverage}}
{{/if}}
**Status**: {{status}}

---

{{/each}}

## Integration Tests

{{#each integration_tests}}
### {{test_id}}: {{title}}

**우선순위**: {{priority}}
**유형**: Integration

#### Given
```typescript
{{given_code}}
```

#### When
```typescript
{{when_code}}
```

#### Then
```typescript
{{then_code}}
```

**Status**: {{status}}

---

{{/each}}

## Accessibility Tests

{{#each accessibility_tests}}
### {{test_id}}: {{title}}

**우선순위**: {{priority}}
**유형**: Accessibility

#### When
```typescript
{{when_code}}
```

#### Then
```typescript
{{then_code}}
```

**Status**: {{status}}

---

{{/each}}

## Edge Cases

{{#each edge_cases}}
### {{test_id}}: {{title}}

**우선순위**: {{priority}}
**유형**: {{type}}

#### Given
```typescript
{{given_code}}
```

#### When
```typescript
{{when_code}}
```

#### Then
```typescript
{{then_code}}
```

**Status**: {{status}}

---

{{/each}}

## 테스트 실행 가이드

### Setup
```bash
{{setup_commands}}
```

### 실행
```bash
{{run_commands}}
```

### 커버리지 목표
{{#each coverage_goals}}
- {{type}}: {{target}}
{{/each}}

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| {{version}} | {{date}} | {{author}} | {{change_description}} |
