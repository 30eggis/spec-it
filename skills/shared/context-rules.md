# Context Management Rules (Shared)

**CRITICAL**: 이 규칙은 모든 spec-it 계열 스킬에서 반드시 준수해야 합니다.

---

## 1. 파일 작성 규칙

### 1.0 메인 오케스트레이터 Bash 파일 쓰기 금지 (CRITICAL)

**메인 오케스트레이터에서 Bash로 파일 쓰기 절대 금지**

```
# ❌ BAD - 권한 요청 발생 (흐름 중단)
Bash: cat > /path/to/file.json << 'EOF'
{...}
EOF

Bash: echo '{"key": "value"}' > /path/to/file.json

# ✅ GOOD - Write 도구 사용
Write(/path/to/file.json, '{"key": "value"}')

# ✅ GOOD - 상태 파일은 스크립트 사용
Bash: $HOME/.claude/plugins/marketplaces/claude-frontend-skills/scripts/core/status-update.sh {sessionDir} phase-complete 1 2 "2.1"
```

**이유:**
- 서브에이전트(Task)는 `bypassPermission: true`로 Bash 권한 요청 없음
- 메인 오케스트레이터는 `bypassPermission` 미적용
- 메인에서 Bash로 파일 쓰기 시 권한 요청 발생 → **automation 모드 흐름 중단**

**허용되는 Bash 명령 (메인 오케스트레이터):**
- ✅ status-update.sh 호출
- ✅ meta-checkpoint.sh 호출
- ✅ session-init.sh 호출
- ✅ execute-session-init.sh 호출
- ✅ planner/executor 스크립트 호출
- ✅ 읽기 전용 명령 (ls, cat, grep 등)

**금지되는 Bash 명령 (메인 오케스트레이터):**
- ❌ `cat > file <<` (heredoc)
- ❌ `echo ... > file` (리다이렉션)
- ❌ `printf ... > file`
- ❌ `tee file`
- ❌ `sed -i` (in-place 편집)
- ❌ 모든 파일 쓰기/수정 Bash 명령

**파일 작성이 필요할 때:**
1. 상태 파일 → status-update.sh 스크립트 사용
2. 일반 파일 → Write 도구 사용
3. 대용량 파일 → 서브에이전트(Task)에게 위임

---

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
| 모든 문서 | 600줄 | {index}-{name}-{type}.md로 분리 |
| 와이어프레임 | **무제한** | 분리 불필요 |

### 1.3 분리 규칙

```markdown
# 파일이 600줄 초과 시 (와이어프레임 제외):

원본: 00-requirements/requirements.md (800줄)

분리 후:
00-requirements/
├── _index.md (목차, 30-50줄)
├── 0-overview-requirement.md (100줄)
├── 1-auth-requirement.md (150줄)
├── 2-dashboard-requirement.md (200줄)
├── 3-trading-requirement.md (180줄)
└── 4-notification-requirement.md (120줄)
```

### 1.4 통일 네이밍 규칙

모든 분리 파일은 `{index}-{name}-{type}.md` 형식 사용:

| 폴더 | type suffix | 예시 |
|------|-------------|------|
| 00-requirements | -requirement | 0-auth-requirement.md |
| 01-chapters/decisions | -decision | 0-scope-decision.md |
| 01-chapters/alternatives | -alternative | 0-state-alternative.md |
| 02-screens | -screen | 0-login-screen.md |
| 03-components/new | -component | 0-button-component.md |
| 03-components/migrations | -migration | 0-datatable-migration.md |
| 04-review/scenarios | -scenario | 0-login-scenario.md |
| 04-review/exceptions | -exception | 0-timeout-exception.md |
| 05-tests/personas | -persona | 0-newbie-persona.md |
| 05-tests/scenarios | -test | 0-checkout-test.md |
| 06-final | -spec, -task | 0-overview-spec.md |

**index 규칙**:
- 0부터 시작하는 순차 번호
- 논리적 순서 또는 우선순위 기반
- 한 자리수 사용 (0-9), 10개 초과 시 두 자리 (00-99)

### 1.5 _index.md 템플릿

분리 발생 시 해당 폴더에 `_index.md` 필수 생성:

```markdown
# {Section Name} - Index

## Overview
{섹션 개요}

## Files
| # | File | Description | Lines |
|---|------|-------------|-------|
| 0 | [0-auth-requirement.md](./0-auth-requirement.md) | 인증/계정 관리 | 120 |
| 1 | [1-dashboard-requirement.md](./1-dashboard-requirement.md) | 대시보드 | 95 |
| ... | ... | ... | ... |

## Cross References
- Related: [../02-screens/](../02-screens/)
- Dependencies: [../03-components/](../03-components/)
```

