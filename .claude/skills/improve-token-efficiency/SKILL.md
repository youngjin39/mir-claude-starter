---
name: improve-token-efficiency
description: "Analyze Claude Code session JSONL logs for a repository, score token and context efficiency, estimate cost drivers, and produce a dashboard-ready report with concrete savings opportunities.\n\nTrigger: token efficiency, session efficiency, Claude usage report, session cost, analyze token efficiency, cost analysis"
user-invocable: true
allowed-tools: Read, Grep, Glob, Bash
---

# Improve Token Efficiency

Use this skill when the user wants repo-level token efficiency, cost analysis, or Claude Code usage patterns across many sessions.

The skill reads `~/.claude/projects/<encoded-repo-path>/*.jsonl` directly. That captures `usage` fields without extra API calls, so you can reconstruct cost, cache utilization, and waste patterns from local logs.

## Workflow

### 1. Select the target repo

If the user gave a repo path, use it. Otherwise use the current working directory. The script resolves the matching encoded session directory automatically.

### 2. Run the session analyzer

```bash
python3 .claude/skills/improve-token-efficiency/scripts/analyze_sessions.py \
    --repo "$(pwd)" \
    --out /tmp/session_analysis.json
```

- Use `--repo <path>` for another repository.
- Use `--sessions-dir <path>` only when the user wants direct control.
- Empty sessions are ignored automatically.

The analyzer computes per-session and total:
- input, output, cache write, cache read tokens
- cache hit ratio
- redundant reads
- tool call counts
- estimated USD cost
- composite efficiency score and grade

### 3. Build the dashboard

```bash
python3 .claude/skills/improve-token-efficiency/scripts/build_dashboard.py \
    --input /tmp/session_analysis.json \
    --out /tmp/efficiency_report.html
open /tmp/efficiency_report.html
```

The default HTML dashboard includes:
- KPI cards
- cost breakdown
- Pareto chart
- grade histogram
- cost-vs-score scatter
- rubric table
- top-session table
- savings cards

Optional advanced pattern analysis is also bundled:

```bash
python3 .claude/skills/improve-token-efficiency/scripts/detect_patterns.py \
    --repo "$(pwd)" \
    --out /tmp/pattern_analysis.json
python3 .claude/skills/improve-token-efficiency/scripts/build_patterns_dashboard.py \
    --input /tmp/pattern_analysis.json \
    --out /tmp/patterns_report.html
```

## Scoring rubric

`analyze_sessions.py` scores each session on 4 axes:
- cache utilization
- output density
- read redundancy
- tool economy

The composite grade scale is:
- `A+` >= 90
- `A` >= 85
- `A-` >= 80
- `B+` >= 75
- `B` >= 70
- `B-` >= 65
- `C+` >= 60
- `C` >= 55
- `C-` >= 50
- `D` >= 40
- `F` < 40

## Reporting

Summarize:
1. session count, total cost, average grade
2. largest cost driver
3. top 3 savings opportunities
4. output file paths

## Edge cases

- If the repo has never been opened with Claude Code, report that no session logs exist.
- If every session has empty usage, report that the installed CLI may be too old.
- Unknown models fall back to conservative Opus pricing.

## Files

- [`scripts/analyze_sessions.py`](./scripts/analyze_sessions.py) — aggregate session usage and scores
- [`scripts/build_dashboard.py`](./scripts/build_dashboard.py) — main HTML dashboard
- [`scripts/detect_patterns.py`](./scripts/detect_patterns.py) — inefficiency pattern detection
- [`scripts/build_patterns_dashboard.py`](./scripts/build_patterns_dashboard.py) — pattern dashboard
