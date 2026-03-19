#!/bin/bash
# PreCompact hook: remind to create handoff before compaction
# stdout → Claude's context window

echo "[PreCompact] 컨텍스트 압축 전입니다."
echo "tasks/handoffs/ 에 핸드오프 문서를 작성했는지 확인하세요."
echo "형식: 결정 / 거부된 대안 / 남은 리스크 / 다음 액션 / 파일 목록"
