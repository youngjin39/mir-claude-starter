# Master Plan — prompt_DEV 하네스 (v2, 3축 재설계)

> 중심축: **개발 워크플로우** / **메모리 효율성** / **컨텍스트 효율성**
> 기반: CLI-Anything, oh-my-claudecode, Superpowers, everything-claude-code 분석

---

## 설계 원칙

```
                    ┌─────────────────────┐
                    │   개발 워크플로우     │  ← 작업이 흐르는 파이프라인
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

- 워크플로우가 중심. 메모리와 컨텍스트는 워크플로우를 지탱하는 양 축.
- 규칙 강제(Iron Law 등)는 파이프라인 각 단계에 **내장**. 별도 Phase가 아님.
- 매 Phase가 3축 모두에 기여해야 함. 한 축만 강화하는 Phase 없음.

---

## 현재 상태 (v1 완료)

| 구분 | 보유 | 부족 |
|---|---|---|
| 워크플로우 | 에이전트 2, 스킬 4, 기본 CLAUDE.md | 파이프라인 설계 없음, 단계 간 게이트 없음 |
| 메모리 | docs/memory-map.md(빈 인덱스), tasks/ 5파일 | 검색 불가, 카테고리 미구축, 실패 기억 없음 |
| 컨텍스트 | 없음 | 레이지 로딩 없음, 압축 전략 없음, 모델 라우팅 없음 |

---

## Phase 1 — 기반 (Foundation)

> 목표: 3축 각각의 **뼈대**를 세운다.

### 1.1 워크플로우 파이프라인 설계

#### 1.1.1 작업 흐름 정의
```
요청 진입
  │
  ├─ 모호? ──→ [Deep Interview Lite] ──→ 명확화
  │                                        │
  ▼                                        ▼
분류 (단순/복합)
  │
  ├─ 단순 (1~2단계) ──→ 직접 실행 ──→ 셀프체크 ──→ 완료
  │
  └─ 복합 (3단계+) ──→ [플랜 모드]
                          │
                          ▼
                    ┌─ brainstorming ─┐
                    │  설계 + 대안 비교 │
                    └──────┬─────────┘
                           │ ✅ 사용자 승인
                           ▼
                    ┌─ writing-plans ──┐
                    │ 구체적 단계 계획   │
                    │ (코드+명령어+출력) │
                    └──────┬──────────┘
                           │ ✅ 계획 승인
                           ▼
                    ┌─ execution ──────┐
                    │ 단계별 실행+검증   │
                    │ (3회 실패→STOP)   │
                    └──────┬──────────┘
                           │
                           ▼
                    ┌─ verification ───┐
                    │ 증거 기반 검증     │
                    │ (should/probably  │
                    │  금지)            │
                    └──────┬──────────┘
                           │ ✅ 검증 통과
                           ▼
                        완료 + 기록
```

#### 1.1.2 생성할 파일
| 파일 | 역할 |
|---|---|
| `.claude/skills/brainstorming/SKILL.md` | 설계 강제. 코딩 전 Hard Gate. |
| `.claude/skills/writing-plans/SKILL.md` | 구체적 구현 계획 (Bite-sized Steps). |
| `.claude/skills/verification/SKILL.md` | 증거 기반 검증. 미검증 완료 금지. |
| `.claude/agents/executor-agent.md` | 코드 작성 전담. Write/Edit 허용. |

#### 1.1.3 기존 파일 수정
| 파일 | 변경 |
|---|---|
| `.claude/agents/quality-agent.md` | disallowedTools: Write, Edit 추가 (리뷰 전용화) |
| `.claude/agents/main-orchestrator.md` | 파이프라인 프로토콜로 교체 + 실패 모드 섹션 추가 |
| `CLAUDE.md` | 워크플로우 오케스트레이션 섹션을 파이프라인 다이어그램으로 교체 |

#### 1.1.4 각 단계 게이트 조건
| 단계 | 진입 조건 | 탈출 조건 |
|---|---|---|
| brainstorming | 복합 작업 분류 | 사용자가 설계 승인 |
| writing-plans | brainstorming 탈출 | 계획에 구체적 코드+명령어+예상 출력 포함 |
| execution | writing-plans 탈출 | 모든 단계 실행 완료 또는 3회 실패→STOP |
| verification | execution 탈출 | 증거(실행 결과) 기반 검증 통과 |

#### 1.1.5 규칙 내장 (별도 Phase 아님)
- **brainstorming**: 2~3개 대안 비교 필수. 1개만 제시 금지.
- **writing-plans**: "테스트 추가" 같은 추상적 표현 금지. 실제 코드 포함.
- **execution**: 3회 실패 서킷 브레이커. 4회째 시도 대신 아키텍처 재검토.
- **verification**: "should work", "probably fine" 금지. 실행 증거만 인정.

---

### 1.2 뉴런 메모리 구조 구축

#### 1.2.1 디렉토리 구조
```
docs/
├── memory-map.md              # 마스터 인덱스 (카테고리 → 키워드 → 파일)
├── architecture/              # 시스템 구조, 설계 패턴
├── decisions/                 # ADR (Architecture Decision Records)
├── patterns/                  # 반복 코드/워크플로우 패턴
├── domain/                    # 도메인 지식, 비즈니스 규칙
├── risks/                     # 알려진 리스크, 취약점
├── integrations/              # 외부 시스템 연동
└── references/                # 참조 레포, 문서 (이미 존재)
```

#### 1.2.2 memory-map.md 재설계 (키워드 인덱스)
```markdown
# Neuron Memory Map

