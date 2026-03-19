# Claude Code Prompt Harness

Claude Code 에이전트를 제어하고 오케스트레이션하는 프로젝트 관리 하네스.

> 코딩뿐 아니라 OS 레벨 자동화, 비코딩 워크플로우까지 확장 가능한 에이전트 + 스킬 + 훅 구조.

## 3축 설계

```
                    ┌─────────────────────┐
                    │   개발 워크플로우     │
                    │  (어떻게 일하는가)    │
                    └──────────┬──────────┘
                               │
              ┌────────────────┼────────────────┐
              │                                  │
   ┌──────────▼──────────┐           ┌──────────▼──────────┐
   │   메모리 효율성       │           │  컨텍스트 효율성      │
   │  (무엇을 기억하는가)  │           │  (무엇을 로드하는가)  │
   └─────────────────────┘           └─────────────────────┘
```

- **워크플로우**: 모호 게이트 → 분류 → brainstorming → plans → execution → verification
- **메모리**: 뉴런 장기 메모리 (키워드 인덱스, 감쇠 없음, 3층 분리)
- **컨텍스트**: 레이지 로딩, 모델 라우팅, 서브에이전트 격리, 핸드오프 문서

## 구조

```
.
├── CLAUDE.md                    # 루트 설정 (173줄)
├── .mcp.json                    # MCP 서버 (fetch + sequential-thinking)
├── .claude/
│   ├── settings.local.json      # 권한 + 훅 설정
│   ├── hooks/                   # 자동화 훅 스크립트
│   │   ├── session-start.sh     # 세션 시작 시 컨텍스트 주입
│   │   ├── pre-compact.sh       # 압축 전 핸드오프 리마인더
│   │   └── post-edit-check.sh   # 편집 후 디버그 문 경고
│   ├── agents/                  # 에이전트 3개
│   │   ├── main-orchestrator.md # 오케스트레이션 (opus)
│   │   ├── executor-agent.md    # 코드 작성 전담 (sonnet)
│   │   └── quality-agent.md     # 읽기 전용 리뷰 (sonnet)
│   └── skills/                  # 스킬 8개
│       ├── brainstorming/       # 설계 강제 (Hard Gate)
│       ├── writing-plans/       # 구체적 구현 계획
│       ├── verification/        # 6단계 검증 게이트
│       ├── deep-interview/      # 모호성 게이팅
│       ├── code-review/         # 품질 검사
│       ├── testing/             # 테스트 작성/실행
│       ├── git-commit/          # 커밋 규칙 + 트레일러
│       └── project-doctor/      # 상태 진단
├── tasks/                       # 워킹 메모리
│   ├── plan.md                  # 현재 계획 (compact)
│   ├── context.md               # 결정 근거
│   ├── checklist.md             # 진행 상황
│   ├── change_log.md            # 수정 기록
│   ├── lessons.md               # 실패/성공 → 규칙
│   ├── cost-log.md              # 비용 추적
│   ├── handoffs/                # 단계 간 핸드오프
│   ├── sessions/                # 세션 스냅샷
│   └── log/                     # 완료 아카이브
└── docs/                        # 뉴런 장기 메모리
    ├── memory-map.md            # 키워드 인덱스
    ├── decisions/               # ADR + 전체 설계
    ├── references/              # 참조 레포 분석
    ├── architecture/
    ├── patterns/
    ├── domain/
    ├── risks/
    └── integrations/
```

## 에이전트

| 에이전트 | 모델 | 역할 | 코드 작성 |
|---|---|---|---|
| main-orchestrator | opus | 대화, 판단, 분류, 단순 실행 | O (단순) |
| executor-agent | sonnet | 복합 작업 코드 작성 전담 | O (복합) |
| quality-agent | sonnet | 읽기 전용 리뷰 (Write/Edit 금지) | X |

## 스킬

| 스킬 | 트리거 | 역할 |
|---|---|---|
| brainstorming | 설계, 브레인스토밍 | Hard Gate. 2~3 대안 비교 필수. |
| writing-plans | 계획, 구현 계획 | Bite-sized Steps. 구체적 코드 포함. |
| verification | 완료 확인, 검증 | 6단계 게이트 + 서킷 브레이커. |
| deep-interview | 인터뷰, 모호 | 모호성 점수 + 챌린지 라운드. |
| code-review | 리뷰, PR | 품질 검사 (fork). |
| testing | 테스트, TDD | 테스트 작성/실행. |
| git-commit | 커밋, git | 커밋 규칙 + 구조적 트레일러. |
| project-doctor | 진단, 헬스체크 | 구조 + 메모리 + 컨텍스트 진단. |