---

## 2. 에이전트 출력 규칙

### 2.1 터미널 출력 최소화 (CRITICAL)

**에이전트 실행 중 터미널에는 진행 상태만 표시합니다.**

```markdown
# 표시되는 것 (OK)
● stitch-convert 실행 중...
✓ stitch-convert 완료

# 표시되지 않는 것 (숨김)
- 에이전트 내부 로그
- Bash 명령 출력
- API 응답 내용
- 파일 내용
- 디버그 정보
```

### 2.2 반환 형식

에이전트가 메인 컨텍스트로 반환할 때:

```markdown
# BAD - 파일 내용 전체 반환
"완료됨. 내용:
[400줄의 전체 파일 내용...]"

# BAD - 로그/상세 정보 반환
"Step 1 시작... npm install 실행...
설치 완료... OAuth 시작...
[상세 로그들...]"

# GOOD - 최소 요약만 반환
"완료. 파일 3개 생성."
```

### 2.3 에이전트 프롬프트 필수 포함 문구

모든 에이전트 프롬프트에 다음 문구 포함:

```
CRITICAL OUTPUT RULES:
1. 모든 결과는 파일에 저장
2. 터미널에 로그/상세 정보 출력 금지
3. 반환 시 한 줄 요약만: "완료. {결과 요약}"
4. 파일 내용을 응답에 절대 포함하지 않음
5. Bash 출력 표시 금지 (결과만 파일에 저장)
6. 600줄 초과 시 분리 (와이어프레임 제외)
7. 분리 시 네이밍: {index}-{name}-{type}.md
8. 분리 시 _index.md 필수 생성

SILENT MODE:
- 진행 상황 출력 금지
- 에러만 출력 (실패 시)
- 모든 로그는 파일로: .spec-it/{sessionId}/logs/
```

### 2.4 진행 상태 표시 (메인 스킬에서만)

```markdown
# 메인 스킬이 진행 상태 표시 (에이전트가 아님)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 2/6 [████████░░░░░░░░] 33%
● stitch-convert 실행 중...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# 완료 시
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 2/6 [████████░░░░░░░░] 33%
✓ stitch-convert 완료 (화면 5개 생성)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 3. 병렬 실행 제한

### 3.1 동시 에이전트 수

```markdown
# 최대 4개 동시 실행
# 5개 이상 동시 실행 금지 (결과 반환 시 컨텍스트 폭발)

# BAD
Task 1~5: run_in_background: true  ← 5개 동시 = 위험

# GOOD - 4개씩 배치
Batch 1: Task 1, Task 2, Task 3, Task 4 (동시)
→ 완료 대기
Batch 2: Task 5, Task 6 (동시)
→ 완료 대기
```

### 3.2 파이프라인 실행 패턴

```
# 의존성 없는 Phase는 파이프라인으로 실행
Phase 2 (UI Architecture + Component Discovery):
  # 4개 동시 실행
  Parallel: ui-architect, component-auditor, component-builder, component-migrator
  → 완료 대기 + _meta.json 업데이트

# Critique는 Multi-Agent Debate 패턴 (3회 순차 → 3병렬 + Moderator)
Phase 1.3 (Critique):
  Parallel: critic-logic, critic-feasibility, critic-frontend (3개 병렬)
  → 완료 대기
  Sequential: critic-moderator (합의 도출)
  → 완료 대기
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

- [ ] **메인 오케스트레이터에서 Bash로 파일 쓰기하려 하지 않는가?** (cat >, echo >, heredoc 등)
- [ ] 100줄 이상 파일을 직접 Write하려 하지 않는가?
- [ ] 5개 이상 에이전트를 동시에 실행하려 하지 않는가?
- [ ] 에이전트 프롬프트에 "요약만 반환" 규칙이 포함되어 있는가?
- [ ] Step 완료 후 _meta.json 업데이트가 포함되어 있는가?
- [ ] Phase 완료 후 컨텍스트 관리 안내가 포함되어 있는가?
- [ ] 600줄 초과 파일이 와이어프레임이 아닌 경우 분리되었는가?
- [ ] 분리된 파일이 {index}-{name}-{type}.md 형식을 따르는가?
- [ ] 분리 발생 폴더에 _index.md가 생성되었는가?

---

**버전**: 1.0.0
**최종 수정**: 2026-01-30
