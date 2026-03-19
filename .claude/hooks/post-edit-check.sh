#!/bin/bash
# PostToolUse hook for Edit|Write: check for debug statements
# Reads tool_input from stdin (JSON)

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Get file extension
EXT="${FILE_PATH##*.}"

WARNINGS=""

# Check for debug statements by language
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

if [ -n "$WARNINGS" ]; then
  echo "$WARNINGS"
fi

exit 0