## 워크플로우 파이프라인

```
요청 → 구체성 신호? → 없으면 deep-interview → 분류
  ├─ 단순(1~2단계) → orchestrator 직접 실행 → 셀프체크 → 완료
  └─ 복합(3단계+) → 플랜 모드
       brainstorming → writing-plans → execution → verification → 완료
```

### 오케스트레이션 프리셋

| 프리셋 | 파이프라인 |
|---|---|
| feature | brainstorming → plans → executor → code-review → verification |
| bugfix | deep-interview(lite) → executor → testing → verification |
| refactor | brainstorming → plans → executor → code-review |
| security | code-review(security) → executor → verification |

## 메모리 시스템

### 3층 분리
- **층 1 (docs/)**: 프로젝트 지식. 장기, 감쇠 없음. 키워드 인덱스로 선택적 로드.
- **층 2 (tasks/lessons.md)**: 행동 규칙. 실패 우선 기록. 2회 반복 시 규칙 승격.
- **층 3 (tasks/sessions/)**: 세션 복원. 최근 1개만 유효.

### 뉴런 메모리 특징
- 키워드 → 카테고리 → 파일 매핑 (Topic-Cued Recall)
- 파일당 50줄 이내. 프론트매터 필수 (title, keywords, created, last_used).
- 전체 카테고리 로드 금지. 필요한 파일만 Read.
- 메모리 파일 100개+ → SQLite 전환 검토.

## 컨텍스트 효율성

- **레이지 로딩**: CLAUDE.md에 트리거 테이블만. 스킬 본문은 발동 시 Read.
- **모델 라우팅**: Haiku(탐색) / Sonnet(구현) / Opus(아키텍처).
- **서브에이전트 격리**: 세션 히스토리 전달 금지. 핸드오프 문서만 전달.
- **plan.md compact**: 전체 설계는 docs/에 아카이브. plan.md는 50줄 이내.

## 자동화 훅

| 훅 | 이벤트 | 동작 |
|---|---|---|
| session-start.sh | SessionStart | plan + lessons + 최근 세션 자동 주입 |
| pre-compact.sh | PreCompact | 핸드오프 작성 리마인더 |
| post-edit-check.sh | PostToolUse(Edit\|Write) | 디버그 문 (console.log, print) 경고 |

## 사용법

### 새 프로젝트에 적용
1. 이 레포를 클론하거나 복사.
2. `CLAUDE.md`의 개발 환경/빌드 섹션을 프로젝트에 맞게 수정.
3. 필요한 도메인 스킬을 `.claude/skills/`에 추가.
4. `tasks/` 파일들을 초기화.
5. 작업 시작.

### 도메인 스킬 추가
하네스 스킬(범용)과 도메인 스킬(프로젝트 특화)은 분리됩니다:
- 하네스 스킬: brainstorming, verification 등 — 모든 프로젝트에 적용
- 도메인 스킬: api-design, security-audit 등 — 프로젝트별 추가

## 참고한 프로젝트

이 하네스의 설계에 영감을 준 프로젝트들입니다:

| 프로젝트 | 주요 참고 | 링크 |
|---|---|---|
| **Superpowers** | TDD 강제, Hard Gate, Iron Law, 검증 = 도덕, 합리화 방지 테이블 | [obra/superpowers](https://github.com/obra/superpowers) |
| **CLI-Anything** | 에이전트 하네스 구조, SOP 문서, 레지스트리, 검증 커맨드 | [HKUDS/CLI-Anything](https://github.com/HKUDS/CLI-Anything) |
| **oh-my-claudecode** | 작성/리뷰 분리, Deep Interview, 리스크 관리, 핸드오프 문서 | [Yeachan-Heo/oh-my-claudecode](https://github.com/Yeachan-Heo/oh-my-claudecode) |
| **everything-claude-code** | 토큰 최적화, 레이지 로딩, 세션 지속성, 실패 기억, 비용 추적 | [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) |

## License

MIT License. 참고한 프로젝트 모두 MIT License.
