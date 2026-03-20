# Neuron Memory Map — Keyword Index

> Long-term memory. No decay. Load only what you need via category map.
> Keep files under 50 lines. Frontmatter: title, keywords, created, last_used.
> 100+ memory files → consider switching to SQLite. This file 200+ lines → split into per-category sub-indexes.

## Search Protocol
1. Scan the keyword table below for relevant keywords.
2. Read only the matched files.
3. If no match, skip memory load (save tokens).
4. **Never read an entire category at once.**

## Storage Protocol
1. Create new memory file: `docs/{category}/{topic}.md`
2. Frontmatter required:
   ```yaml
   ---
   title: {title}
   keywords: [keyword1, keyword2, ...]
   created: {YYYY-MM-DD}
   last_used: {YYYY-MM-DD}
   ---
   ```
3. Keep under 50 lines. Split if exceeded.
4. **Add a row to the keyword table in this file** (auto-update).
5. Duplicate keywords → add file to the same row (1:N).

## Promotion Pipeline
- Project-local (docs/) → same pattern 2+ times → promote to lessons.md rule
- Same pattern across 2+ projects → consider promoting to ~/.claude/global-memory/

## Keyword → File Mapping
| Keywords | Category | File |
|---|---|---|
| superpowers, TDD, hard-gate, iron-law | references | [Repo Analysis Summary](references/repo-analysis-summary.md) |
| cli-anything, harness, SOP, registry | references | [Repo Analysis Summary](references/repo-analysis-summary.md) |
| omc, deep-interview, risk, review-separation | references | [Repo Analysis Summary](references/repo-analysis-summary.md) |
| token-optimization, lazy-loading, session-persistence | references | [Repo Analysis Summary](references/repo-analysis-summary.md) |
| 3-axis, pipeline, master-plan | decisions | [Master Plan v2](decisions/master-plan-v2.md) |

## Items by Category

### architecture
> System structure, design patterns, dependency relationships
- (none)

### decisions
> Key decisions and their rationale (ADR style)
- [Master Plan v2](decisions/master-plan-v2.md) — Full Design Archive (3-axis, Phase 1~3)

### patterns
> Reusable code/workflow patterns
- (none)

### domain
> Domain knowledge, business rules, glossary
- (none)

### risks
> Known risks, vulnerabilities, cautions
- (none)

### integrations
> External system integration info, APIs, services
- (none)

### references
> Reference projects, documents, repo analysis results
- [4 Repo Analysis Summary](references/repo-analysis-summary.md) — Superpowers, CLI-Anything, OMC, everything-claude-code
