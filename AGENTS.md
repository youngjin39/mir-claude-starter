<!-- GENERATED FILE: edit CLAUDE.md and rerun scripts/generate_codex_derivatives.sh -->

# Codex Project Instructions

## Source Of Truth
- Edit `CLAUDE.md`, `.claude/agents/*`, `.claude/skills/*`.
- Do not hand-edit `AGENTS.md`, `.codex/`, or `.agents/`.

## Startup
- Read the startup context files required by the SessionStart mirror rule before acting.
- Use generated Codex skills first.
- If derived files are stale, regenerate from Claude source.

- Skills: `ai-ready-bluebricks-development, brainstorming, code-review, deep-interview, git-commit, project-doctor, runner, self-audit, testing, ux-ui-design, verification, writing-plans`

## Required Reads
1. `tasks/plan.md`
2. `tasks/lessons.md`
3. `docs/memory-map.md`
4. `docs/operations/common-ai-rules.md` when task flow changes cross-cutting AI execution policy, non-code agent behavior, or closeout rules
5. `docs/patterns/ai-ready-development.md` when the task involves code writing, code analysis, debugging, refactoring, architecture review, or PR review
6. `docs/patterns/module-blueprint-system.md` when module mapping, system boundaries, or multi-module impact matter
7. `PRD.md` when present and product scope, UX priorities, or MVP boundaries matter
8. `ARCHITECTURE.md` when wrappers, boundaries, or data flow matter
9. `ADR.md` when historical decisions or tradeoffs matter
10. `UI_GUIDE.md` when present and UI behavior, visual rules, or anti-patterns matter
11. `harness/README.md` when harness runtime commands, incidents, or commit policy matter
12. `docs/operations/codex-runtime.md` when task flow, generated instructions, or memory behavior matters
13. `docs/operations/hook-contract.md` when hook behavior, enforcement boundaries, or Codex parity matters
14. `docs/operations/harness-application.md` when applying harness techniques across Claude and Codex
15. `docs/operations/starter-maintenance-mode.md` when the task modifies starter contracts, verifiers, or cross-harness behavior
16. `docs/integrations/claude-to-codex-derivation.md` when Codex parity or regeneration matters
17. `docs/integrations/project-family-classification.md` when bootstrapping, surveying, or classifying a new project family
18. `docs/operations/codex-long-running-tasks.md` when launching, monitoring, compacting, handing off, or resuming long-running/background work


## Workflow
- 0 specificity signals → `deep-interview`
- 1~2-step task → direct execution + self-check
- 3+ step task with unresolved product/design choices → `brainstorming` → `writing-plans` → `executor-agent` → `verification`
- 3+ step task with concrete scope and no meaningful design fork → `writing-plans` → `executor-agent` → `verification`
- Multi-module codebase exploration, architecture review, dependency impact analysis, or broad refactor planning → load `ai-ready-bluebricks-development` before broad search
- Long-running/background/restartable execution → load `runner` before launch and keep `tasks/runner/` current
- `runner` is a core/default runtime skill. Do not wait for an explicit `runner` command before launching, monitoring, handing off, or resuming long-running/background/restartable work.
- UI work → `ux-ui-design` before implementation
- Review request or 4+ issues → `quality-agent`
- New-project bootstrap or repository onboarding → classify family first using `docs/integrations/project-family-classification.md`, then choose `push/init`, `migrate`, `skip-migrate + profile`, `bootstrap only + boundary`, or `supersede`


## Mode Classification
- Starter contract / verifier / generated-artifact work → enter Starter Maintenance Mode
- Claude/Codex boundary or mirroring change → enter Cross-Harness Parity Mode
- Mode rules live in `docs/operations/starter-maintenance-mode.md`
- Use the path-trigger catalog in `docs/operations/starter-maintenance-mode.md` for first-pass classification.


## Agent / Skill / Hook Contract
- Agents own execution shape:
  - `main-orchestrator` = classify, choose workflow, decide delegation.
  - `executor-agent` = execute approved multi-step plans.
  - `quality-agent` = read-only adversarial review.
- Skills own task-specific procedure:
  - Load only the matching generated skill bodies you need.
  - Prefer workflow skills in canonical order: `deep-interview` → `brainstorming` → `writing-plans` → `verification`.
  - Use `runner` for long-running/background/restartable commands. Externalize `cwd`, `command`, `env`, `session`, `pid`, `stdout`, `artifacts`, and `stage` in `tasks/runner/` before relying on memory or chat history.
  - AI-facing contract text must let the agent identify its current runtime, active mode, enforcement path, and completion gate before acting.
  - Do not force `brainstorming` for concrete, localized implementation tasks with an obvious path; reserve it for real design forks, new features, architecture changes, or when the user explicitly wants options first.
  - Use `ai-ready-bluebricks-development` for architecture review, repository exploration, multi-module refactors, PR review, dependency impact analysis, and tasks that require module-blueprint context.
  - Do not load `ai-ready-bluebricks-development` for single-file or otherwise obvious local edits unless hidden dependency risk is likely.
  - Use `writing-plans` for any multi-step execution that needs checkpointed steps, even if `brainstorming` is skipped because the design is already clear.
  - Do an inline self-review before invoking heavier review/delegation loops unless the task is high-risk, broad-scope, or the user explicitly asked for review.
  - Use `testing`, `code-review`, and `ux-ui-design` as first-class runtime skills, not as optional afterthoughts.
  - Use optional skills only when the request explicitly matches their trigger.
