#!/bin/bash
# PreToolUse hook: input-stage guardrail.
# Blocks destructive patterns + denied paths BEFORE the tool runs.
# Reads tool_input from stdin (JSON). Exit 2 = block; exit 0 = allow.

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)

block() {
  # Claude Code: stdout on exit 2 is shown to the agent as a tool error.
  echo "[PreToolUse BLOCK] $1" >&2
  exit 2
}

# --- Bash command guards ---
if [ "$TOOL_NAME" = "Bash" ]; then
  CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
  [ -z "$CMD" ] && exit 0

  # 1. rm -rf on anything remotely dangerous
  if echo "$CMD" | grep -qE 'rm[[:space:]]+(-[rRfF]+[[:space:]]+)+(/|~|\$HOME|\*|\.|\.\./)'; then
    block "Destructive rm pattern: $CMD"
  fi
  # 2. Force push to protected branches
  if echo "$CMD" | grep -qE 'git[[:space:]]+push[[:space:]]+(-f|--force)[^|]*(main|master|release)'; then
    block "Force push to protected branch: $CMD"
  fi
  # 3. Hook bypass flags
  if echo "$CMD" | grep -qE '(--no-verify|--no-gpg-sign|-c[[:space:]]+commit\.gpgsign=false)'; then
    block "Hook/signing bypass flag: $CMD"
  fi
  # 4. History rewrite on shared refs
  if echo "$CMD" | grep -qE 'git[[:space:]]+(reset[[:space:]]+--hard[[:space:]]+origin|rebase[[:space:]]+.*main|filter-branch|filter-repo)'; then
    block "History rewrite on shared refs: $CMD"
  fi
  # 5. Piped remote install
  if echo "$CMD" | grep -qE '(curl|wget)[^|]*\|[[:space:]]*(bash|sh|zsh|python)'; then
    block "Piped remote install: $CMD"
  fi
  # 6. sudo in any form
  if echo "$CMD" | grep -qE '(^|[[:space:]])sudo([[:space:]]|$)'; then
    block "sudo requires user confirmation, not this hook: $CMD"
  fi
fi

# --- Write/Edit path guards ---
if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
  FP=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)
  [ -z "$FP" ] && exit 0

  # 1. Outside project root
  case "$FP" in
    /etc/*|/System/*|/Library/*|/usr/*|/bin/*|/sbin/*|/var/*|/private/*)
      block "Write outside project root: $FP"
      ;;
  esac
  # 2. Secret/env files
  case "$(basename "$FP")" in
    .env|.env.*|credentials|credentials.*|id_rsa|id_ed25519|*.pem|*.key|*.p12)
      block "Write to secret/credential file: $FP"
      ;;
  esac
  # 3. Git internal state
  if echo "$FP" | grep -qE '(^|/)\.git/(config|hooks/|refs/|objects/)'; then
    block "Write to git internal state: $FP"
  fi
fi

exit 0
