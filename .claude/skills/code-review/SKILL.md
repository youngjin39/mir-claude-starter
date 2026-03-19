---
name: code-review
description: "코드 리뷰 및 품질 검사. 트리거: 코드 리뷰, 리뷰, 검토, 품질, PR, 머지 전, 작업 완료 후."
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob
---

# Code Review

## 절차
1. 변경 파일 확인 (change_log.md 또는 git diff).
2. 파일별: 에러 처리 누락, 보안 위험, 네이밍 위반, 중복, 불필요 복잡성.
3. 분류: CRITICAL / WARNING / INFO.
4. 구조화 보고.

## 체크리스트
- [ ] 에러 처리
- [ ] 보안
- [ ] 네이밍
- [ ] 중복 없음
- [ ] 과잉 설계 없음
