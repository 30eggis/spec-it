# Context Management Rules (Shared)

**CRITICAL**: 이 규칙은 모든 spec-it 계열 스킬에서 반드시 준수해야 합니다.

---

## 1. 파일 작성 규칙

### 1.1 직접 Write 금지 조건

**메인 컨텍스트에서 100줄 이상 파일 직접 작성 금지**

```
# BAD - 컨텍스트 폭발
Write(file_path, 400줄_내용)

# GOOD - 에이전트에게 위임
Task(
  subagent_type: "general-purpose",
  model: "haiku",
  prompt: "다음 내용을 {file_path}에 저장하세요: ...",
  run_in_background: true
)
```

### 1.2 파일 크기 제한

| 파일 유형 | 최대 줄 수 | 초과 시 |
|-----------|-----------|---------|
| 챕터 결정문서 | 200줄 | 하위 파일로 분리 |
| 컴포넌트 명세 | 300줄 | 섹션별 분리 |
| 와이어프레임 | 150줄 | 화면별 분리 |
| 테스트 시나리오 | 100줄 | 시나리오별 분리 |

### 1.3 분리 규칙

```markdown
# 파일이 200줄 초과 시:

원본: 01-chapters/alternatives.md (500줄)

분리 후:
01-chapters/alternatives/
├── _index.md (목차, 50줄)
├── state-management.md (100줄)
├── data-fetching.md (100줄)
├── real-time.md (100줄)
├── calendar.md (100줄)
└── charts.md (100줄)
```

---

## 2. 에이전트 출력 규칙

### 2.1 반환 형식

에이전트가 메인 컨텍스트로 반환할 때:

```markdown
# BAD - 파일 내용 전체 반환
"완료됨. 내용:
[400줄의 전체 파일 내용...]"

# GOOD - 요약만 반환
"완료됨.
생성 파일:
- 03-components/spec-websocket.md (145줄)
- 03-components/spec-sse.md (132줄)
총 2개 파일, 277줄 생성
상세 내용은 파일 참조"
```

### 2.2 에이전트 프롬프트 필수 포함 문구

모든 에이전트 프롬프트에 다음 문구 포함:

```
CRITICAL OUTPUT RULES:
1. 모든 결과는 파일에 저장
2. 반환 시 파일 경로와 줄 수만 보고
3. 파일 내용을 응답에 포함하지 않음
4. 200줄 초과 시 자동 분리
```

---

## 3. 병렬 실행 제한

### 3.1 동시 에이전트 수

```markdown
# 최대 2개 동시 실행
# 4개 이상 동시 실행 금지 (결과 반환 시 컨텍스트 폭발)

# BAD
Task 1: run_in_background: true
Task 2: run_in_background: true
Task 3: run_in_background: true
Task 4: run_in_background: true  ← 4개 동시 = 위험

# GOOD
Batch 1: Task 1, Task 2 (동시)
→ 완료 대기
Batch 2: Task 3, Task 4 (동시)
→ 완료 대기
```

### 3.2 배치 실행 패턴

```
Phase 2 (UI Architecture + Component Discovery):
  Batch 2.1: ui-architect, component-auditor
  → 완료 대기 + _meta.json 업데이트
  Batch 2.2: component-builder, component-migrator
  → 완료 대기 + _meta.json 업데이트
```

---

## 4. 체크포인트 시스템

### 4.1 _meta.json 구조

```json
{
  "sessionId": "20260129-232811",
  "status": "in_progress",
  "currentPhase": 2,
  "currentStep": "2.1",
  "completedSteps": ["1.1", "1.2", "1.3", "1.4"],
  "pendingSteps": ["2.1", "2.2", "3.1", "3.2", "4.1", "5.1", "6.1"],
  "lastCheckpoint": "2026-01-29T23:35:00+09:00",
  "files": {
    "requirements": "00-requirements/requirements.md",
    "chapterPlan": "01-chapters/chapter-plan-final.md"
  },
  "canResume": true
}
```

