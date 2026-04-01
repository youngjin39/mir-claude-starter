---
title: External Code Review via GitHub PR + OpenAI Codex
keywords: [codex, code-review, github, pr, external-review, openai]
created: 2026-04-01
last_used: 2026-04-01
type: integration
---

# External Code Review — GitHub PR + OpenAI Codex

## Overview
Complement the harness's internal code-review skill with automated external review.
Agent creates branch + PR on GitHub; OpenAI Codex reviews the diff automatically.

## Setup
1. Create GitHub private repo for the project
2. Enable OpenAI Codex code review on the repo
3. Configure agent to push branches and create PRs after task completion

## Workflow
```
Agent completes task
  → git checkout -b feature/task-name
  → git push -u origin feature/task-name
  → gh pr create --title "..." --body "..."
  → Codex auto-reviews the PR
  → Agent reads review comments → addresses feedback
  → Merge when approved
```

## Integration with Harness Code Review
| Layer | Tool | Purpose |
|---|---|---|
| Internal (immediate) | quality-agent | Real-time review during development |
| External (async) | Codex on GitHub PR | Second-opinion review from different model |

The two layers are complementary:
- Internal review catches issues before commit
- External review catches blind spots after PR creation

## When to Use
| Scenario | Recommendation |
|---|---|
| Solo agent development | Optional — internal review may suffice |
| Multi-agent collaboration | Recommended — external review adds safety |
| Production-critical code | Required — dual-layer review |
| Documentation/config changes | Skip — overkill |

## Agent Behavior Rules
- Create PR only after internal review passes (APPROVE or no CRITICAL findings)
- PR description must include: summary, test plan, changed files
- Read and address all Codex review comments before requesting merge
- Do not force-merge — escalate unresolved comments to user

## Target Projects
- 📖 콰이어트 (Flutter)
- 💣 마인스위퍼 (Flutter)
- 🤖 성장 일지 개발 (Flutter)
