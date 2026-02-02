# spec-it MCP Server

MCP (Model Context Protocol) 서버로 동작하는 spec-it 프론트엔드 사양 생성기입니다.

## 설치

```bash
cd mcp-server
npm install
npm run build
```

## 사용법

### Claude Code에서 사용

`.mcp.json`에 이미 설정되어 있습니다:

```json
{
  "mcpServers": {
    "spec-it": {
      "command": "node",
      "args": ["./mcp-server/dist/index.js"]
    }
  }
}
```

### 독립 실행

```bash
npm start
```

### MCP Inspector로 테스트

```bash
npm run inspect
```

## 제공 기능

### Tools (도구)

| 도구 | 설명 |
|------|------|
| `spec_generate` | 요구사항에서 프론트엔드 사양 생성 |
| `spec_execute` | 생성된 사양을 코드로 구현 |
| `spec_change` | 기존 사양에 변경 적용 (6단계 검증) |
| `spec_mirror` | 사양 vs 구현 비교 |
| `list_sessions` | 세션 목록 조회 |
| `get_session` | 세션 상세 정보 |
| `resume_session` | 세션 재개 |
| `read_spec_file` | 사양 파일 읽기 |
| `list_spec_files` | 사양 파일 목록 |
| `get_agents` | 에이전트 목록 |

### Resources (리소스)

| URI | 설명 |
|-----|------|
| `spec://skills` | 사용 가능한 스킬 목록 |
| `spec://agents` | 에이전트 목록 (23+개) |
| `spec://design-trends` | 2026 디자인 트렌드 |
| `spec://sessions/{id}` | 세션 정보 |
| `spec://output/{folder}` | 사양 출력 폴더 |

### Prompts (프롬프트)

| 프롬프트 | 설명 |
|---------|------|
| `generate_spec` | 사양 생성 가이드 |
| `execute_spec` | 구현 실행 가이드 |
| `change_spec` | 변경 적용 가이드 |
| `compare_spec` | 비교 가이드 |

## 사양 생성 모드

| 모드 | 설명 | 승인 | 자동 실행 |
|------|------|------|----------|
| `automation` | 완전 자동화 | 최종만 | O |
| `complex` | 하이브리드 | 4 마일스톤 | X |
| `stepbystep` | 단계별 | 매 챕터 | X |
| `fast` | 프로토타입 | 최종만 | O |

## 디자인 스타일

- **Minimal**: 밝은 테마, 미니멀 카드 (권장)
- **Immersive**: 다크 테마, 그라데이션, 네온 포인트
- **Organic**: Glassmorphism, 부드러운 곡선
- **Custom**: 개별 트렌드 선택

## 출력 구조

```
tmp/
├── 00-requirements/    # 요구사항
├── 01-chapters/        # 설계 결정
├── 02-wireframes/      # YAML 와이어프레임
├── 03-components/      # 컴포넌트 사양
├── 04-review/          # 리뷰 (시나리오, IA, 예외)
├── 05-tests/           # 테스트 사양
└── 06-final/           # 최종 산출물
    ├── final-spec.md
    ├── dev-tasks.md
    └── SPEC-SUMMARY.md
```

## 에이전트 시스템

23+개의 전문 에이전트가 각 단계를 담당합니다:

- **설계**: design-interviewer, divergent-thinker, chapter-planner, ui-architect
- **비평**: critic-logic, critic-feasibility, critic-frontend, critic-moderator
- **컴포넌트**: component-auditor, component-builder, component-migrator
- **리뷰**: critical-reviewer, ambiguity-detector, spec-critic
- **테스트**: persona-architect, test-spec-writer
- **실행**: spec-executor, code-reviewer, security-reviewer
- **검증**: spec-butterfly, spec-doppelganger, spec-conflict, spec-clarity, spec-consistency, spec-coverage

## 예제

### 사양 생성

```
사용자: "사용자 대시보드를 만들어줘"

1. spec_generate 호출
   - requirements: "사용자 대시보드..."
   - mode: "automation"
   - designStyle: "Minimal"

2. 워크플로우 자동 진행
   - Phase 1: 요구사항 → 대안 → 비평 → 계획
   - Phase 2: UI 아키텍처 → 컴포넌트
   - Phase 3: 시나리오 리뷰
   - Phase 4: 테스트 사양
   - Phase 5: 최종 조합
   - Phase 6: 자동 구현
```

### 세션 재개

```
1. list_sessions 호출
2. resume_session 호출
   - sessionId: "20260202-123456"
3. 중단된 지점부터 계속
```

## 라이선스

MIT