- Hooks describe Claude automatic behavior and the Codex mirror obligations for the same outcomes:
  - [Claude] `SessionStart` loads startup context (`tasks/plan.md`, `tasks/lessons.md`, `docs/memory-map.md`, latest session snapshot when present); treat that context as authoritative, then read more only when the task requires it. [Codex] Read the same startup files manually before acting.
  - [Claude] `PreCompact` creates a handoff skeleton before context reduction; review and complete it before compacting. This is advisory; the hook does not block compaction. [Codex] Before invoking compaction, manually create a handoff document in `tasks/handoffs/` mirroring the PreCompact contract.
  - [Claude] `PreToolUse` enforces path safety before edits/commands. [Codex] Apply the same blocked-intent rules through the instruction contract and verifier-backed drift checks.
  - [Claude] `TddGuard` enforces the test-first rule for edits to existing implementation files when related tests are detectable. [Codex] Apply the same test-first rule through the instruction contract and verifier-backed drift checks.
  - Current hook behavior blocks only when `execute.py related-tests` classifies the target as a source file and finds zero related tests.
  - [Claude] `PostToolUse` inspects edits for debug leftovers and credential leaks. [Codex] Treat the same review as mandatory manual post-edit work.
  - [Claude] `SessionEnd` saves the latest session snapshot for continuity. This preserves state, not proof of completion. [Codex] At session end, manually create a session snapshot in `tasks/sessions/` mirroring the SessionEnd contract.
- Do not duplicate hook logic in prompts or ad-hoc scripts. Instead, work with the hook contract:
  - expect guards before editing,
  - keep `tasks/plan.md` and handoffs current,
  - do not bypass denied-path or test-first expectations.
- Codex does not execute Claude hooks natively. Generated Codex artifacts must therefore mirror the same runtime contract explicitly:
  - read the same startup files, including the latest session snapshot when present,
  - before invoking compaction, manually create a handoff document in `tasks/handoffs/` mirroring the PreCompact contract,
  - classify Starter Maintenance Mode and Cross-Harness Parity Mode using the same entry criteria,
  - name the same blocked-intent set in instruction form: destructive `rm`, protected-branch force push, hook/signing bypass flags, shared-ref history rewrite, piped remote install, `sudo`, writes outside the project, writes to secret material, and writes into `.git` internals,
  - apply the same test-first rule for edits to existing implementation files when related tests are detectable,
  - the current Claude hook reaches that boundary by blocking only when `execute.py related-tests` classifies the target as a source file and finds zero related tests,
  - do not claim hook-driven incident counting for Codex-only sessions unless a Codex workflow explicitly records incidents; otherwise `harness/state/incidents.json` remains Claude-hook state rather than a Codex parity guarantee,
  - treat post-edit inspection as mandatory review work for debug leftovers and credential leaks,
  - treat hook-managed files as canonical state,
  - at session end, manually create a session snapshot in `tasks/sessions/` mirroring the SessionEnd contract,
  - use generated skills before improvising new procedure.
  - use verification commands as completion gates when hook enforcement is unavailable.
  - describe this as manual compliance + verifier-checked contract drift, not native pre-execution blocking or behavioral parity.


## Harness Defaults
- Default runtime = 3 agents + core skills + 6 hooks + `execute.py` state engine.
- Optional skills, MCP servers, and domain packs are opt-in. Do not assume they exist.
- Project-specific hard rules must live in project docs such as `PRD.md`, `ARCHITECTURE.md`, `ADR.md`, or `UI_GUIDE.md` when present, or in an explicit `CRITICAL` section here.


## Custom Harness Rules
- No additional project-specific hard rules are active unless they are documented in project docs or in an explicit `CRITICAL` section here.
- Treat project-only constraints as hard gates: required wrappers, banned libraries, DB schema freeze, API boundaries, migration rules, deployment rules.
- If requested work conflicts with a documented hard rule, stop and report the conflict instead of improvising.
- If a domain rule is missing and the work would be risky without it, ask once, then proceed only after the rule is explicit.


## Codex Derivation Layer
- `Claude` files are the source of truth.
- `AGENTS.md`, `.codex/`, and `.agents/` are generated Codex artifacts.
- Edit source first, then regenerate with `scripts/generate_codex_derivatives.sh`.


