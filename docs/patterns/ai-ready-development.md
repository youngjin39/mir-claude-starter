---
title: AI-Ready Development
keywords: [ai-ready, development, blueprint, hazards, validation, scope]
related: [module-blueprint-system.md, ../operations/common-ai-rules.md]
created: 2026-04-28
last_used: 2026-04-28
type: pattern
---

# AI-Ready Development

## Core Rule
Treat code as part of a bounded module and system flow, not as isolated text.

## Apply This Pattern For
- code writing
- code analysis
- debugging
- refactoring
- architecture review
- PR review
- dependency impact analysis

## Before Broad Exploration
Identify:
1. Exact task boundary
2. Relevant module or blueprint
3. Files likely in scope
4. Files that must stay untouched
5. Narrowest meaningful validation path

## AI-Ready Questions
For each affected module or blueprint, answer:

### WHAT
What does it do?

### HOW
How are normal changes made safely?

### HOW NOT
What non-obvious actions break compatibility, runtime behavior, migrations, or downstream consumers?

### WHERE
What upstream and downstream dependencies matter?

### WHY
What tacit knowledge is missing from the code itself?

## Hidden Hazard Checklist
- legacy compatibility
- merged migration constraints
- generated files
- public API stability
- cross-repository dependency
- business rules tied to past incidents

## Context and Cost Discipline
- Reuse startup context, blueprint docs, and prior focused reads before re-reading files.
- Keep one session pointed at one implementation goal; summarize and split when the task changes.
- Use `ai-ready-bluebricks-development` for repository exploration, architecture review, dependency impact analysis, PR review, and other tasks where module context matters before acting.
- Keep clearly local edits on the lighter default path unless hidden dependency risk is likely.

## Sub-agent Policy
Use deeper delegation or isolated review context for:
- broad codebase search
- multi-module dependency analysis
- PR review
- security or performance investigation
- competing architecture options

Keep work inline for:
- reading one known file
- single grep
- small local edits
- small diff review

## Command Output Policy
- Prefer bounded output such as `head`, `tail`, focused `git diff`, `rg ... | head`, or `wc -l`.
- Avoid unbounded log dumps or full-repository diffs unless the human explicitly asks for them.

## Scope Rules
- Prefer the smallest correct change.
- Preserve architecture boundaries unless the task is explicitly architectural.
- Do not edit unrelated files or formatting.
- If you discover a recurring hidden rule, propose a durable home for it in blueprint docs or `tasks/lessons.md`.