### 4.2 체크포인트 타이밍

각 Step 완료 후 즉시 `_meta.json` 업데이트:

```
Step 1.1 완료 → _meta.json 업데이트
Step 1.2 완료 → _meta.json 업데이트
...
```

### 4.3 Phase 완료 시 알림

```markdown
Phase {N} 완료.

진행 상황:
- 완료: {완료된 파일 수}개 파일
- 다음: Phase {N+1} - {설명}

컨텍스트 관리:
- 현재 사용량이 높습니다
- 권장: 새 세션에서 --resume 옵션으로 재개
- 명령어: /frontend-skills:spec-it-automation --resume {sessionId}
```

---

## 5. Resume 기능

### 5.1 Resume 시작 프로세스

```
1. _meta.json 읽기
2. canResume 확인
3. currentPhase, currentStep 확인
4. 해당 Step부터 재개
```

### 5.2 Resume 프롬프트 감지

```markdown
# 다음 패턴 감지 시 Resume 모드 활성화:
- "--resume"
- "--continue"
- "이어서"
- "재개"
- "continue"
```

### 5.3 Resume 시 컨텍스트 로딩

```markdown
Resume 시 로딩할 파일 (최소한만):
1. _meta.json (필수)
2. chapter-plan-final.md (있으면)
3. 현재 Phase에 필요한 파일만

로딩하지 않음:
- 이전 Phase의 상세 파일
- critique-*.md (이미 반영됨)
- alternatives.md (이미 반영됨)
```

---

## 6. 오류 복구

### 6.1 Context Limit 도달 시

```markdown
"Context limit에 도달했습니다.

현재 상태가 저장되었습니다:
- Session ID: {sessionId}
- 완료된 Phase: {N}
- 다음 Step: {step}

재개 방법:
1. 새 세션 시작
2. /frontend-skills:spec-it-automation --resume {sessionId}
"
```

### 6.2 Compaction 실패 시

```markdown
/compact 실패 시:
1. 현재 상태를 _meta.json에 저장
2. 사용자에게 새 세션 재개 안내
3. 절대로 반복 시도하지 않음 (무한 루프 방지)
```

---

## 7. SPEC-IT-{HASH}.md 생성

### 7.1 생성 트리거

다음 폴더에 파일 생성 시 자동으로 SPEC-IT 파일 생성:

```
02-screens/wireframes/*  → SPEC-IT 생성
03-components/new/*      → SPEC-IT 생성
06-final/*               → SPEC-IT 생성
```

### 7.2 생성 명령

```bash
# 에이전트 프롬프트에 포함
"파일 생성 후 동일 폴더에 SPEC-IT-{HASH}.md 생성
HASH = 파일경로의 MD5 앞 8자리 대문자
템플릿: ../spec-it/assets/templates/SPEC_IT_*_TEMPLATE.md 사용"
```

### 7.3 Registry 업데이트

```json
// .spec-it-registry.json
{
  "hashes": {
    "A1B2C3D4": {
      "path": "02-screens/wireframes/SPEC-IT-A1B2C3D4.md",
      "source": "wireframe-dashboard.md",
      "created": "2026-01-29T23:40:00+09:00"
    }
  }
}
```

---

## 8. 금지 사항 체크리스트

실행 전 확인:

- [ ] 100줄 이상 파일을 직접 Write하려 하지 않는가?
- [ ] 3개 이상 에이전트를 동시에 실행하려 하지 않는가?
- [ ] 에이전트 프롬프트에 "요약만 반환" 규칙이 포함되어 있는가?
- [ ] Step 완료 후 _meta.json 업데이트가 포함되어 있는가?
- [ ] Phase 완료 후 컨텍스트 관리 안내가 포함되어 있는가?

---

**버전**: 1.0.0
**최종 수정**: 2026-01-30