## Codex Use Boundary
- Status: `bootstrap only`, `Codex bootstrap active`, `local use boundary documented`.
- Read `docs/integrations/codex-use-boundary.md` before broad Codex edits.
- Codex is safe for source-first work in `CLAUDE.md`, `.claude/`, `scripts/`, `tests/`, `docs/`, `execute.py`, and `harness/`.
- Do not hand-edit generated `AGENTS.md`, `.codex/`, or `.agents/`; regenerate from source instead.


## Skill Trigger Table
Core default = `ai-ready-bluebricks-development`, `brainstorming`, `code-review`, `deep-interview`, `git-commit`, `project-doctor`, `runner`, `self-audit`, `testing`, `ux-ui-design`, `verification`, `writing-plans`.

| Intent | Skill | Path |
|---|---|---|
| architecture review, repository exploration, multi-module refactor, dependency impact | ai-ready-bluebricks-development | .claude/skills/ai-ready-bluebricks-development/SKILL.md |
| design, architecture, new feature | brainstorming | .claude/skills/brainstorming/SKILL.md |
| plan, step design | writing-plans | .claude/skills/writing-plans/SKILL.md |
| verify, proof, self-check | verification | .claude/skills/verification/SKILL.md |
| interview, clarify, ambiguous | deep-interview | .claude/skills/deep-interview/SKILL.md |
| commit, git, save changes | git-commit | .claude/skills/git-commit/SKILL.md |
| review, PR, quality | code-review | .claude/skills/code-review/SKILL.md |
| audit, compliance, starter check | self-audit | .claude/skills/self-audit/SKILL.md |
| runner, long-running, background, monitor, resume, compact, handoff, tail, pid | runner | .claude/skills/runner/SKILL.md |
| test, TDD, unit test | testing | .claude/skills/testing/SKILL.md |
| diagnose, doctor, health check | project-doctor | .claude/skills/project-doctor/SKILL.md |
| ui, ux, screen, frontend | ux-ui-design | .claude/skills/ux-ui-design/SKILL.md |
| ai-readiness score, repo cartography, agent-friendly audit | ai-readiness-cartography | .claude/skills/ai-readiness-cartography/SKILL.md |
| token efficiency, session cost, usage report | improve-token-efficiency | .claude/skills/improve-token-efficiency/SKILL.md |


## Context Management
- Handoffs only. Never pass session history to sub-agents.
- Before `/compact`, write a handoff in `tasks/handoffs/` and refresh any active `tasks/runner/` ledger first.
- Prefer one session per task. If the active context is approaching roughly 40%, compact before it turns into bloat.
- Split long-running work into stage-based sessions when practical instead of carrying one oversized session indefinitely.
- Compact summaries should preserve only: current goal, files already modified, failed approaches, remaining work, and non-negotiable constraints.
- Do not start complex work in the last 20% of context.


## Language Protocol
- User-facing output (reports, task logs) → Korean.
- User-facing reports: group by purpose and label each block, e.g. `Purpose / Evidence / Action`.
- User-facing progress updates must stay scannable: separate `Progress / Result / Discussion` when relevant.
- Report progress, results, and discussion points explicitly, but keep each block short. Do not dump internal reasoning logs.
- Use line breaks or bullets so the user can scan updates quickly. Avoid wall-of-text status messages.
- Internal (agent comms, handoffs, docs/, skills, code, commits) → English.
- English is ~2-3x more token-efficient for same information.


## Surgical Change Rules
- Do not touch code outside the scope of the request.
- Do not "improve" adjacent code, comments, or formatting beyond what was asked.
- Do not refactor code that isn't broken. Working code is not an invitation to rewrite.
- Dead code discovered during work: report it, do not delete unless explicitly asked.
- No error handling for scenarios that cannot happen. Trust internal code and framework guarantees. Only validate at system boundaries (user input, external APIs).
- No speculative abstractions for single-use cases. Three similar lines > a premature helper.


## Token Efficiency
- Do not re-read files already read in the current session unless the file may have changed.
- Do not restate the user's question. Execute immediately.
- When the user corrects a fact, the correction becomes session ground truth. Do not revert.


## Principles
- **Evidence first.** Default is no-action. Define success criteria first and act only on verified evidence.
- **Self-recognition first.** The AI must be able to tell which runtime it is in, which mode is active, what enforces policy, and what proves completion before it starts acting.
- **Minimum change.** Simplicity first. Solve root causes with the smallest effective change. No workarounds.
- **Goal-driven.** Optimize for the outcome, not the literal command. Give sub-agents verification targets, not step-by-step micromanagement.
- **Prohibition > instruction.** State bans before desired behavior.
- **No filler.** No flattery, hedging, repetition, or padding. Every sentence must add information.
