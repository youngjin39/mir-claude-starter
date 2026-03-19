---
name: testing
description: "Test writing and execution.\n\nTrigger: test, TDD, verify, unit test, integration test"
---

# Testing

## Procedure
1. Detect test framework.
2. Check if tests exist for changed files. Create if missing.
3. Follow existing patterns. Add edge cases.
4. Run. On failure: root cause analysis → fix.

## Rules
- Test names: should_return_X_when_Y.
- Edge cases: null, empty, boundary, error conditions.
