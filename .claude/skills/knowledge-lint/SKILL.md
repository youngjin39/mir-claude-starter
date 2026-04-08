---
name: knowledge-lint
description: Health-check the LLM Wiki. Contradictions, stale claims, orphans, gaps.
triggers: [wiki lint, knowledge health, lint wiki, wiki check, 위키 점검]
---

# Knowledge Lint

Pattern: Karpathy LLM Wiki maintenance pass. Runs independent of code-level project-doctor.

## Scope
Only `docs/wiki/` and `docs/sources/`. Does not touch `docs/{architecture,decisions,patterns,domain,risks,integrations,references}/` — those are project-internal knowledge, not ingested sources.

## Checks
1. **Contradiction scan**: for each wiki page, grep claim-like sentences. Cross-reference pages sharing keywords (via memory-map). Report conflicting assertions.
2. **Stale detection**: `last_used` > 90 days AND no new source citing it → flag as stale candidate.
3. **Orphans**: wiki pages with zero inbound citations (no other page links to them, no source in index.md lists them in "pages touched") → flag.
4. **Gaps**: source index.md entries whose "pages touched" column is empty → ingest was incomplete.
5. **Size violations**: any wiki page > 50 lines → must split.
6. **Broken citations**: `[→ sources/{slug}]` pointing to non-existent file in `docs/sources/`.
7. **Frontmatter audit**: missing title/keywords/related/created/last_used.

## Procedure
- Produce a report table, do NOT auto-fix. User decides each action.
- Report format:
  ```
  | Severity | Check | File | Detail | Suggested Action |
  ```
- Severity: HIGH (contradictions, broken citations) / MED (orphans, gaps, size) / LOW (stale, frontmatter).

## Hard rules
- Never edit wiki pages during a lint pass. Read-only.
- Never auto-resolve contradictions. User judgment required.
- Never delete "stale" pages — stale is a flag, not a verdict.

## Output
Summary line: `WIKI-LINT: {HIGH} high / {MED} med / {LOW} low across {N} pages, {M} sources`.
Then the full table.