## 검색 프로토콜
1. 키워드 매칭: 아래 인덱스에서 관련 키워드 스캔
2. 카테고리 진입: 매칭된 카테고리의 항목 목록 확인
3. 선택적 로드: 필요한 파일만 Read
4. 절대 전체 로드 금지: 카테고리 전체를 한 번에 읽지 않음

## 키워드 → 카테고리 매핑
| 키워드 | 카테고리 | 파일 |
|---|---|---|
| (작업 진행하며 축적) | | |

## 카테고리별 항목
### architecture
- (없음)
...
```

#### 1.2.3 메모리 저장 규칙
- 파일당 50줄 이내. 초과 시 분할.
- 프론트매터 필수: `title`, `keywords`, `created`, `last_used`.
- `last_used` 갱신으로 활용 빈도 추적 (감쇠는 없지만 우선순위 판단용).
- 저장 시 memory-map.md 키워드 인덱스 동시 갱신.

#### 1.2.4 실패 기억 (lessons.md 확장)
```markdown
# Lessons

## 실패한 접근법 (What Did NOT Work)
| 날짜 | 작업 | 시도한 방법 | 실패 이유 | 올바른 방법 |
|---|---|---|---|---|

## 성공 패턴 (What Worked)
| 날짜 | 작업 | 방법 | 왜 효과적이었나 |
|---|---|---|---|

