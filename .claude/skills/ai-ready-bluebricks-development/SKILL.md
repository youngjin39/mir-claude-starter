---
name: ai-ready-bluebricks-development
description: "AI-ready codebase workflow for architecture review, repository exploration, multi-module refactoring, dependency impact analysis, and PR review. Apply module blueprints plus WHAT/HOW/HOW NOT/WHERE/WHY before broad code changes.\n\nTrigger: architecture review, repository exploration, multi-module refactor, dependency impact, blueprint, bluebrick"
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash
---

# AI-Ready Bluebricks Development

Use this skill when the task is broader than a local edit and the agent needs module-level context before acting.

## Do Not Use For
- reading one known file
- one grep and a trivial answer
- a clearly local single-file fix with no meaningful dependency risk

## Phase 1: Set the Boundary
Identify:
1. Exact task
2. Relevant module or blueprint
3. Files likely in scope
4. Files that must stay untouched
5. Smallest validation path

## Phase 2: Load the Right Context
Read:
- `docs/patterns/ai-ready-development.md`
- `docs/patterns/module-blueprint-system.md`
- `docs/blueprints/blueprint-index.md` when blueprint coverage exists for this repository
- any blueprint or architecture file directly related to the target module

Do not start with a broad dump of the repository.

## Phase 3: Ask the AI-Ready Questions
For each affected unit, answer:
- WHAT
- HOW
- HOW NOT
- WHERE
- WHY

If any answer is missing, either find the evidence or report the gap before editing.

## Phase 4: Apply the Bluebrick Lens
Treat the affected unit as a bounded design block.
Check:
1. Purpose
2. Public interface
3. Internal rules
4. Non-obvious hazards
5. Dependencies
6. Downstream users
7. Composition
8. Orchestration
9. Validation

## Phase 5: Execute Safely
- Prefer the smallest correct change.
- Preserve module boundaries unless architecture change is the task.
- Do not delete legacy-looking code without dependency evidence.
- Do not silently expand scope.

## Phase 6: Close the Loop
After changes:
1. Run the narrowest meaningful validation.
2. Summarize risks and assumptions.
3. Route new knowledge deliberately:
   - If the finding is a reusable module rule, update the closest blueprint.
   - If the finding is a repeated agent mistake or workflow correction, update `tasks/lessons.md`.
   - Do not invent a parallel `.ai-harness/` memory path for this starter.

## Output
Report:
1. Boundary
2. Blueprint or bluebrick context used
3. Change summary
4. Validation
5. Hidden-rule updates, if any
