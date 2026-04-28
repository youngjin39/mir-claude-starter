<!-- GENERATED FILE: edit .claude/skills/runner/SKILL.md and rerun scripts/generate_codex_derivatives.sh -->
---
name: runner
description: "Long-running/background task control for Codex and Claude. Externalize task state to a durable ledger so compact, handoff, and session resume reconnect to the same work instead of relaunching it.\n\nTrigger: runner, long-running, background, monitor, resume, compact, handoff, tail, pid"
---

# Runner

## Use When
- A command may outlive the current turn.
- A task must survive compact, handoff, or session restart.
- Progress needs external proof from the system, not from chat memory.

## Required State
Create or update `tasks/runner/<task-id>.md` with:
- `cwd`
- `command`
- `env`
- `session`
- `pid`
- `stdout`
- `artifacts`
- `heartbeat` when available
- `stage`
- `status`
- `last_checked_at`
- `resume_command`
- `done_evidence`

## Monitoring Rules
1. Silence is not completion.
2. Check process liveness directly from the system.
3. Check forward motion from logs, artifacts, or heartbeat.
4. Refresh the ledger before compact, handoff, final summary, or relaunch.

## Resume Rules
- On resume, read existing `tasks/runner/*.md` first.
- Reconnect to the tracked job before starting a new one.
- Only relaunch after recording evidence that the previous job is dead or invalid.

## Handoff Rules
- Include the runner ledger path in `tasks/handoffs/`.
- Record current `stage`, last health check time, and next inspection command.

## Reference
- Read `docs/operations/codex-long-running-tasks.md` for the canonical contract and portability rules.
