---
name: code-review
description: "Code review and quality check.\n\nTrigger: review, PR, quality, merge check, post-completion"
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob
---

# Code Review

## Procedure
1. Identify changed files (change_log.md or git diff).
2. Per file: error handling gaps, security risks, naming violations, duplication, unnecessary complexity.
3. Classify: CRITICAL / WARNING / INFO.
4. Structured report.

## Checklist
- [ ] Error handling
- [ ] Security
- [ ] Naming conventions
- [ ] No duplication
- [ ] No over-engineering
