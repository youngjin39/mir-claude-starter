#!/bin/bash
# PostToolUse hook for Edit|Write: debug statements + credential leak detection
# Reads tool_input from stdin (JSON)

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

EXT="${FILE_PATH##*.}"
WARNINGS=""

# 1. Debug statement check
case "$EXT" in
  js|ts|jsx|tsx)
    if grep -n "console\.log" "$FILE_PATH" 2>/dev/null | head -3; then
      WARNINGS="[WARNING] console.log detected in $FILE_PATH"
    fi
    ;;
  py)
    if grep -n "^\s*print(" "$FILE_PATH" 2>/dev/null | grep -v "# keep" | head -3; then
      WARNINGS="[WARNING] print() detected in $FILE_PATH"
    fi
    ;;
esac

# 2. Credential leak check (md, json, yaml, sh, ts, js, py)
case "$EXT" in
  md|json|yaml|yml|sh|ts|js|py|env)
    CRED_HITS=$(grep -nE '(sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{36}|gho_[a-zA-Z0-9]{36}|AIza[a-zA-Z0-9_-]{35}|xoxb-[0-9]{10,}|AKIA[A-Z0-9]{16})' "$FILE_PATH" 2>/dev/null | head -3)
    if [ -n "$CRED_HITS" ]; then
      WARNINGS="${WARNINGS}
[CRITICAL] Possible credential/API key detected in $FILE_PATH — rotate immediately if real:
$CRED_HITS"
    fi
    ;;
esac

if [ -n "$WARNINGS" ]; then
  echo "$WARNINGS"
fi

exit 0