## 규칙화된 교훈
(위 테이블에서 2회+ 반복 시 규칙으로 승격)
```

#### 1.2.5 생성할 파일
| 파일 | 역할 |
|---|---|
| `docs/architecture/` (dir) | 시스템 구조 메모리 |
| `docs/decisions/` (dir) | ADR 저장소 |
| `docs/patterns/` (dir) | 반복 패턴 |
| `docs/domain/` (dir) | 도메인 지식 |
| `docs/risks/` (dir) | 리스크 기록 |
| `docs/integrations/` (dir) | 외부 연동 |
| `docs/memory-map.md` (수정) | 키워드 인덱스 방식으로 재설계 |
| `tasks/lessons.md` (수정) | 실패/성공 테이블 + 규칙 승격 |

---

### 1.3 컨텍스트 효율성 기초

#### 1.3.1 스킬 레이지 로딩
현재 문제: CLAUDE.md가 모든 스킬을 나열 → 세션 시작 시 전부 컨텍스트에 로드.

해결:
- CLAUDE.md에는 **트리거 테이블(키워드→스킬명)**만 유지. 스킬 본문 미포함.
- 스킬 본문은 트리거 발동 시에만 Read로 로드.
- 로드된 스킬은 해당 작업 종료 시 컨텍스트에서 해제 (자연 압축).

```markdown
## 스킬 트리거 테이블 (본문은 발동 시 로드)
| 키워드 | 스킬 | 경로 |
|---|---|---|
| 리뷰, PR, 품질 | code-review | .claude/skills/code-review/SKILL.md |
| 테스트, TDD | testing | .claude/skills/testing/SKILL.md |
| 커밋, git | git-commit | .claude/skills/git-commit/SKILL.md |
| 진단, 헬스체크 | project-doctor | .claude/skills/project-doctor/SKILL.md |
| 설계, 브레인스토밍 | brainstorming | .claude/skills/brainstorming/SKILL.md |
| 계획, 구현 계획 | writing-plans | .claude/skills/writing-plans/SKILL.md |
| 검증, 완료 확인 | verification | .claude/skills/verification/SKILL.md |
```

#### 1.3.2 모델 라우팅 테이블
```markdown
## 모델 라우팅
| 작업 유형 | 모델 | 근거 |
|---|---|---|
| 파일 탐색, 키워드 검색, 단순 변환 | haiku | 기계적 작업, 판단 불필요 |
| 코드 작성, 버그 수정, 테스트 | sonnet | 구현력 필요, 아키텍처 판단은 불필요 |
| 아키텍처 설계, 계획, 리뷰 종합 | opus | 복합 판단 + 맥락 이해 필요 |
```

#### 1.3.3 핸드오프 문서 (컨텍스트 압축 생존)
```
tasks/handoffs/
├── {stage}-handoff.md          # 단계 간 전달 문서
```

형식:
```markdown
# Handoff: {from_stage} → {to_stage}
- **결정**: (이 단계에서 확정된 것)
- **거부된 대안**: (검토했으나 버린 것 + 이유)
- **남은 리스크**: (다음 단계가 주의할 것)
- **다음 액션**: (정확히 무엇을 해야 하는가)
- **파일 목록**: (변경/생성된 파일)
```

#### 1.3.4 세션 저장/복원 형식
```
tasks/sessions/
├── {YYYY-MM-DD}-{short-id}.md  # 세션 스냅샷
```

형식:
```markdown
# Session: {날짜} {작업 요약}
## What Worked (증거 포함)
## What Did NOT Work (이유 포함) ← 가장 중요
## Decisions Made
## Exact Next Step
## Files Modified
```

#### 1.3.5 전략적 압축 가이드라인 (CLAUDE.md에 추가)
```markdown
## 컨텍스트 관리
- 논리적 전환점에서 /compact 고려: 리서치→계획, 디버그→기능, 설계→구현.
- 압축 전 tasks/handoffs/에 핸드오프 작성.
- 컨텍스트 윈도우 마지막 20%에서 복합 작업 시작 금지.
- 서브에이전트에 세션 히스토리 전달 금지. 필요한 컨텍스트만 조립.
```

#### 1.3.6 생성할 파일
| 파일 | 역할 |
|---|---|
| `tasks/handoffs/` (dir) | 핸드오프 문서 저장소 |
| `tasks/sessions/` (dir) | 세션 스냅샷 저장소 |
| `CLAUDE.md` (수정) | 트리거 테이블, 모델 라우팅, 컨텍스트 관리 추가 |

---

## Phase 2 — 심화 (Deepening)

> 목표: 3축 각각의 **정밀도**를 높인다.

### 2.1 워크플로우 정밀화

#### 2.1.1 Deep Interview 스킬 (본격)
- 모호성 점수: 목표(40%) + 제약(30%) + 성공기준(30%).
- 한 번에 질문 1개. 가장 약한 차원 공략.
- 코드베이스 먼저 탐색 후 질문 (불필요한 질문 방지 = 토큰 절약).
- 챌린지 라운드: 4(반대론자), 6(단순화론자).
- 모호성 20% 이하에서만 다음 단계 진입.

#### 2.1.2 모호 요청 게이트
- main-orchestrator 진입 시: 파일 경로, 함수명, 번호 단계 중 1개 이상 없으면 → Deep Interview 리다이렉트.
- `force:` 접두사로 우회 가능.

#### 2.1.3 오케스트레이션 프리셋
| 프리셋 | 파이프라인 | 모델 배분 |
|---|---|---|
| feature | brainstorming → writing-plans → executor → code-review → verification | opus→opus→sonnet→sonnet→sonnet |
| bugfix | deep-interview-lite → executor → testing → verification | sonnet→sonnet→sonnet→sonnet |
| refactor | brainstorming → writing-plans → executor → code-review | opus→opus→sonnet→sonnet |
| security | code-review(security-focus) → executor → verification | opus→sonnet→sonnet |

#### 2.1.4 구조적 커밋 트레일러
git-commit 스킬에 추가:
```
Constraint: (이 변경의 제약 조건)
Rejected: (검토했으나 버린 대안)
Directive: (이 변경이 따르는 지시)
Not-tested: (테스트하지 못한 시나리오)
```

#### 2.1.5 생성/수정할 파일
| 파일 | 작업 |
|---|---|
| `.claude/skills/deep-interview/SKILL.md` | 신규 |
| `.claude/agents/main-orchestrator.md` | 모호 요청 게이트 추가 |
| `.claude/skills/git-commit/SKILL.md` | 커밋 트레일러 추가 |
| `CLAUDE.md` | 오케스트레이션 프리셋 테이블 추가 |

---

### 2.2 메모리 검색 고도화

#### 2.2.1 키워드 인덱스 자동 갱신
- 메모리 저장 시 memory-map.md 키워드 행 자동 추가.
- 키워드 추출 규칙: 파일 프론트매터 `keywords` 필드에서.
- 중복 키워드 → 같은 행에 파일 추가 (1:N 매핑).

#### 2.2.2 메모리 활용 프로토콜 (CLAUDE.md 추가)
```
1. 작업 시작 시: memory-map.md 키워드 테이블 스캔 (Read, 테이블만)
2. 관련 키워드 발견: 해당 파일만 Read
3. 관련 키워드 없음: 메모리 로드 생략 (토큰 절약)
4. 작업 완료 시: 새로 배운 것 → docs/{category}/ 에 저장 + 인덱스 갱신
```

#### 2.2.3 메모리 승격 파이프라인
```
프로젝트 로컬 (docs/{category}/)
    │
    ├─ 2회+ 동일 패턴 관찰 → 규칙화 (lessons.md)
    │
    └─ 2+프로젝트에서 confidence≥0.8 → 글로벌 승격 (~/.claude/global-memory/)
