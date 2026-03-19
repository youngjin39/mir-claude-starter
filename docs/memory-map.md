# Neuron Memory Map — 키워드 인덱스

> 장기 메모리. 감쇠 없음. 카테고리 맵으로 필요한 것만 로드.
> 파일당 50줄 이내. 프론트매터: title, keywords, created, last_used.
> 메모리 파일 100개+ → SQLite 전환 검토. 이 파일 200줄+ → 카테고리별 서브 인덱스 분할.

## 검색 프로토콜
1. 아래 키워드 테이블에서 관련 키워드 스캔.
2. 매칭된 파일만 Read.
3. 매칭 없으면 메모리 로드 생략 (토큰 절약).
4. **절대 카테고리 전체를 한 번에 읽지 않음.**

## 저장 프로토콜
1. 새 메모리 파일 생성: `docs/{category}/{topic}.md`
2. 프론트매터 필수:
   ```yaml
   ---
   title: {제목}
   keywords: [키워드1, 키워드2, ...]
   created: {YYYY-MM-DD}
   last_used: {YYYY-MM-DD}
   ---
   ```
3. 50줄 이내. 초과 시 분할.
4. **이 파일의 키워드 테이블에 행 추가** (자동 갱신).
5. 중복 키워드 → 같은 행에 파일 추가 (1:N).

## 승격 파이프라인
- 프로젝트 로컬(docs/) → 2회+ 동일 패턴 → lessons.md 규칙화
- 2+프로젝트에서 동일 패턴 → ~/.claude/global-memory/ 승격 검토

## 키워드 → 파일 매핑
| 키워드 | 카테고리 | 파일 |
|---|---|---|
| superpowers, TDD, hard-gate, iron-law | references | [레포 분석 종합](references/repo-analysis-summary.md) |
| cli-anything, harness, SOP, registry | references | [레포 분석 종합](references/repo-analysis-summary.md) |
| omc, deep-interview, 리스크, 리뷰분리 | references | [레포 분석 종합](references/repo-analysis-summary.md) |
| 토큰최적화, 레이지로딩, 세션지속성 | references | [레포 분석 종합](references/repo-analysis-summary.md) |
| 3축, 파이프라인, 마스터플랜 | decisions | [Master Plan v2](decisions/master-plan-v2.md) |

## 카테고리별 항목

### architecture
> 시스템 구조, 설계 패턴, 의존성 관계
- (없음)

### decisions
> 주요 결정 사항과 그 근거 (ADR 스타일)
- [Master Plan v2](decisions/master-plan-v2.md) — 전체 설계 아카이브 (3축, Phase 1~3)

### patterns
> 반복 사용되는 코드/워크플로우 패턴
- (없음)

### domain
> 도메인 지식, 비즈니스 규칙, 용어집
- (없음)

### risks
> 알려진 리스크, 취약점, 주의사항
- (없음)

### integrations
> 외부 시스템 연동 정보, API, 서비스
- (없음)

### references
> 참조 프로젝트, 문서, 레포 분석 결과
- [4개 레포 분석 종합](references/repo-analysis-summary.md) — Superpowers, CLI-Anything, OMC, everything-claude-code
