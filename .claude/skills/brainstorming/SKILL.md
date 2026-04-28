---
name: brainstorming
description: "Design exploration for real forks. Required before coding only when meaningful design choices exist.\n\nTrigger: design, brainstorming, architecture, new feature"
---

# Brainstorming

<HARD-GATE>
When this skill is triggered, no code without passing this stage.
If exploration shows there is no meaningful fork, mark direct-execution-safe and exit.
</HARD-GATE>

## Use When
- New feature, architecture change, or UI flow with real product/design choices
- User explicitly asks for options, tradeoffs, or recommendation first
- Multiple plausible approaches exist and blast radius differs materially
- Cross-module changes where the implementation path is not obvious even after initial exploration

## Do Not Use When
- The task is a concrete, localized implementation with an obvious path
- The user already approved a design or handed over an implementation-ready plan
- The request is primarily execution, testing, or verification rather than option exploration

## Procedure
1. Analyze request: what must be achieved?
2. Classify the design boundary:
   - local
   - module-scoped
   - cross-module
   - starter/parity
3. If the task is cross-module, architecture-facing, or dependency-sensitive, load `ai-ready-bluebricks-development` context first:
   - affected module or blueprint
   - public interfaces involved
   - hidden hazards already known
   - downstream dependencies
4. Explore existing code: related files/patterns/dependencies.
5. **Present 2~3 alternatives** (each with deliberately different lens/perspective):
   - Each: approach + pros/cons + risks + blast radius.
   - Alternatives must differ in philosophy, not just implementation detail.
6. **Counter-narrative attack**: identify the most attractive wrong approach, build its strongest case, then demolish it with evidence. This prevents confirmation bias toward the first plausible option.
7. **Synthesis check**: if strengths from multiple options can be combined without their weaknesses, present a hybrid option.
8. Mark recommendation + rationale.
9. Wait for user approval.

## Boundary Rules
- State what modules or files each option touches.
- State what stays out of scope for each option.
- If blueprint docs exist, say whether each option fits or bends the current boundary model.
- If no blueprint exists for repeated cross-module work, call that out as a documentation gap.

## Exit Condition
- User approves design → proceed to writing-plans.
- If exploration proves there is no meaningful design fork, mark direct-execution-safe and proceed without inventing fake alternatives.
- If design is approved for cross-module work, hand off boundary and hazard context to `writing-plans`.

## Banned Patterns
- Presenting alternatives that differ only in implementation detail (same philosophy = same option).
- Recommending without first attacking the recommendation (counter-narrative is mandatory).
- "This is the only way" — if you cannot imagine an alternative, you haven't explored enough.
- Treating dependency-sensitive work as local without saying why.
- Ignoring known blueprint or interface boundaries while proposing options.

## Rationalization Prevention
| Excuse | Rebuttal |
|---|---|
| "Too simple for design" | What looks simple is most dangerous. Always check blast radius. |
| "No time, just code" | Rework from bad design costs more than upfront planning. |
| "Did something similar before" | Similar ≠ identical. Explicitly confirm differences. |
| "Only one option exists" | No alternatives = insufficient exploration. |

## Output Format
```
## Design: {task summary}
### Boundary
- Type: local/module/cross-module/starter-parity
- In scope: ...
- Out of scope: ...
- Blueprint/Bluebrick context: ...

### Option A: {name}
- Approach: ...
- Pros: ...
- Cons: ...
- Risk: ...
- Module/Boundary impact: ...

### Option B: {name}
(same structure)

### Counter-narrative
- Most attractive wrong choice: Option {Y}
- Strongest case for it: ...
- Why it fails: ...

### Recommendation: Option {X}
- Rationale: ...
- Validation direction: ...
```

## Next Step
→ writing-plans (after user approval)
