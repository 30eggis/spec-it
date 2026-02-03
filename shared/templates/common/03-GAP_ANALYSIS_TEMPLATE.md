# {{system_name}} - 컴포넌트 갭 분석

**문서 정보**
| 항목 | 내용 |
|------|------|
| 시스템명 | {{system_name}} |
| 분석 일시 | {{date}} |
| 범위 | {{analysis_scope}} |
| 우선순위 | Critical, High, Medium |

---

## 1. 갭 분석 요약

### 현황
- **정의된 컴포넌트**: {{defined_count}}개 ✓
- **미정의 컴포넌트**: {{undefined_count}}개 ✗
- **불완전한 명세**: {{incomplete_count}}개 ⚠

### 영향도
| 심각도 | 개수 | 영향 범위 |
|-------|------|---------|
| Critical | {{critical_count}} | 핵심 기능 (필수) |
| High | {{high_count}} | 주요 기능 (권장) |
| Medium | {{medium_count}} | 부가 기능 (선택) |

---

## 2. Critical - 즉시 추가 필수

{{#each critical_gaps}}
### G-{{seq}}: {{name}}

**상태**: 미정의 ✗

**설명**: {{description}}

**사용 현황**

| 화면 | 사용 빈도 | 위치 |
|------|---------|------|
{{#each usage}}
| {{screen}} | {{frequency}} | {{location}} |
{{/each}}

**문제점**
{{#each problems}}
- {{this}}
{{/each}}

**권장 Props**
```yaml
{{recommended_props}}
```

**우선순위**: **CRITICAL** (P0)

---

{{/each}}

## 3. High - 신속히 추가 권장

{{#each high_gaps}}
### G-{{seq}}: {{name}}

**상태**: 미정의 ✗

**설명**: {{description}}

**사용 현황**

| 화면 | 사용 위치 |
|------|---------|
{{#each usage}}
| {{screen}} | {{location}} |
{{/each}}

**구성**
{{#each composition}}
- {{this}}
{{/each}}

**문제점**
{{#each problems}}
- {{this}}
{{/each}}

**권장 Props**
```yaml
{{recommended_props}}
```

**우선순위**: **HIGH** (P1)

---

{{/each}}

## 4. Medium - 추가 권장

{{#each medium_gaps}}
### G-{{seq}}: {{name}}

**상태**: 미정의 ✗

**설명**: {{description}}

**사용 현황**

| 화면 | 위치 |
|------|------|
{{#each usage}}
| {{screen}} | {{location}} |
{{/each}}

**권장 Props**
```yaml
{{recommended_props}}
```

**우선순위**: **MEDIUM** (P2)

---

{{/each}}

## 5. 불완전한 명세 컴포넌트

{{#each incomplete_specs}}
### 5.{{@index}} {{component_id}}: {{name}} - {{issue}}

**현재 상태**: 부분 정의

**문제점**
{{#each problems}}
- {{this}}
{{/each}}

**권장 추가 Props**
```yaml
{{recommended_props}}
```

**영향 화면**: {{affected_screens}}

---

{{/each}}

## 6. 우선순위별 실행 계획

{{#each phases}}
### {{phase_name}} - {{description}}

{{#each tasks}}
{{@index}}. **{{component_id}}: {{name}}** - {{duration}}
{{/each}}

**예상 영향**: {{expected_impact}}

---

{{/each}}

## 7. 개발 권장사항

### 명명 규칙

```
{{naming_convention}}
```

### Props 명명

```
{{props_naming}}
```

### 테스트 ID 명명

```
{{testid_naming}}
```

---

## 8. 정리

### 추가 필요 컴포넌트

| # | 컴포넌트명 | 우선순위 | 예상 작업량 | 영향도 |
|---|-----------|---------|-----------|--------|
{{#each all_gaps}}
| G-{{seq}} | {{name}} | {{priority}} | {{estimated_time}} | {{impact}} |
{{/each}}

**총 예상 작업량**: {{total_estimated_time}}

---

**문서 작성**: Component Auditor
**감사 범위**: 현황 대비 미정의 {{undefined_count}}개 + 불완전 {{incomplete_count}}개
