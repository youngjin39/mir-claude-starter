---
name: writing-plans
description: "Concrete implementation plan. Bite-sized steps.\n\nTrigger: plan, implementation plan, step design"
---

# Writing Plans

## Prerequisite
User approved design from brainstorming stage.

## Principles
- Each step: **2~5 minutes** of work.
- Abstract expressions like "add tests" or "refactor" are **forbidden**.
- Include actual code, exact commands, and expected output.
- For cross-module work, preserve task boundary and validation intent before decomposing steps.

## Procedure
1. Classify the task boundary:
   - local edit
   - module-scoped change
   - cross-module change
   - starter/parity change
2. If the task is cross-module, architecture-facing, or dependency-sensitive, require `ai-ready-bluebricks-development` context first:
   - affected module or blueprint
   - in-scope files
   - forbidden files
   - hidden dependency risk
   - validation target
3. Map file structure based on approved design and boundary.
4. Decompose into steps (TDD cycle when applicable):
   - Step N-1: Write failing test (include code)
   - Step N-2: Run test, confirm failure (command + expected output)
   - Step N-3: Minimal implementation (include code)
   - Step N-4: Run test, confirm pass (command + expected output)
   - Step N-5: Commit (command)
5. Record current step in tasks/plan.md.

## Boundary Rules
- Every multi-step plan must name touched files and untouchable files.
- If a step crosses a module boundary, say why.
- If blueprint or bluebrick context exists, reference it explicitly in the plan.
- If no blueprint exists for repeated cross-module work, note that gap instead of pretending the boundary is obvious.

## Validation Rules
- Each plan must state the narrowest meaningful validation before implementation starts.
- Broad suites are fallback, not default.
- For starter/parity work, include regeneration and verifier commands as explicit steps.

## Exit Condition
- All steps contain concrete code + commands + expected output.
- Cross-module plans include boundary, blueprint context, and validation path.
- User approves plan.

## Banned Patterns
- "Add appropriate tests" — specify exact test names, inputs, expected outputs.
- "Refactor as needed" — specify which function, what change, why.
- "Handle edge cases" — list each edge case explicitly.
- Any step that cannot be executed by copy-pasting the provided code/command.
- "Check related modules" — name the modules or files.
- "Validate later" — state the exact validation step now.
- "Update docs if needed" — name the exact doc and trigger condition.

## Rationalization Prevention
| Excuse | Rebuttal |
|---|---|
| "Can't write all code upfront" | Direction and skeleton are writable. Concrete > vague. |
| "Too detailed = inflexible" | Detailed plans make change points explicit. |
| "This step is obvious" | "Obvious" = unverified assumption. Make it explicit. |

## Output Format
```
## Implementation Plan: {task summary}
Estimated steps: N | Estimated files: M

### Boundary
- Type: local/module/cross-module/starter-parity
- In scope: {files/modules}
- Out of scope: {files/modules}
- Blueprint/Bluebrick context: {doc or none}
- Validation target: {smallest meaningful gate}

### Step 1: {title}
- File: {path}
- Code:
  ```{lang}
  (actual code)
  ```
- Run: `{command}`
- Expected: {output}

### Step 2: ...
```

## Next Step
→ execution (after user approval, delegate to executor-agent)
