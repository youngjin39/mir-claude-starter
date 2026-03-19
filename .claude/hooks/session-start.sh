#!/bin/bash
# SessionStart hook: inject plan + lessons into context
# stdout → Claude's context window

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

echo "=== SESSION CONTEXT ==="

if [ -f "$PROJECT_DIR/tasks/plan.md" ]; then
  echo "--- plan.md ---"
  cat "$PROJECT_DIR/tasks/plan.md"
fi

echo ""

if [ -f "$PROJECT_DIR/tasks/lessons.md" ]; then
  echo "--- lessons.md ---"
  cat "$PROJECT_DIR/tasks/lessons.md"
fi

echo ""

# Latest session snapshot (if exists)
LATEST_SESSION=$(ls -t "$PROJECT_DIR/tasks/sessions/"*.md 2>/dev/null | head -1)
if [ -n "$LATEST_SESSION" ]; then
  echo "--- latest session ---"
  cat "$LATEST_SESSION"
fi

echo "=== END SESSION CONTEXT ==="
