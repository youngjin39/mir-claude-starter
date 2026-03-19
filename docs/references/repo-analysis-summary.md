# Reference Repo Analysis Summary (2026-03-20)

## 1. Superpowers (obra) — TDD + 계획 강제 프레임워크

### 핵심 패턴
- **Iron Law + 합리화 테이블**: 규칙만 명시하면 AI가 우회함. "너무 단순해서 테스트 불필요" 같은 변명 목록 + 반박을 함께 제공해야 규칙이 작동.
- **Hard Gate**: brainstorming → writing-plans → executing-plans. 단계 건너뛰기 불가.
- **Bite-sized Steps**: 계획에 실제 코드 + 정확한 명령어 + 예상 출력 포함. "테스트 추가"가 아니라 구체적 코드.
- **검증 = 도덕**: 미검증 완료 주장을 "거짓말"로 프레이밍. "should", "probably" 금지.
- **시코팬시 금지**: "Great!", "You're absolutely right!" 등 수행적 동의 금지.
- **서브에이전트 격리**: 세션 히스토리 전달 금지. 정확히 필요한 컨텍스트만 조립.
- **리뷰 루프 상한**: 자동 리뷰 최대 3회 → 사람에게 에스컬레이션.
- **세션 시작 훅**: SessionStart에서 부트스트랩 스킬 자동 주입.

### 스킬 파이프라인
brainstorming → writing-plans → subagent-driven-development → finishing-a-development-branch

---

## 2. CLI-Anything (HKUDS) — OS 레벨 에이전트 하네스

### 핵심 패턴
- **단일 SOP 문서 (HARNESS.md)**: 모든 커맨드가 참조하는 763줄 방법론 문서. 중복 방지.
- **슬래시 커맨드 = 독립 마크다운**: /cli-anything, /cli-anything:refine, /cli-anything:validate 등.
- **레지스트리 패턴**: registry.json으로 모든 도구/스킬 중앙 관리.
- **검증 커맨드**: 52개 검사 × 8개 카테고리. 자동 적합성 검증.
- **이중 출력**: --json(기계용) + 컬러(사람용). 에이전트 워크플로우 필수.
- **Probe-before-mutate**: 상태 확인(info, list, status) 후 변경. 안전한 자동화.
- **네임스페이스 패키지**: 독립 설치 가능한 모듈 구조.

### 7단계 SOP
Codebase Analysis → CLI Design → Implementation → Test Planning → Test Implementation → SKILL.md Generation → Publishing

---

## 3. oh-my-claudecode (Yeachan-Heo) — 리스크 관리 + 워크플로우 커스텀

### 핵심 패턴
- **작성/리뷰 분리**: architect, critic, security-reviewer는 Write/Edit 도구 사용 불가. 자기 승인 방지.
- **수학적 모호성 게이팅**: 목표(40%) + 제약(30%) + 성공기준(30%) 가중 점수. 모호성 20% 이하에서만 실행.
- **Deep Interview**: 한 번에 질문 1개, 가장 약한 차원 공략, 코드베이스 먼저 탐색 후 질문.
- **챌린지 에이전트**: 4라운드(반대론자), 6라운드(단순화론자), 8라운드(존재론자).
- **구조적 커밋 트레일러**: Constraint:, Rejected:, Directive:, Not-tested: 등 결정 근거를 커밋에 보존.
- **모호 요청 게이트**: 파일 경로/함수명/번호 단계 없으면 차단. force: 접두사로 우회 가능.
- **계층적 워크플로우**: ultrawork → ralph → autopilot → team. 각 레이어가 하나의 역량 추가.
- **스테이지 핸드오프 문서**: .omc/handoffs/<stage>.md에 결정/대안/리스크 기록. 컨텍스트 압축에서 생존.
- **실패 모드 문서화**: 에이전트 프롬프트에 <Failure_Modes_To_Avoid> 섹션. 성공 기준보다 실효적.
- **3회 실패 서킷 브레이커**: 수정 3회 실패 → 아키텍처 재검토.

### 파이프라인
deep-interview → ralplan(합의) → autopilot(실행)

---

## 4. everything-claude-code (affaan-m) — 토큰 최적화 + 학습 + 검증

### 핵심 패턴
- **세션 지속성 + 실패 기억**: "What Did NOT Work (and why)" 섹션. 실패한 접근법 재시도 방지.
- **훅 기반 관찰 > 스킬 기반**: v1(스킬, ~50-80% 발동) → v2(훅, 100% 발동). 결정적 차이.
- **프로젝트 스코프 인스팅트**: 학습 패턴을 프로젝트별 격리. 2+프로젝트에서 confidence≥0.8이면 글로벌 승격.
- **전략적 압축**: 도구 호출 50회 → /compact 제안. 논리적 전환점(리서치→계획, 디버그→기능)에서.
- **구조적 핸드오프**: Context, Findings, Files Modified, Open Questions, Recommendations.
- **모델 라우팅**: Haiku(기계적) / Sonnet(구현) / Opus(아키텍처). 30-50% 토큰 절감.
- **트리거 테이블 레이지 로딩**: 세션 시작 시 전체 스킬 로드 대신 키워드→경로 매핑. 베이스라인 50%+ 절감.
- **비용 추적기**: Stop 훅에서 응답별 토큰 + USD 추정치를 costs.jsonl에 기록.
- **품질 게이트 훅**: PostToolUse(Edit/Write) → 언어별 자동 포맷/타입체크.
- **루프 오퍼레이터**: 자율 루프 감시. 정체(2체크포인트), 재시도 폭풍, 비용 편차 감지.

### 오케스트레이션 프리셋
- feature: planner → tdd-guide → code-reviewer → security-reviewer
- bugfix: planner → tdd-guide → code-reviewer
- refactor: architect → code-reviewer → tdd-guide
- security: security-reviewer → code-reviewer → architect
