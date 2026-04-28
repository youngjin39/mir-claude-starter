---
title: Common AI Rules
keywords: [common-ai, general-rules, context, closeout, failure-memory]
related: [../patterns/ai-ready-development.md, ../operations/hook-contract.md]
created: 2026-04-28
last_used: 2026-04-28
type: guide
---

# Common AI Rules

## Purpose
- Keep cross-cutting AI behavior short, explicit, and reusable.
- Separate always-on root contract text from longer operating guidance.

## Core Rules
- The human decides; the AI executes, verifies, and reports.
- Reuse known context before asking for repetition.
- Ground claims in files, tools, or explicit user instructions instead of guesswork.
- Preserve user meaning during rewrites unless summarization or deletion is requested explicitly.
- Keep one session focused on one main goal whenever practical.
- If a session grows noisy or changes topic, summarize and split.

## Persistent Context
- Treat startup files, project docs, and approved lessons as reusable context, not as one-off chat text.
- Do not ask the human to restate durable preferences, workflow rules, or known project facts when they already exist in repository guidance.

## Precise Prompting
- State scope, output shape, exclusions, and completion proof before broad execution when the task is non-trivial.
- Prefer grounded instructions over vague requests that force the agent to guess intent or acceptable tradeoffs.

## Output Policy
- Default to concise output.
- Show the useful result before extended commentary.
- Separate result, risk, and next action when the task is substantial or review-oriented.

## Failure Memory
- Record repeated mistakes and successful corrections in `tasks/lessons.md`.
- Promote a repeated pattern into stronger guidance only after evidence, not after one irritation.
- For this starter, durable failure memory belongs in `tasks/lessons.md`, not in a second shared control plane.

## Closeout
At task end, preserve:
1. Completed work
2. New durable rules
3. Failed approaches worth remembering
4. Next-step context for resume or handoff

## Boundary
- Do not duplicate hook parsing or verifier-owned wording here.
- Put always-on rules in `CLAUDE.md`; put repeatable procedures in skills; put detailed reference guidance in `docs/`.
- Do not create a neutral shared control document that Claude and Codex must discover separately.
