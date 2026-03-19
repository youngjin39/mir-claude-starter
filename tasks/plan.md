# Plan (compact — 전체 설계는 docs/decisions/master-plan-v2.md)

## 3축 중심
1. **개발 워크플로우** — 파이프라인으로 작업이 흐른다
2. **메모리 효율성** — 키워드 인덱스로 필요한 것만 로드
3. **컨텍스트 효율성** — 레이지 로딩 + 모델 라우팅 + 핸드오프

## 현재 상태: Phase 1~3 전체 완료

### 완료 산출물
- 에이전트 3개 (orchestrator/executor/quality)
- 스킬 8개 (brainstorming/writing-plans/verification/deep-interview/code-review/testing/git-commit/project-doctor)
- 훅 3개 (SessionStart/PreCompact/PostToolUse)
- 뉴런 메모리 (7카테고리 + 키워드 인덱스 + 저장/승격 프로토콜)
- CLAUDE.md v2 (173줄: 파이프라인+트리거+라우팅+프리셋+격리+훅)

## 다음 액션 (사용자 선택)
1. 실제 코드 프로젝트에 하네스 적용 (실전 테스트)
2. 도메인 스킬 추가 (보안, 성능, API 등)
3. git 초기화 + 첫 커밋
