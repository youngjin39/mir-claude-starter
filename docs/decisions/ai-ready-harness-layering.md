---
title: AI-Ready Harness Layering — Claude/Codex Source-First Decision
keywords: [ai-ready, bluebrick, common-rules, source-first, claude, codex, derivation]
related: [../operations/common-ai-rules.md, ../patterns/ai-ready-development.md, ../patterns/module-blueprint-system.md, ../integrations/claude-to-codex-derivation.md]
created: 2026-04-29
last_used: 2026-04-29
type: decision
---

# AI-Ready Harness Layering

## Decision
Adopt a three-layer AI guidance model inside the existing starter contract:

1. Common AI rules
2. Code-development AI rules
3. Repeatable execution skills

Do this without introducing a new shared control plane outside the current Claude source-first and Codex generated structure.

## Why
- The proposal's intent was valid: separate always-on principles from code-specific constraints and from repeatable workflow.
- The repository already has a stronger contract than a neutral shared document layout: `CLAUDE.md`, `.claude/agents/*`, and `.claude/skills/*` are the source of truth.
- `AGENTS.md`, `.codex/`, and `.agents/` are generated derivatives and must stay that way.
- A separate `.ai-harness/` control plane would duplicate discovery paths and conflict with the derivation model.

## Adopted Mapping

| Need | Home | Reason |
|---|---|---|
| cross-cutting AI behavior | `docs/operations/common-ai-rules.md` | reference doc for always-applicable non-code behavior |
| code-development behavior | `docs/patterns/ai-ready-development.md` | reusable engineering pattern, not root-contract prose |
| module/system boundary lens | `docs/patterns/module-blueprint-system.md` | extends the existing blueprint storage model |
| module registry | `docs/blueprints/blueprint-index.md` | durable entrypoint for blueprint coverage |
| broad codebase workflow | `.claude/skills/ai-ready-bluebricks-development/SKILL.md` | procedural layer loaded only when needed |
| Codex parity | generated `AGENTS.md` and `.agents/skills/*` | derived from Claude source, never hand-maintained |

## Operating Rules

### Common AI Rules
- Keep root guidance short.
- Put broad non-code behavior such as persistent context, precise prompting, output policy, failure memory, and closeout in `docs/operations/common-ai-rules.md`.
- Record repeated failures in `tasks/lessons.md`, not in a second shared control plane.

### Code-Development Rules
- Treat code as part of bounded modules, not isolated text.
- Use `WHAT / HOW / HOW NOT / WHERE / WHY` to frame non-trivial work.
- Preserve hidden-hazard checks, bounded output, and scoped sub-agent use in `docs/patterns/ai-ready-development.md`.
- Keep bluebricks as a reasoning lens over the existing blueprint unit rather than a parallel storage system.

### Skill Layer
- Use `ai-ready-bluebricks-development` for repository exploration, architecture review, dependency impact analysis, PR review, and broad refactor planning.
- Do not force the skill for trivial local edits unless hidden dependency risk is likely.
- Route newly discovered knowledge to the closest blueprint or to `tasks/lessons.md` depending on whether the finding is module-specific or workflow-specific.

## Files Changed In This Rollout
- `CLAUDE.md`
- `.claude/agents/main-orchestrator.md`
- `.claude/agents/executor-agent.md`
- `.claude/agents/quality-agent.md`
- `.claude/skills/brainstorming/SKILL.md`
- `.claude/skills/writing-plans/SKILL.md`
- `.claude/skills/verification/SKILL.md`
- `.claude/skills/code-review/SKILL.md`
- `.claude/skills/ai-ready-bluebricks-development/SKILL.md`
- `docs/operations/common-ai-rules.md`
- `docs/patterns/ai-ready-development.md`
- `docs/patterns/module-blueprint-system.md`
- `docs/blueprints/blueprint-index.md`
- `scripts/generate_codex_derivatives.sh`
- `scripts/verify_codex_sync.py`
- `scripts/verify_starter_integrity.py`

## Validation
- Regenerate derived Codex artifacts after source changes:
  - `bash scripts/generate_codex_derivatives.sh`
- Verify Claude/Codex sync and starter integrity:
  - `python3 scripts/verify_codex_sync.py`
  - `python3 scripts/verify_starter_integrity.py`

## Non-Goals
- Do not create a neutral shared control document that both runtimes must discover separately.
- Do not hand-maintain `AGENTS.md`.
- Do not require the broad AI-ready workflow for every local code edit.
