---
name: knowledge-ingest
description: Ingest external source into LLM Wiki. Raw → wiki pages + log.
triggers: [ingest, add source, new article, import, read and file, 소스 투입, 자료 추가]
---

# Knowledge Ingest

Pattern: Karpathy LLM Wiki (raw sources → curated wiki pages).

## When to fire
- User drops a URL, PDF, article, paper, or pastes a block of text for archiving
- User says "add this to the wiki" / "ingest this"
- After a Query produces a result worth filing back

## Hard prerequisites
- `docs/sources/` exists (raw archive, immutable)
- `docs/wiki/` exists (LLM-maintained pages, 50-line cap per file)
- `docs/sources/index.md` and `docs/sources/log.md` exist

## Procedure
1. **Store raw**: save the source under `docs/sources/{YYYY-MM-DD-slug}.{ext}`. Never edit after this point.
2. **Read + extract**: identify 3~7 key claims, entities, and cross-references.
3. **Scan wiki**: via `docs/memory-map.md` keyword table, find related pages (target 10~15 candidates, inspect ≥5).
4. **Update cascade**: for each affected wiki page, add a bullet with inline citation `[→ sources/{slug}]`. Flag contradictions explicitly in a `## Conflicts` section — do not silently overwrite.
5. **Create new pages** only if no existing page fits. Frontmatter required (title, keywords, related, created, last_used).
6. **Append to `docs/sources/index.md`**: `| date | slug | 1-line summary | pages touched |`.
7. **Append to `docs/sources/log.md`**: parseable prefix `INGEST {YYYY-MM-DD} {slug} → [pages]`.
8. **Update `docs/memory-map.md`** keyword table for any new wiki pages.

## Hard rules
- Never edit files in `docs/sources/` after step 1. Immutability is the contract.
- Never let a wiki page exceed 50 lines. Split instead.
- Never create a wiki page without at least one source citation.
- If step 3 finds zero related pages AND the topic is niche → ask user before creating an orphan page.
- Contradictions with existing wiki content: flag, do not resolve autonomously. User decides.

## Output
One-line report: `INGESTED {slug} → updated N pages, created M pages, flagged K conflicts`.
