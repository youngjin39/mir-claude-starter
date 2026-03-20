#!/bin/bash
# PreCompact hook: remind to create handoff before compaction
# stdout → Claude's context window

echo "[PreCompact] Context compaction is about to begin."
echo "Ensure you have written a handoff document in tasks/handoffs/."
echo "Format: decisions / rejected alternatives / remaining risks / next actions / file list"
