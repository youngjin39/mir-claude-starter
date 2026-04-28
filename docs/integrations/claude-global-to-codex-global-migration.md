---
title: Claude Global To Codex Global Migration
keywords: [claude, codex, global, agents, ontology, migration, shared-rules]
related: [integrations/claude-to-codex-derivation.md, operations/codex-runtime.md, operations/user-reporting-format.md]
created: 2026-04-28
last_used: 2026-04-28
type: integration
---

# Claude Global To Codex Global Migration

## Purpose
Move the shared cross-project Claude home rules into Codex-global rules that apply automatically across the same workspace families.

## Claude Source
- Source of truth: `~/.claude/CLAUDE.md`
- This file contains:
  - active project ontology,
  - cross-project relationships,
  - shared knowledge endpoints,
  - reusable operating rules.

## Codex Target Model
Codex does not rely on a single global `~/.claude/CLAUDE.md` equivalent in the same way. The migrated structure uses two layers instead:

1. Root-scope `AGENTS.md` files for automatic inheritance:
   - `/Users/ai_agent/AGENTS.md`
   - `/Volumes/T7 Shield/Project/AGENTS.md`
2. A global reusable Codex skill for manual or explicit loading:
   - `~/.codex/skills/cross-project-ontology/SKILL.md`

## Why This Shape
- Codex reads `AGENTS.md` by directory scope, so root-level `AGENTS.md` is the practical global rule carrier.
- `~/.codex/skills/` is the practical home for reusable Codex-global skill bodies.
- This keeps cross-project ontology available both implicitly (`AGENTS.md`) and explicitly (skill load).

## Generated Outputs
The migration currently generates and refreshes these files:

- `/Users/ai_agent/AGENTS.md`
- `/Volumes/T7 Shield/Project/AGENTS.md`
- `~/.codex/skills/cross-project-ontology/SKILL.md`

## Shared Rules Carried Over
- cross-project ontology and active project map,
- prior-art lookup before rebuilding,
- shared knowledge endpoints,
- explicit-path rule,
- cross-project impact awareness,
- user-facing Korean output,
- `no bullshit, only efficiency`,
- default `Progress / Result / Discussion` reporting shape.

## Sync Script
- Generator: `/Users/ai_agent/bin/sync-codex-global-rules.py`
- Safe invocation:

```bash
python3 /Users/ai_agent/bin/sync-codex-global-rules.py
```

## Notes
- In this environment, direct execution of the script path may return `permission denied`; `python3 ...` is the reliable entrypoint.
- Repository-local `AGENTS.md` files still override the root-level global files when scopes overlap.
- This is a global-rule migration, not a replacement for project-local source-first derivation inside each repository.

## Update Protocol
1. Edit `~/.claude/CLAUDE.md`.
2. Run `python3 /Users/ai_agent/bin/sync-codex-global-rules.py`.
3. Verify the regenerated root `AGENTS.md` files and the global Codex skill.

## Non-Goals
- No attempt to make Codex use Claude home files natively.
- No direct hand-maintenance of the generated global Codex files.
- No replacement of repository-local `CLAUDE.md -> AGENTS.md` derivation.
