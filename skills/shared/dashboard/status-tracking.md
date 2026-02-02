# Status Tracking System

실시간 대시보드를 위한 상태 추적 시스템.

---

## _status.json 스키마

```json
{
  "sessionId": "20260130-123456",
  "startTime": "2026-01-30T12:34:56+09:00",
  "currentPhase": 2,
  "currentStep": "2.1",
  "progress": 33,
  "status": "running",

  "agents": [
    {
      "name": "ui-architect",
      "status": "running",
      "startedAt": "2026-01-30T12:35:00+09:00",
      "duration": 135
    },
    {
      "name": "component-auditor",
      "status": "completed",
      "startedAt": "2026-01-30T12:35:00+09:00",
      "completedAt": "2026-01-30T12:37:15+09:00",
      "duration": 135,
      "output": "inventory.md (45줄), gap-analysis.md (32줄)"
    },
    {
      "name": "component-builder",
      "status": "pending"
    }
  ],

  "stats": {
    "filesCreated": 12,
    "linesWritten": 1847,
    "totalSize": "45KB"
  },

  "recentFiles": [
    "02-wireframes/product/buyer/wireframes/product-buyer-dashboard-01.yaml",
    "03-components/inventory.md"
  ],

  "errors": [],

  "lastUpdate": "2026-01-30T12:37:30+09:00"
}
```

---

## Agent Status Values

| Status | Description | Icon |
|--------|-------------|------|
| `pending` | 대기 중 | ○ |
| `running` | 실행 중 | ● |
| `completed` | 완료 | ✓ |
| `error` | 오류 | ✗ |

---

## Progress 계산

```
Phase 1: 0-16%   (Steps 1.1-1.4)
Phase 2: 17-33%  (Steps 2.1-2.2)
Phase 3: 34-50%  (Steps 3.1-3.2)
Phase 4: 51-66%  (Steps 4.1)
Phase 5: 67-83%  (Steps 5.1)
Phase 6: 84-100% (Steps 6.1-6.2)
```

```javascript
// Progress 계산 공식
function calculateProgress(phase, step) {
  const phaseProgress = {
    1: { base: 0, steps: { "1.1": 4, "1.2": 8, "1.3": 12, "1.4": 16 } },
    2: { base: 16, steps: { "2.1": 24, "2.2": 33 } },
    3: { base: 33, steps: { "3.1": 41, "3.2": 50 } },
    4: { base: 50, steps: { "4.1": 66 } },
    5: { base: 66, steps: { "5.1": 83 } },
    6: { base: 83, steps: { "6.1": 91, "6.2": 100 } }
  };

  return phaseProgress[phase]?.steps[step] || phaseProgress[phase]?.base || 0;
}
```

---

## SKILL.md 통합

모든 spec-it 스킬에서 다음 패턴 사용:

### 세션 시작 시

```
# _status.json 초기화
Write(.spec-it/{sessionId}/plan/_status.json, {
  "sessionId": "{sessionId}",
  "startTime": "{ISO timestamp}",
  "currentPhase": 1,
  "currentStep": "0.1",
  "progress": 0,
  "status": "running",
  "agents": [],
  "stats": { "filesCreated": 0, "linesWritten": 0 },
  "lastUpdate": "{ISO timestamp}"
})
```

### Step 시작 시

```
# 상태 업데이트
_status.currentStep = "2.1"
_status.progress = calculateProgress(2, "2.1")
_status.lastUpdate = {now}
Update(_status.json)
```

### Agent 시작 시

```
# 에이전트 추가
_status.agents.push({
  "name": "ui-architect",
  "status": "running",
  "startedAt": "{ISO timestamp}"
})
Update(_status.json)
```

### Agent 완료 시

```
# 에이전트 상태 업데이트
agent = _status.agents.find(a => a.name == "ui-architect")
agent.status = "completed"
agent.completedAt = "{ISO timestamp}"
agent.duration = {seconds}
agent.output = "wireframe-dashboard.yaml (120줄)"

# 통계 업데이트
_status.stats.filesCreated += 1
_status.stats.linesWritten += 120
Update(_status.json)
```

### 인라인 진행률 출력

```
Output: "
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Phase 2/6 [████████░░░░░░░░] 33% │ Files: 12 │ 05:32
Step 2.1: UI Architecture - ui-architect 실행 중
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"
```
