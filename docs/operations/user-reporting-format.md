---
title: User Reporting Format
keywords: [reporting, progress, result, discussion, readability, user-facing]
related: [operations/claude-runtime.md, operations/codex-runtime.md]
created: 2026-04-26
last_used: 2026-04-26
type: guide
---

# User Reporting Format

## Goal
- Keep user-facing updates informative and easy to scan.

## Rules
- Always tell the user the parts that matter: progress, result, and discussion points.
- Separate those parts explicitly when more than one is present.
- Follow `no bullshit, only efficiency`: remove filler, hype, hedging, and repetitive lead-ins.
- For progress updates, prefer one short label line plus 1~3 short bullets or sentences.
- Never ship a single long wrapped status line when the same content can be split into shorter lines.
- Keep each block short. Prefer short paragraphs or flat bullets.
- Use line breaks so updates scan quickly.
- Do not paste internal reasoning flow as a status update.
- Do not collapse multiple decisions into one long sentence.

## Agent Application
- Apply the same reporting format to delegated agents.
- Review delegated output before relaying it if the format is hard to scan.
