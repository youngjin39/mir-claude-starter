---
name: git-commit
description: "Git 커밋 규칙 + 구조적 트레일러. 트리거: 커밋, commit, git, 변경 저장."
---

# Git Commit

## 형식
```
type(scope): summary

body (optional)

Constraint: (이 변경의 제약 조건)
Rejected: (검토했으나 버린 대안 + 이유)
Directive: (이 변경이 따르는 지시/요구사항)
Not-tested: (테스트하지 못한 시나리오)
```

## 타입
type: feat|fix|refactor|docs|test|chore|style|perf
summary: 영어, 현재형, 50자 이내, 소문자 시작.

## 트레일러 규칙
- **Constraint**: 항상 포함. 없으면 `none`.
- **Rejected**: brainstorming에서 버린 대안이 있을 때. 없으면 생략.
- **Directive**: 사용자 지시 또는 요구사항 번호. 없으면 생략.
- **Not-tested**: 테스트 커버리지 밖 시나리오. 없으면 `none`.

## 절차
1. git status.
2. 논리적 단위 스테이징 (관련 변경만 묶기).
3. 메시지 + 트레일러 작성.
4. 커밋 전 확인:
   - .env, 시크릿, 빌드 산출물 포함 여부.
   - 디버그 코드 (console.log, print) 포함 여부.
5. 커밋.

## 예시
```
feat(auth): add JWT refresh token rotation

Implement automatic token refresh when access token
expires within 5 minutes of request.

Constraint: must be backward-compatible with existing sessions
Rejected: cookie-based refresh — XSS risk in current SPA architecture
Directive: USER-REQ-042
Not-tested: concurrent refresh from multiple tabs
```
