# Dev-Pilot Workflow

spec-it 산출물을 병렬 실행으로 구현하는 워크플로우입니다.

## Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                      SPEC-IT (P1-P14)                          │
│  Requirements → Design → Wireframes → Components → Scenarios   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
                    spec-map.md + task-registry.json
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                       DEV-PILOT                                 │
│                                                                 │
│  Phase 0: Load Context ─────────────────────────────────────►  │
│  Phase 1: Task Analysis (parallelizable?)                      │
│  Phase 2: Decomposition (task-registry → subtasks)             │
│  Phase 3: File Ownership Partitioning                          │
│  Phase 4: Parallel Execution (up to 5 workers)                 │
│  Phase 5: Integration (shared files)                           │
│  Phase 6: Validation (build, test, spec compliance)            │
└─────────────────────────────────────────────────────────────────┘
                              ↓
                      Working Application
```

## Agent Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEV-PILOT (Coordinator)                      │
│                                                                 │
│  - Reads spec-it artifacts                                     │
│  - Decomposes tasks                                            │
│  - Partitions file ownership                                   │
│  - Spawns and monitors workers                                 │
│  - NEVER writes code directly                                  │
└─────────────────────────────────────────────────────────────────┘
         │
         ├──► dev-executor-low (Haiku) - Simple tasks
         │       └─ Single file changes, type fixes
         │
         ├──► dev-executor (Sonnet) - Standard tasks
         │       └─ Feature implementation, component creation
         │
         ├──► dev-executor-high (Opus) - Complex tasks
         │       └─ Multi-file architecture, cross-cutting concerns
         │
         ├──► dev-build-fixer (Sonnet) - Build errors
         │       └─ Type errors, compilation failures
         │
         └──► dev-architect (Opus) - Verification
                 └─ Spec compliance, architecture review
```

## File Ownership Strategy

### Exclusive Ownership
각 워커가 독점적으로 관리하는 파일 집합:

```
Worker 1: src/api/**
Worker 2: src/components/**
Worker 3: src/pages/**
Worker 4: src/hooks/**
Worker 5: tests/**
```

### Shared Files (Sequential)
통합 단계에서 순차적으로 처리:

- package.json
- tsconfig.json
- src/types/index.ts (shared types)

### Boundary Files
여러 워커가 import하지만 한 워커만 수정:

- src/types/*.ts → 가장 관련 있는 워커가 소유
- src/utils/*.ts → 첫 번째 필요한 워커가 생성

## State Files

```
.spec-it/{sessionId}/execute/
├── dev-pilot-state.json    # 전체 상태
├── decomposition.json      # 분해 결과
├── file-ownership.json     # 파일 소유권 맵
└── notes/
    ├── learnings.md        # 워커 학습 내용
    └── issues.md           # 발생 이슈
```

## Usage Examples

### Basic Usage
```
/spec-it:dev-pilot {sessionId}
```

### With Task Filter
```
/spec-it:dev-pilot {sessionId} --tasks=frontend,api
```

### Resume After Failure
```
/spec-it:dev-pilot resume {sessionId}
```

### Dry Run (Show Plan)
```
/spec-it:dev-pilot {sessionId} --dry-run
```

## Integration with spec-it-execute

dev-pilot은 spec-it-execute의 Phase 3 (구현)을 병렬화합니다:

| spec-it-execute Phase | dev-pilot Equivalent |
|----------------------|---------------------|
| Phase 0: Context Load | Phase 0: Load Context |
| Phase 1: Task Extract | Uses task-registry.json |
| Phase 2: Setup | Phase 2-3: Decomposition + Ownership |
| Phase 3: Implement | Phase 4: Parallel Execution |
| Phase 4: Test | Phase 6: Validation |
| Phase 5-9 | (Post dev-pilot) |

## When to Use

### Use dev-pilot when:
- spec-it output has 3+ independent component groups
- Clear module boundaries exist
- Minimal cross-component dependencies
- Speed is priority

### Use sequential execution when:
- Heavy interdependencies
- Single module changes
- Requires constant integration checks
- Small focused features

## Speed Comparison

| Project Type | Sequential | dev-pilot | Speedup |
|--------------|------------|-----------|---------|
| Full-stack app | 60 min | 15 min | 4x |
| Component library | 45 min | 12 min | 3.7x |
| API + Tests | 30 min | 10 min | 3x |
| Single feature | 15 min | 15 min | 1x (no gain) |
