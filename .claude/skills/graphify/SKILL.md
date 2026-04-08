---
name: graphify
description: Automated knowledge graph for large codebases + doc corpora. 71.5x fewer tokens per query via graph-first navigation instead of raw file grep. Complements, does not replace, knowledge-wiki.
triggers: [graphify, knowledge graph, large codebase search, god nodes, graph report, 지식 그래프, 대형 코드베이스 탐색]
---

# Graphify

External tool: https://github.com/safishamsi/graphify (MIT). Built independently after Karpathy's LLM Wiki post, same lineage as our `knowledge-wiki` module but different philosophy: **automated extraction, graph-first navigation**.

## When to fire
- Repo has 500+ files OR a corpus of papers/PDFs/images you need to query
- `grep`/`Glob` over raw files would burn too many tokens
- User asks "what's in this codebase", "find everything related to X", "summarize the architecture"
- `GRAPH_REPORT.md` or `graph.json` already exists at repo root → prefer graph navigation

## Skip when
- Repo has <50 files (overhead not worth it)
- Pure Flutter mobile app / single-purpose small project
- Hermes early-install / setup phases with no corpus to index

## Prerequisites
- Graphify installed: `pip install graphifyy && graphify install` (package name is **graphifyy** — two y's, not graphify)
- `/graphify` command available in Claude Code
- Python 3.10+

## Procedure

### First-time indexing
```bash
graphify            # builds graph.json + GRAPH_REPORT.md + cache/
graphify --wiki     # also generates Wikipedia-style index.md + community pages
```
Output files (repo root):
- `graph.json` — persistent queryable graph
- `GRAPH_REPORT.md` — god nodes + communities + connections summary
- `graph.html` — interactive visual
- `cache/` — SHA256 incremental cache
- `index.md` (with `--wiki`) — entry point for generated wiki

### Querying (via /graphify command)
Use the `/graphify` slash command. It redirects Claude to read `GRAPH_REPORT.md` + `graph.json` before touching raw files.

### Re-indexing triggers
- After a major refactor / large merge
- When `GRAPH_REPORT.md` timestamp > 7 days for actively developed repos
- When querying returns stale god nodes (symbol now removed/renamed)

## Integration with harness

### PreToolUse hook coexistence
Graphify installs its own PreToolUse hook in `~/.claude/settings.json` (global) that intercepts Glob/Grep and surfaces: *"graphify: Knowledge graph exists. Read GRAPH_REPORT.md first."* Our project-level `.claude/settings.local.json` PreToolUse (pre-tool-use.sh) runs alongside — both fire. No conflict; they serve different purposes (Graphify=routing hint, ours=safety guardrail).

### Relationship to knowledge-wiki skill
- **Graphify** = automated read-optimization layer. Machine-generated graph + wiki pages. Frequently refreshed.
- **knowledge-wiki** = human-curated knowledge layer under `docs/wiki/`. Contradiction-linted. Rarely refreshed, high signal.

**Boundary rule**: Graphify's auto-generated `index.md` and community pages live at **repo root** (where Graphify writes them) and are treated as **raw sources**. Do NOT write them directly into `docs/wiki/`. If a Graphify page contains insight worth preserving long-term → run `knowledge-ingest` on it → that moves the curated distillation into `docs/wiki/` with citation back to Graphify.

### When both are active
1. Agent receives query
2. Graphify's hook fires → agent reads `GRAPH_REPORT.md` first
3. Agent identifies god nodes / relevant communities
4. Agent reads targeted raw files (not full grep)
5. If the finding is worth curating → `knowledge-ingest` → `docs/wiki/`
6. `knowledge-lint` runs periodically on `docs/wiki/` (Graphify output not linted — it's machine-generated and self-refreshes)

## Hard rules
- **Never** edit Graphify output files (`graph.json`, `GRAPH_REPORT.md`, `graph.html`, auto `index.md`). They are rebuilt by `graphify`; edits will be lost and may corrupt the cache.
- **Never** mix Graphify's auto-wiki pages into `docs/wiki/` directly. Curate via `knowledge-ingest` first.
- **Never** trust stale graphs. If `GRAPH_REPORT.md` is older than the most recent major commit touching core modules → re-run `graphify`.
- If `/graphify` is not installed and the user asks for it → hand back the install command, do not attempt auto-install (pip global install is user-terminal work).
- Do not commit `cache/` — add to `.gitignore`. Other Graphify outputs (`graph.json`, `GRAPH_REPORT.md`) may be committed if team wants shared graph state.

## Output format
When querying via Graphify:
```
GRAPHIFY: read GRAPH_REPORT.md → god_nodes=[A, B, C] → targeted_reads=[file1:range, file2:range]
Answer: {your synthesis with inline citations}
```
