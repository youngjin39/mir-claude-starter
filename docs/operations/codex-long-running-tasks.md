---
title: Codex Long-Running Tasks
keywords: [codex, runner, long-running, background, resume, handoff, compact]
related: [operations/codex-runtime.md, operations/hook-contract.md, operations/harness-application.md]
created: 2026-04-28
last_used: 2026-04-28
type: guide
---

# Codex Long-Running Tasks

## Purpose
- Give Codex a durable recovery path for long-running or background work.
- Make compact/handoff/session resume depend on external evidence rather than chat memory.
- Keep the core contract portable across repositories while letting each project choose its own commands and runtime wrappers.

## When To Use
- A command may run longer than one turn.
- The work must survive compact, handoff, or model restarts.
- Output silence is not enough to decide whether the task is done.
- The agent needs to monitor progress from the outside.

## Canonical State
Create one ledger per active job at `tasks/runner/<task-id>.md`.

Use this schema:

| Field | Meaning |
|---|---|
| `cwd` | working directory used for launch |
| `command` | exact command line that was launched |
| `env` | relevant environment variables or env file |
| `session` | terminal/session name if one exists |
| `pid` | process id or supervisor id |
| `stdout` | path to the primary log file |
| `artifacts` | output files or directories expected to change |
| `heartbeat` | optional heartbeat file or marker path |
| `stage` | current checkpoint in plain language |
| `status` | `starting`, `running`, `waiting`, `done`, `failed`, or `unknown` |
| `started_at` | launch time |
| `last_checked_at` | latest external verification time |
| `resume_command` | attach/check command for the next session |
| `done_evidence` | exact condition that proves completion |

## Monitoring Rules
1. Silence is not completion. Never infer `done` from a quiet terminal alone.
2. Verify process liveness directly with system state such as `ps`, `pgrep`, or the owning session tool.
3. Verify forward motion separately through at least one of:
   - log file growth,
   - artifact timestamp/count growth,
   - heartbeat freshness,
   - explicit stage change emitted by the task.
4. Before any summary, handoff, compact, or resume decision, refresh the ledger with the latest observed evidence.

## Launch Protocol
1. Choose a stable `task-id`.
2. Decide log path and artifact path before launch.
3. Launch the command using the project's normal runtime wrapper.
4. Immediately write the ledger with `cwd`, `command`, `env`, `session`, `pid`, `stdout`, `artifacts`, `stage=launching`, and `status=starting`.
5. Perform the first health check and update `stage` only after evidence exists.

## Resume Protocol
1. Read `tasks/runner/*.md` before launching anything new.
2. If the ledger says the job is still active, reconnect using `resume_command` or inspect the tracked `pid`/`session`.
3. If the job is inactive, record the failure evidence first.
4. Relaunch only when the old job is confirmed dead or the user explicitly wants a replacement run.

## Compact / Handoff / Session Rules
- Before compaction, refresh every active runner ledger first.
- Handoffs must include the ledger path, current `stage`, latest `last_checked_at`, and the next check command.
- Session snapshots must mention any active runner ledger and whether the job is still alive.
- Restarting without checking the existing ledger is a continuity failure.

## Portability Rule
- The core contract standardizes the ledger shape and monitoring behavior, not the process manager.
- Repositories may use plain shell, tmux, build harnesses, or app-specific runners.
- Cross-project reuse depends on keeping `tasks/runner/` and the `runner` skill available in the starter-derived Codex pack.
