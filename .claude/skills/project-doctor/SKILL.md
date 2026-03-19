---
name: project-doctor
description: "Project health check + memory integrity.\n\nTrigger: diagnose, doctor, health check, status"
user-invocable: true
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob, Bash
---

# Project Doctor

## Structure Check
1. CLAUDE.md exists + ≤200 lines.
2. tasks/ required files exist (plan, context, checklist, change_log, lessons).
3. settings.local.json permissions valid.
4. Skill folders match CLAUDE.md trigger table (glob → compare).
5. Agent files exist (orchestrator, executor, quality).
6. .env in .gitignore (if applicable).

## Build/Quality Check
7. Build runnable (if applicable).
8. Lint/type check runnable (if applicable).

## Memory Integrity Check
9. docs/memory-map.md exists.
10. All file paths in memory-map.md actually exist.
11. docs/ .md files have frontmatter (title, keywords).
12. No file exceeds 50 lines.

## Context Efficiency Check
13. plan.md ≤ 50 lines.
14. CLAUDE.md has trigger table (no skill body inline).
15. tasks/handoffs/ and tasks/sessions/ directories exist.

## Output
```
## Project Doctor Report
| # | Item | Result | Note |
|---|---|---|---|
| 1 | CLAUDE.md | ✅/⚠️/❌ | {line count} |
| 2 | tasks/ files | ✅/❌ | {missing files} |
| ... | ... | ... | ... |

### Summary
- ✅: {N}
- ⚠️: {N}
- ❌: {N}

### Fix Suggestions
(Concrete fix for each ❌ and ⚠️)
```
