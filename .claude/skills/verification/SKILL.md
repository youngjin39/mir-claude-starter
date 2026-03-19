---
name: verification
description: "증거 기반 검증 + 6단계 게이트. 미검증 완료 금지.\n\n트리거: 완료 확인, 검증, 증명, 셀프체크"
---

# Verification

## Iron Law
증명 없이 완료를 주장하는 것은 거짓말이다.

## 금지 표현
- "should work" / "아마 될 것이다"
- "probably fine" / "문제 없을 것 같다"
- "looks correct" / "맞아 보인다"
- "I believe" / "~라고 생각한다"

## 6단계 게이트
```
Build → Type Check → Lint → Test Suite → Security Scan → Diff Review
```

| 단계 | 실행 | 판정 |
|---|---|---|
| 1. Build | 빌드 명령 실행 | 성공/실패 |
| 2. Type Check | 타입 체커 실행 (해당 시) | 에러 0 |
| 3. Lint | 린터 실행 | 에러 0 (경고는 보고) |
| 4. Test Suite | 테스트 실행 | 전체 통과 |
| 5. Security Scan | 시크릿, console.log, 미사용 import 검사 | 위반 0 |
| 6. Diff Review | 변경 diff 읽고 의도와 일치 확인 | 일치 |

### 실행 규칙
- **단계별 실패 시 즉시 중단**. 후속 단계 실행 금지 (토큰 절약).
- 해당 프로젝트에 없는 단계는 SKIP 표시 (예: 타입 체커 없으면 Type Check = SKIP).
- 전체 PASS일 때만 READY 판정.

## 서킷 브레이커
- 동일 문제 수정 **3회 실패** → STOP.
- 4회째 시도 대신: 아키텍처 재검토 또는 사용자 에스컬레이션.

## 합리화 방지 테이블
| 변명 | 반박 |
|---|---|
| "테스트 통과했으니 완료" | 테스트가 올바른 것을 검증하는지 확인했는가? |
| "컴파일 되니까 된 거다" | 컴파일 ≠ 정상 동작. 런타임 검증 필요. |
| "이건 테스트하기 어렵다" | 테스트하기 어렵다면 설계가 잘못되었을 가능성. |
| "사소한 변경이라 검증 불필요" | 사소한 변경이 프로덕션을 죽이는 가장 흔한 원인. |

## 출력 형식
```
## 검증 결과: {작업 요약}

### 6단계 게이트
| 단계 | 명령어 | 결과 | 판정 |
|---|---|---|---|
| Build | {cmd} | {output} | PASS/FAIL/SKIP |
| Type Check | {cmd} | {output} | PASS/FAIL/SKIP |
| Lint | {cmd} | {output} | PASS/FAIL/SKIP |
| Test Suite | {cmd} | {output} | PASS/FAIL/SKIP |
| Security | (manual) | {findings} | PASS/FAIL |
| Diff Review | (manual) | {summary} | PASS/FAIL |

### 최종 판정: READY / NOT READY
(NOT READY 시: 실패 단계 + 원인 + 다음 액션)
```
