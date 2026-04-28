---
name: ai-readiness-cartography
description: "Audit a repository against the AI-ready v2 rubric (100 points across 7 categories) and produce a structured scorecard, dashboard-ready evidence, and ROI-ranked follow-up actions.\n\nTrigger: ai-readiness score, ai-readiness map, repo cartography, agent-friendly audit, codebase readiness, LLM workflow readiness"
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash
---

# AI-Readiness Cartography

Use this skill when the user wants a repo-level AI-readiness score, a readiness map, or an audit of how well coding agents can navigate and modify the codebase.

## When to use

- "Score how AI-ready this repo is"
- "Show an agent-readiness dashboard"
- "Audit whether this codebase is ready for Claude/Codex/LLM workflows"
- "Repo cartography" or similar visualization/audit requests

## Output

Produce all three together:
1. JSON scorecard
2. Human-readable summary
3. ROI-ranked action list

Default output location priority:
- if `docs/` exists: `docs/ai-readiness-score.json`
- else if `.claude/` exists: `.claude/ai-readiness-score.json`
- else: repo root
- if the user gives a path, use that path

## Workflow

### 1. Run the scorer

```bash
python3 .claude/skills/ai-readiness-cartography/scripts/score.py <repo-path> \
  --json <output-path>/ai-readiness-score.json
```

The script is stdlib-only. It writes structured JSON and prints a readable summary to stdout.

The scorer auto-detects:
- navigation coverage
- document conciseness and cross-references
- tribal-knowledge heuristics
- dependency/data-flow signals
- reference accuracy and validation hooks
- freshness/drift indicators
- agent-outcome signals

### 2. Review manual gaps

The script is strongest on structural evidence. If needed, manually refine:
- quick commands depth
- key-file guidance depth
- non-obvious hazard quality
- critic-review quality
- prompt/eval quality

### 3. Optional dashboard build

If the user explicitly wants a visual artifact, fill [`assets/template.html`](./assets/template.html) from the JSON. Reuse the template. Do not design a new page from scratch.

Required replacements:
- repo name and metadata
- total score and grade
- 7 category bars
- strongest wins
- top ROI actions
- footer date

### 4. Optional browser open

```bash
open <output-path>/ai-readiness-map.html
```

If the user does not want the file opened, report the path only.

## Reporting

Summarize:
1. total score and grade
2. weakest 1-2 categories
3. top 3 ROI actions
4. output file paths

## Hard rules

- Use the bundled v2 rubric, not an older 10-rule variant.
- Treat hallucinated or stale paths as a top-severity finding.
- Reuse the bundled template if a dashboard is requested.
- Keep the visual style technical and restrained, not decorative.
- Quantify ROI where possible.

## Files

- [`assets/template.html`](./assets/template.html) — dashboard template
- [`references/scoring-rubric.md`](./references/scoring-rubric.md) — scoring rubric
- [`scripts/score.py`](./scripts/score.py) — stdlib scorer
