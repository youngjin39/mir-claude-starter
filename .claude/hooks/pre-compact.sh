#!/bin/bash
# PreCompact hook: auto-save handoff + remind before compaction
# stdout → Claude's context window

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
HANDOFF_DIR="$PROJECT_DIR/tasks/handoffs"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
HANDOFF_FILE="$HANDOFF_DIR/auto-${TIMESTAMP}.md"

mkdir -p "$HANDOFF_DIR"

# Auto-generate handoff skeleton from current state
{
  echo "# Auto Handoff — $TIMESTAMP"
  echo ""
  echo "## Current State"
  if [ -f "$PROJECT_DIR/tasks/plan.md" ]; then
    echo '```'
    head -20 "$PROJECT_DIR/tasks/plan.md"
    echo '```'
  fi
  echo ""
  echo "## Recent Changes"
  if [ -d "$PROJECT_DIR/.git" ]; then
    git -C "$PROJECT_DIR" log --oneline -5 2>/dev/null | sed 's/^/- /'
  fi
  echo ""
  echo "## TODO (fill before compact)"
  echo "- Decisions:"
  echo "- Rejected alternatives:"
  echo "- Remaining risks:"
  echo "- Next actions:"
  echo "- Key files modified:"
} > "$HANDOFF_FILE" 2>/dev/null

echo "[PreCompact] Auto-handoff saved: $HANDOFF_FILE"
echo "Review and fill the TODO section before compaction proceeds."
echo "Format: decisions / rejected / risks / next actions / files"
