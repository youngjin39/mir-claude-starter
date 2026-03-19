# Context

## 프로젝트 목적
Claude Code 프로젝트 관리 하네스. 3축 중심:
1. 개발 워크플로우 — 파이프라인
2. 메모리 효율성 — 키워드 인덱스, 선택적 로드
3. 컨텍스트 효율성 — 레이지 로딩, 모델 라우팅, 핸드오프

## 핵심 결정 (9개)

### 1. 3축 중심 재편
- v1은 "규칙 강제" 중심. 메모리/컨텍스트가 후순위.
- → 매 Phase가 3축 모두에 기여하도록 재설계.

### 2. 규칙 = 파이프라인에 내장
- 별도 단계로 분리하면 본체와 괴리. (Superpowers)

### 3. orchestrator/executor 분기 기준
- **단순(1~2단계)**: orchestrator 직접 실행. 서브에이전트 오버헤드 회피.
- **복합(3단계+)**: executor-agent 위임. 파이프라인 적용.
- **모호하면 복합으로** (과소평가보다 안전).
- quality-agent는 항상 읽기 전용 (Write/Edit 금지). (OMC)

### 4. 메모리 3층 분리 (4층→3층 축소)
- `docs/` = 프로젝트 지식 (what we know). 장기, 감쇠 없음.
- `tasks/lessons.md` = 행동 규칙 (what to do/not do). 실패 우선 기록.
- `tasks/sessions/` = 세션 복원 (ephemeral). 최근 1개만 유효.
- ~~.claude/agent-memory/~~ → docs/에 통합. 별도 레이어 제거.

### 5. registry.json 제거
- 트리거 테이블(CLAUDE.md) + glob 검증(project-doctor)으로 충분.
- 두 곳 동기화 부담 제거. (CLI-Anything 패턴은 규모가 클 때만 유효)

### 6. Deep Interview Lite vs 본격
- **Lite (Phase 1)**: 모호하면 명확화 질문 1~2개. 로직 없음.
- **본격 (Phase 2)**: 모호성 점수(목표40%+제약30%+성공기준30%), 한 번에 질문 1개, 챌린지 라운드. (OMC)

### 7. 훅 = 셸 명령 기반 (Phase 3)
- SessionStart: `cat tasks/plan.md tasks/lessons.md` → 컨텍스트 주입.
- PostToolUse(Edit|Write): `jq + linter` → 자동 포맷/체크.
- PreCompact: 핸드오프 자동 생성 스크립트.
- 훅은 "스킬 자동 로드"가 아님. CLAUDE.md 지시로 처리.

### 8. plan.md compact 원칙
- 전체 설계는 docs/decisions/master-plan-v2.md (아카이브).
- plan.md는 현재 Phase + 다음 액션만. 50줄 이내 목표.
- 세션 재개 시 토큰 절약.

### 9. 레이지 로딩 + 키워드 인덱스
- CLAUDE.md에 스킬 본문 미포함. 트리거 테이블(키워드→경로)만.
- memory-map.md에 키워드→파일 매핑. 전체 로드 금지.
- (everything-claude-code: 베이스라인 50%+ 절감)

## 기술적 참고
- 참조 레포 분석: docs/references/repo-analysis-summary.md
- 전체 설계: docs/decisions/master-plan-v2.md
- macOS Darwin 25.3.0, ARM64, git 미초기화

## 제약
- 토큰 비용 민감 → 모델 라우팅 + 레이지 로딩
- 계획서 꼼꼼히 쓰는 스타일 → Hard Gate 우선
- 한글 보고 / 영어 내부
- 장기 메모리 감쇠 없음 → 관리 중요
