---
name: verification
description: "Evidence-based verification + 6-stage gate. No unverified completion.\n\nTrigger: verify, done check, proof, self-check"
---

# Verification

## Iron Law
Claiming completion without proof is lying.

## Banned Expressions
- "should work" / "probably fine"
- "looks correct" / "seems right"
- "I believe" / "I think"

## 6-Stage Gate
```
Build → Type Check → Lint → Test Suite → Security Scan → Diff Review
```

| Stage | Action | Pass Criteria |
|---|---|---|
| 1. Build | Run build command | Success |
| 2. Type Check | Run type checker (if applicable) | 0 errors |
| 3. Lint | Run linter | 0 errors (warnings: report) |
| 4. Test Suite | Run tests | All pass |
| 5. Security Scan | Check secrets, console.log, unused imports | 0 violations |
| 6. Diff Review | Read diff, confirm matches intent | Match |

### Execution Rules
- **Stop on first failure**. Do not run subsequent stages (save tokens).
- Skip unavailable stages with SKIP label (e.g., no type checker → Type Check = SKIP).
- READY verdict only when all stages PASS.
- For starter/parity work, include regeneration and verifier evidence in the relevant stages.

## Red Team 5Q (post-gate self-attack)
After all 6 stages PASS, answer these 5 questions before issuing READY:
1. "Does this change break any existing behavior not covered by tests?"
2. "Is there an edge case this implementation silently mishandles?"
3. "Would this design hold if input volume increases 10x?"
4. "Am I confident because of evidence, or because I wrote it?"
5. "What is the most likely way this fails in production?"
6. "What hidden assumption does this design rely on, and what happens if that assumption is wrong?"

If any answer raises doubt → investigate before issuing READY.

## AI-Ready Verification Lens
When `ai-ready-bluebricks-development` was relevant, Diff Review must also confirm:
1. The final diff stayed inside the declared task boundary.
2. Cross-module changes did not silently expand into unrelated files.
3. Public interfaces and downstream dependencies still match the intended scope.
4. Any hidden hazard named during planning was actually checked.
5. If blueprint docs exist, the change does not obviously contradict them without a reported drift note.

## Diff Review Rules
During Diff Review, explicitly ask:
- Did implementation match the approved plan?
- Did validation prove the risky path, or only the happy path?
- Did the change preserve module boundaries?
- Is any hidden assumption still untested?

## Output Parsing Recovery
When a tool result or model output is malformed, partial, or schema-mismatched:
1. **Never** proceed as if successful. Never silently retry identically.
2. **Partial extract**: keep only validated fields. List what was dropped.
3. **Decision coverage check**: does the partial cover the current step? If yes → continue with explicit note. If no → go to step 4.
4. **Feed-back round**: return the parse failure to the model with (a) expected schema, (b) actual fragment, (c) which field failed. Request a corrected response.
5. **Two strikes**: after 2 feed-back rounds without valid parse → classify as `unknown` per Error Taxonomy → STOP.

Banned moves: "assume the missing field is default", "parse loosely and hope", "retry with same prompt expecting different output".

## Circuit Breaker
- Same issue fails **3 times** → STOP.
- Instead of 4th attempt: re-examine architecture or escalate to user.

## Rationalization Prevention
| Excuse | Rebuttal |
|---|---|
| "Tests pass so it's done" | Did you verify the tests check the right thing? |
| "It compiles so it works" | Compilation ≠ correct behavior. Runtime verification needed. |
| "This is hard to test" | Hard to test = possibly bad design. |
| "Trivial change, no verification needed" | Trivial changes kill production most often. |
| "The diff is small so the risk is small" | Small diffs often break large boundaries. Check dependency impact. |

## Output Format
```
## Verification: {task summary}

### Boundary Check
- Type: local/module/cross-module/starter-parity
- Blueprint/Bluebrick context used: {doc or none}
- Scope respected: YES/NO
- Hidden hazards checked: {list}

### 6-Stage Gate
| Stage | Command | Result | Verdict |
|---|---|---|---|
| Build | {cmd} | {output} | PASS/FAIL/SKIP |
| Type Check | {cmd} | {output} | PASS/FAIL/SKIP |
| Lint | {cmd} | {output} | PASS/FAIL/SKIP |
| Test Suite | {cmd} | {output} | PASS/FAIL/SKIP |
| Security | (manual) | {findings} | PASS/FAIL |
| Diff Review | (manual) | {summary} | PASS/FAIL |

### Final Verdict: READY / NOT READY
(If NOT READY: failed stage + cause + next action)

### Residual Risk
- {remaining uncertainty}
```
