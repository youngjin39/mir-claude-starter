---
name: code-review
description: "Code review and quality check.\n\nTrigger: review, PR, quality, merge check, post-completion"
context: fork
allowed-tools: Read, Grep, Glob, Bash
---

# Code Review

## Review Boundary
- Start from the actual diff or changed-file list.
- Expand review scope only when interface, dependency, or runtime-contract risk justifies it.
- For cross-module or architecture-facing changes, use `ai-ready-bluebricks-development` context if available.

## Procedure
1. Identify changed files (change_log.md or git diff).
2. Classify the change boundary: local, module, cross-module, or starter/parity.
3. Per file: correctness risk, error handling gaps, security risks, naming violations, duplication, unnecessary complexity.
4. For cross-module work, also check interface stability, hidden hazards, downstream impact, and scope creep.
5. Classify: CRITICAL / WARNING / INFO.
6. Structured report with evidence (cite exact lines).

## Checklist
- [ ] Correctness (matches task and does not obviously break behavior)
- [ ] Error handling (missing try/catch, unhandled promises)
- [ ] Security (injection, auth, credential exposure)
- [ ] Naming conventions (consistent with project)
- [ ] No duplication (DRY violations)
- [ ] No over-engineering (YAGNI violations)
- [ ] Scope control (no unrelated edits or silent boundary expansion)
- [ ] Dependency impact (public interface, downstream callers, hidden legacy risk)

## Severity Rules
- `CRITICAL`: likely bug, broken contract, security issue, or invalid completion claim
- `WARNING`: plausible regression, boundary drift, or meaningful maintainability risk
- `INFO`: low-risk observation that should not block completion

## Evidence Rules
- Every finding needs file and line evidence.
- Mark inferred downstream risk as inference instead of stating it as proven.
- "Would be cleaner if..." is not a finding by itself.

## Output
```
## Code Review
### Boundary
- Type: local/module/cross-module/starter-parity
- Blueprint/Bluebrick context: {doc or none}

| File | Severity | Finding | Evidence |
|---|---|---|---|
| {file}:{line} | CRITICAL/WARNING/INFO | {issue} | {code snippet} |

### Summary
- CRITICAL: {N}
- WARNING: {N}
- INFO: {N}

### Verdict
APPROVE / REQUEST_CHANGES / BLOCK

### Residual Risk
- {remaining uncertainty}
```

## External Review (Optional)
When GitHub + Codex review is configured:
1. After internal APPROVE → create branch + PR.
2. Wait for Codex review comments.
3. Address all findings before merge.

Ref: `docs/integrations/codex-code-review.md`
