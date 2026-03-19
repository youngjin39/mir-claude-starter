---
name: project-doctor
description: "프로젝트 상태 진단 + 메모리 정합성. 트리거: 진단, doctor, 상태 확인, 헬스체크, 점검."
user-invocable: true
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob, Bash
---

# Project Doctor

## 구조 진단
1. CLAUDE.md 존재 + 200줄 이하.
2. tasks/ 필수 파일 존재 (plan, context, checklist, change_log, lessons).
3. settings.local.json 권한 정상.
4. 스킬 폴더와 CLAUDE.md 트리거 테이블 일치 (glob → 비교).
5. 에이전트 파일 존재 (orchestrator, executor, quality).
6. .env가 .gitignore에 포함 (해당 시).

## 빌드/품질 진단
7. 빌드 실행 가능 (해당 시).
8. 린트/타입 체크 실행 가능 (해당 시).

## 메모리 정합성 진단
9. docs/memory-map.md 존재.
10. memory-map.md의 모든 파일 경로가 실제 존재하는지 검증.
11. docs/ 내 .md 파일에 프론트매터(title, keywords) 존재 확인.
12. 파일당 50줄 초과 검사.

## 컨텍스트 효율성 진단
13. plan.md 50줄 이내.
14. CLAUDE.md에 트리거 테이블 존재 (스킬 본문 직접 포함 금지).
15. tasks/handoffs/, tasks/sessions/ 디렉토리 존재.

## 출력
```
## Project Doctor Report
| # | 항목 | 결과 | 비고 |
|---|---|---|---|
| 1 | CLAUDE.md | ✅/⚠️/❌ | {줄수} |
| 2 | tasks/ 필수 파일 | ✅/❌ | {누락 파일} |
| ... | ... | ... | ... |

### 요약
- ✅: {N}건
- ⚠️: {N}건
- ❌: {N}건

### 수정 제안
(❌, ⚠️ 항목에 대한 구체적 수정 방법)
```
