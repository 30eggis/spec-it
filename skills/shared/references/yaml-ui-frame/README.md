# YAML UI Frame Reference

YAML 구조적 와이어프레임 작성 가이드. ui-architect 에이전트 및 모든 spec-it 스킬에서 사용.

## Why YAML?

| 항목 | ASCII art | YAML |
|------|-----------|------|
| 파일 크기 | 100% | **-64%** |
| 파싱 속도 | regex 기반 | **YAML.parse (10x)** |
| 토큰 중복 | 높음 | **-80% (_ref 사용)** |
| 구조 명확성 | 시각적 | **프로그래밍적** |

## Files

점진적 로딩을 위해 섹션별로 분리:

| File | 내용 | 로딩 시점 |
|------|------|----------|
| `01-basic-structure.md` | 화면/레이아웃 기본 구조 | 항상 |
| `02-grid-definition.md` | CSS Grid 정의 | 레이아웃 생성 시 |
| `03-components.md` | 컴포넌트 정의 방법 | 컴포넌트 배치 시 |
| `04-responsive.md` | 반응형 breakpoints | 반응형 설계 시 |
| `05-interactions.md` | 클릭, 폼, 상태 변경 | 인터랙션 정의 시 |
| `06-states.md` | loading, empty, error | 상태 설계 시 |
| `07-design-direction.md` | 트렌드, 색상, 모션 | 디자인 적용 시 |
| `08-accessibility.md` | 랜드마크, 포커스 | 접근성 설계 시 |
| `09-complete-example.md` | 전체 예시 | 참고용 |
| `10-migration.md` | ASCII → YAML 변환 | 마이그레이션 시 |

## Templates

관련 YAML 템플릿 (실제 출력 형식):

- `skills/spec-it-stepbystep/assets/templates/UI_WIREFRAME_TEMPLATE.yaml`
- `skills/spec-it-stepbystep/assets/templates/LAYOUT_TEMPLATE.yaml`
- `skills/spec-it-stepbystep/assets/templates/COMPONENT_SPEC_TEMPLATE.yaml`

## Usage

```
# ui-architect 에이전트에서 점진적 로딩
Read: skills/shared/references/yaml-ui-frame/01-basic-structure.md
Read: skills/shared/references/yaml-ui-frame/02-grid-definition.md
# ... 필요한 섹션만 추가 로딩
```
