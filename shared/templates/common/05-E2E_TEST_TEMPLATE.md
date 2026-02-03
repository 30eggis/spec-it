# E2E 테스트: {{test_flow_name}}

## 문서 정보
| 항목 | 내용 |
|------|------|
| 세션 | {{session_id}} |
| 작성일 | {{date}} |
| Phase | {{phase}} |
| 우선순위 | {{priority}} |

---

{{#each test_cases}}
## {{test_id}}: {{title}}

### 메타데이터
- **우선순위**: {{priority}}
- **유형**: E2E
- **예상 소요시간**: {{estimated_time}}
- **자동화 가능**: {{automatable}}

### 전제조건
{{#each preconditions}}
- {{this}}
{{/each}}

### 테스트 단계
{{#each steps}}
{{@index}}. {{this}}
{{/each}}

### 예상 결과
{{#each expected_results}}
- {{this}}
{{/each}}

### 커버리지
{{#each coverage}}
- {{id}}: {{description}}
{{/each}}

### Edge Cases 검증
| Case | 입력 | 예상 결과 | Status |
|------|------|----------|--------|
{{#each edge_cases}}
| {{case_id}} | {{input}} | {{expected}} | {{status}} |
{{/each}}

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
