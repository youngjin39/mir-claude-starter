#!/bin/bash
# PreCompact hook: auto-save handoff + remind before compaction
# stdout → Claude's context window

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
HANDOFF_DIR="$PROJECT_DIR/tasks/handoffs"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
HANDOFF_FILE="$HANDOFF_DIR/auto-${TIMESTAMP}.md"

mkdir -p "$HANDOFF_DIR" || { echo "[PreCompact] ERROR: Cannot create $HANDOFF_DIR"; exit 0; }

# Auto-generate handoff skeleton from current state
{
  echo "# Auto Handoff — $TIMESTAMP"
  echo ""
  echo "## Compact Rule"
  echo "- One session should stay focused on one task."
  echo '- Prefer `/compact` before the active context grows beyond roughly 40%.'
  echo "- Split long-running work into stage-based sessions when practical."
  echo ""
  echo "## Summary Guide"
  echo "When summarizing, preserve only:"
  echo "1. Current goal"
  echo "2. Files already modified"
  echo "3. Failed approaches"
  echo "4. Remaining work"
  echo "5. Non-negotiable constraints"
  echo ""
  echo "## Current Goal"
  if [ -f "$PROJECT_DIR/tasks/plan.md" ]; then
    echo '```'
    head -20 "$PROJECT_DIR/tasks/plan.md"
    echo '```'
  fi
  echo ""
  echo "## Files Already Modified"
  if [ -d "$PROJECT_DIR/.git" ]; then
    git -C "$PROJECT_DIR" status --short 2>/dev/null | sed 's/^/- /'
  fi
  echo ""
  echo "## Failed Approaches"
  echo "- "
  echo ""
  echo "## Remaining Work"
  echo "- "
  echo ""
  echo "## Non-Negotiable Constraints"
  echo "- "
  echo ""
  echo "## Runner Ledger"
  echo '- Refresh active `tasks/runner/` ledgers before compact if long-running/background work exists.'
} > "$HANDOFF_FILE"

if [ -f "$HANDOFF_FILE" ]; then
  echo "[PreCompact] Auto-handoff saved: $HANDOFF_FILE"
else
  echo "[PreCompact] ERROR: Failed to write handoff file."
fi
echo "Review and fill the compact summary sections before compaction proceeds."