```

#### 2.2.4 레지스트리 패턴
`.claude/registry.json`:
```json
{
  "agents": [
    {"name": "main-orchestrator", "model": "opus", "role": "오케스트레이션", "path": ".claude/agents/main-orchestrator.md"},
    ...
  ],
  "skills": [
    {"name": "code-review", "triggers": ["리뷰","PR","품질"], "path": ".claude/skills/code-review/SKILL.md"},
    ...
  ],
  "memory_categories": ["architecture","decisions","patterns","domain","risks","integrations","references"]
}
```
- project-doctor가 registry vs 실제 파일 일치 검증.

#### 2.2.5 생성/수정할 파일
| 파일 | 작업 |
|---|---|
| `docs/memory-map.md` | 키워드 자동 갱신 규칙 추가 |
| `.claude/registry.json` | 신규 — 중앙 매니페스트 |
| `.claude/skills/project-doctor/SKILL.md` | 레지스트리 검증 추가 |
| `CLAUDE.md` | 메모리 활용 프로토콜 추가 |

---

### 2.3 컨텍스트 정밀 관리

#### 2.3.1 검증 루프 6단계 게이트
```
Build → Type Check → Lint → Test Suite → Security Scan → Diff Review
```
- 각 단계 PASS/FAIL 구조화 보고.
- 전체 READY/NOT READY 판정.
- 단계별 실패 시 즉시 중단 (불필요한 후속 단계 토큰 절약).

#### 2.3.2 서브에이전트 컨텍스트 격리
- 서브에이전트에 세션 히스토리 **절대 전달 금지**.
- 핸드오프 문서에서 필요 컨텍스트만 추출하여 전달.
- 서브에이전트 1개 = 작업 1개 = 최소 컨텍스트.

#### 2.3.3 비용 추적 기초
- tasks/cost-log.md: 세션별 대략적 토큰 사용량 기록.
- 형식: `| 날짜 | 작업 | 모델 | 예상 토큰 | 비고 |`
- 자동화가 아닌 수동 기록으로 시작. Phase 3에서 자동화.

#### 2.3.4 생성/수정할 파일
| 파일 | 작업 |
|---|---|
| `.claude/skills/verification/SKILL.md` | 6단계 게이트 상세화 |
| `tasks/cost-log.md` | 신규 — 비용 추적 |
| `CLAUDE.md` | 서브에이전트 격리 규칙 추가 |

---

## Phase 3 — 자동화 (Automation)

> 목표: 수동 프로세스를 **자동화**하고 확장성을 확보한다.

### 3.1 워크플로우 자동화

#### 3.1.1 SessionStart 훅
- 세션 시작 시 자동 실행:
  1. tasks/plan.md, context.md, checklist.md, lessons.md 읽기.
  2. 최근 세션 스냅샷 (tasks/sessions/) 확인.
  3. 3줄 요약 출력 → 작업 재개.
- `.claude/settings.local.json` hooks 설정으로 구현.

#### 3.1.2 Post-Done 자동 검증
- 작업 완료 표시 시 자동:
  1. change_log.md 기록 확인.
  2. 변경 파일 목록 출력.
  3. verification 스킬 트리거.

#### 3.1.3 루프 오퍼레이터 (감시)
- 자율 루프에서 정체 감지 (2체크포인트 무진전).
- 재시도 폭풍 감지 (동일 에러 3회).
- 감지 시 STOP → 사용자에게 에스컬레이션.

#### 3.1.4 생성/수정할 파일
| 파일 | 작업 |
|---|---|
| `.claude/settings.local.json` | hooks 섹션 추가 |
| `.claude/skills/session-bootstrap/SKILL.md` | 신규 — 세션 시작 자동 로드 |

---

### 3.2 메모리 자동화

#### 3.2.1 메모리 자동 수확
- 작업 완료 시 자동 판단: "이 작업에서 새로 배운 것이 있는가?"
- 있으면 → docs/{category}/ 에 저장 + memory-map.md 갱신.
- 없으면 → 생략 (불필요한 메모리 방지).

#### 3.2.2 메모리 정합성 검사 (project-doctor 확장)
- memory-map.md의 모든 파일 경로가 실제 존재하는지 검증.
- 파일당 50줄 초과 검사.
- 6개월 이상 last_used 미갱신 항목 경고.

#### 3.2.3 대규모 전환 기준
- 메모리 파일 100개+ → SQLite 인덱스 도입 검토.
- memory-map.md가 200줄 초과 → 카테고리별 서브 인덱스 분할.
- 판단 기준을 docs/memory-map.md 상단에 명시.

#### 3.2.4 생성/수정할 파일
| 파일 | 작업 |
|---|---|
| `.claude/skills/project-doctor/SKILL.md` | 메모리 정합성 검사 추가 |
| `docs/memory-map.md` | 대규모 전환 기준 명시 |

---

### 3.3 컨텍스트 자동화

#### 3.3.1 전략적 압축 자동 제안
- 도구 호출 카운터: 50회 도달 시 /compact 제안.
- 논리적 전환점 감지: 리서치→계획, 디버그→기능 전환 시 제안.
- 압축 전 핸드오프 자동 작성.

#### 3.3.2 비용 추적 자동화
- Stop 훅에서 세션별 토큰 추정치 자동 기록.
- 모델별 토큰 단가 테이블.
- 주간 요약 (project-doctor에 포함).

#### 3.3.3 품질 게이트 훅
- PostToolUse(Edit/Write) 시 자동:
  - 언어 감지 → 해당 포맷터 실행.
  - 타입 체크 (TS/Go 등).
  - console.log / print 디버그 문 경고.

#### 3.3.4 생성/수정할 파일
| 파일 | 작업 |
|---|---|
| `.claude/settings.local.json` | PostToolUse 훅 추가 |
| `tasks/cost-log.md` | 자동 기록 형식으로 전환 |

---

## Phase별 산출물 요약

| Phase | 워크플로우 | 메모리 | 컨텍스트 | 신규 파일 | 수정 파일 |
|---|---|---|---|---|---|
| **1 기반** | 파이프라인 4단계 + 에이전트 3 + 스킬 3 | 카테고리 7개 + 키워드 인덱스 + 실패 기억 | 레이지 로딩 + 모델 라우팅 + 핸드오프 + 세션 | ~10 | ~5 |
| **2 심화** | Deep Interview + 프리셋 4종 + 커밋 트레일러 | 자동 갱신 + 승격 파이프라인 + 레지스트리 | 6단계 검증 + 서브에이전트 격리 + 비용 추적 | ~5 | ~6 |
| **3 자동화** | SessionStart 훅 + Post-Done + 루프 감시 | 자동 수확 + 정합성 검사 + 대규모 전환 | 자동 압축 제안 + 비용 자동화 + 품질 훅 | ~2 | ~4 |

---

## 아키텍처 결정 (갱신)

| 결정 | 근거 | 출처 |
|---|---|---|
| 3축 중심 설계 | 워크플로우/메모리/컨텍스트가 독립 축. 한 축만 강화하면 불균형. | 사용자 피드백 |
| 규칙 = 파이프라인에 내장 | 별도 Phase로 분리하면 본체와 괴리. 각 단계에 녹여야 실효적. | Superpowers |
| 메모리 검색 = 키워드 인덱스 | 평면 목록은 검색 불가. 키워드→파일 매핑으로 0.1초 탐색. | 사용자 요구 |
| 레이지 로딩 | 모든 스킬 사전 로드 = 토큰 낭비. 트리거 시에만 본문 로드. | everything-claude-code |
| 핸드오프 문서 | 컨텍스트 압축/세션 전환에서 결정 맥락이 소실됨. 경량 문서로 보존. | OMC |
| 실패 기억 우선 | 성공보다 실패를 기억하는 것이 토큰 절약에 더 효과적. | everything-claude-code |

---

## 실행 순서

Phase 1 → 사용자 검토 → Phase 2 → 사용자 검토 → Phase 3 → 사용자 검토
각 Phase 완료 후 project-doctor로 검증.

---

## 부록: v2.1 수정 사항 (7건, 2026-03-20)

### 수정 1: plan.md compact화 (#7)
- 전체 설계 → 이 파일(docs/decisions/master-plan-v2.md)로 이동.
- tasks/plan.md는 현재 Phase + 다음 액션만. 50줄 이내.

### 수정 2: Deep Interview Lite 정의 (#2)
- **Lite (Phase 1)**: 모호하면 명확화 질문 1~2개. 스코어링 없음.
- **본격 (Phase 2)**: 모호성 점수(목표40%+제약30%+성공기준30%), 챌린지 라운드.

### 수정 3: executor/orchestrator 분기 기준 (#3)
- 단순(1~2단계): orchestrator 직접 실행. 서브에이전트 호출 오버헤드 회피.
- 복합(3단계+): executor-agent 위임. 파이프라인 적용.
- 모호하면 복합으로 (과소평가보다 과대평가가 안전).

### 수정 4: 메모리 4층→3층 축소 (#4)
- `docs/` = 프로젝트 지식 (what we know)
- `tasks/lessons.md` = 행동 규칙 (what to do/not do)
- `tasks/sessions/` = 세션 복원 (ephemeral)
- ~~.claude/agent-memory/~~ → docs/에 통합. 별도 레이어 제거.

### 수정 5: registry.json 제거 (#5)
- 트리거 테이블(CLAUDE.md) + glob 검증(project-doctor)으로 충분.
- 두 곳 동기화 부담 제거.

### 수정 6: 훅 실현 가능성 검증 (#6)
- Claude Code hooks = 셸 명령 기반. 확인된 기능:
  - SessionStart: `cat` → stdout이 컨텍스트에 주입. ✅
  - PostToolUse(Edit|Write): `jq + linter`. ✅
  - PreCompact: 핸드오프 스크립트 실행. ✅
- 훅으로 "스킬 자동 Read"는 불가. CLAUDE.md 지시로 처리.

### 수정 7: CLAUDE.md v2 동기화 (#1)
- 파이프라인 다이어그램, 트리거 테이블(레이지 로딩), 모델 라우팅, 에이전트 역할 분리, 메모리 3층, 컨텍스트 관리 가이드라인 반영.

### 수정 후 아키텍처 결정 (추가)
| 결정 | 근거 | 출처 |
|---|---|---|
| orchestrator=판단+단순실행, executor=복합전담 | 단순 작업에 서브에이전트 오버헤드 회피 | 실용성 판단 |
| 메모리 3층 (docs/lessons/sessions) | 4층은 역할 모호. 3층이면 "어디에 저장?" 즉답 가능 | 검토 피드백 |
| registry 불필요 | 트리거 테이블+glob이면 충분. 소규모에서 중복 관리 부담만 | CLI-Anything는 16개 하네스용 |
| plan.md ≤ 50줄 | 507줄 plan은 자기 모순. 매 세션 재로드 비용 | 컨텍스트 효율성 원칙 |
| 훅 = cat/jq/script | Claude Code hooks의 실제 구현 확인. 셸 명령만 가능. | hooks 문서 검증 |
