---
title: Optimization Log — Integrity Audit History
keywords: [audit, optimization, refactoring, stabilization, integrity]
created: 2026-03-24
last_used: 2026-03-24
type: archive
---

# Optimization Log

Full history of integrity audits and refactoring performed on the harness.

## Audit Methodology

6-dimension quality audit using quality-agent (sonnet, fork context, read-only):

| Dimension | Focus |
|---|---|
| Consistency (정합성) | Cross-references between all files match exactly |
| Conflicts (충돌) | No contradictions between files |
| Duplication (중복) | No redundant content across files |
| Optimization (최적화) | Simplification opportunities |
| Reorganization (재배치) | Content in the right place |
| Functional verification (기능재검증) | Scripts, triggers, paths all valid |

## Phase 1: Initial Stabilization (2026-03-24, Rounds 1–9)

Commit: `7260cf2` — "refactor: stabilize harness with 9-round integrity audit (60+ fixes)"

### Key Fixes
- Credential regex `sk-[a-zA-Z0-9]{20,}` → `sk-[a-zA-Z0-9_-]{20,}` (match sk-proj-*/sk-ant-*)
- `\s` in BSD grep ERE → `[[:space:]]` (POSIX compatible)
- grep output in `if` leaked to stdout → captured in variable
- pre-compact.sh `2>/dev/null` suppressed write errors → explicit file check
- session-start.sh zsh glob expansion → `find` command
- CLAUDE.md skill count 7→8, refactor preset +verification
- "verify" keyword conflict between testing/verification → removed from testing
- Language protocol contradictions → unified (user→KR, internal→EN)
- quality-agent.md `context: fork` moved inside YAML frontmatter
- 14 redundant Bash permissions removed from settings.local.json

## Phase 2: Deployment Stabilization (2026-03-24, Rounds 10–19)

Commits: `d375b6f`, `4369ab3`, `f24e80d`, `f847378`

### Key Fixes
- setup.sh `sed -i ''` (macOS-only) → `perl -pi -e` (cross-platform)
- setup.sh clone failure silently suppressed → error handler with exit 1
- setup.sh no guard for existing .claude/ → existence check added
- docs/ empty subdirs not git-tracked → .gitkeep files added
- cost-log.md added to CLAUDE.md project structure tree
- README Quick Setup curl one-liner added
- Agent section ordering in orchestrator.md

## Phase 3: Final Consistency Audit (2026-03-24, Rounds 20–24)

Commit: `cce8fe4` — "fix: 5-round integrity audit — 30 fixes for cross-file consistency"

### Round 20 (8 issues: 1 CRITICAL, 4 WARNING, 3 INFO)
| # | Severity | Fix |
|---|---|---|
| 1 | CRITICAL | post-edit-check.sh: `.tool_input.file_path` → `.file_path // .path` fallback (Edit tool field mismatch caused silent credential check skip) |
| 2 | WARNING | CLAUDE.md structure tree: added `.claude/hooks/` directory |
| 3 | WARNING | Orchestration Presets: deduplicated (orchestrator.md → "See CLAUDE.md") |
| 4 | WARNING | master-plan-v2.md refactor preset: added missing `→ verification` |
| 5 | WARNING | memory-map.md: added `harness`, `everything-claude-code` keywords |
| 6 | INFO | CLAUDE.md structure tree: added root files (setup.sh, README.md, LICENSE) |

### Round 21 (7 issues: 3 WARNING, 4 INFO)
| # | Severity | Fix |
|---|---|---|
| 1 | WARNING | README trigger keywords synced with CLAUDE.md (all 8 skills, all keywords) |
| 2 | WARNING | README post-edit-check description: added credential leak detection |
| 3 | WARNING | project-doctor check #18: skip skills with `—` (never used) |
| 4 | INFO | README structure tree: added root files |
| 5 | INFO | Stale auto-handoff files removed |

### Round 22 (6 issues: 3 WARNING, 3 INFO)
| # | Severity | Fix |
|---|---|---|
| 1 | WARNING | README remaining trigger keywords fully synced |
| 2 | WARNING | README Manual Setup: added tasks/ subdirectories |
| 3 | WARNING | jq documented as prerequisite in README |

### Round 23 (5 issues: 2 WARNING, 3 INFO)
| # | Severity | Fix |
|---|---|---|
| 1 | WARNING | README Manual Setup: added context.md to file list |
| 2 | WARNING | CLAUDE.md: unified "plans" → "writing-plans" in presets + gate conditions |
| 3 | INFO | memory-map.md: added `context` keyword for master-plan-v2.md |
| 4 | INFO | repo-analysis-summary.md: added `hard-gate` to frontmatter keywords |

### Round 24 (4 issues: 3 WARNING, 1 INFO)
| # | Severity | Fix |
|---|---|---|
| 1-3 | WARNING | Final "plans" → "writing-plans" in README + setup.sh output |

## Summary Statistics

| Metric | Value |
|---|---|
| Total audit rounds | 24 |
| Total fixes applied | 100+ |
| CRITICAL issues found | 2 |
| Final state | CRITICAL 0, all cross-references synchronized |
| Files modified in final phase | 9 |

## Recurring Patterns

| Pattern | Occurrences | Root Cause |
|---|---|---|
| README ↔ CLAUDE.md desync | 5+ | README is a secondary copy; changes to CLAUDE.md don't auto-propagate |
| Skill name abbreviation ("plans" vs "writing-plans") | 4 | Informal shortening in prose vs formal skill name |
| memory-map.md ↔ file frontmatter keyword mismatch | 3 | Manual index without automated sync |

## Lessons Learned

1. **Single source of truth works**: Deduplicating orchestration presets (orchestrator → "See CLAUDE.md") eliminated a recurring sync issue.
2. **README is the most drift-prone file**: Consider it a derived artifact that must be re-checked after every CLAUDE.md change.
3. **Hook field names matter**: The Edit vs Write tool payload difference (`path` vs `file_path`) is a subtle but critical distinction.
4. **Keyword indexes need bidirectional sync**: memory-map.md → file and file → memory-map.md must both be checked.
