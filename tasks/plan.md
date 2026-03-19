# Plan (compact — full design: docs/decisions/master-plan-v2.md)

## 3-Axis Design
1. **Workflow** — pipeline drives all work
2. **Memory** — keyword index, load only what's needed
3. **Context** — lazy loading + model routing + handoff docs

## Current State: Phase 1~3 Complete

### Deliverables
- 3 agents (orchestrator/executor/quality)
- 8 skills (brainstorming/writing-plans/verification/deep-interview/code-review/testing/git-commit/project-doctor)
- 3 hooks (SessionStart/PreCompact/PostToolUse)
- Neuron memory (7 categories + keyword index + save/promote protocol)
- CLAUDE.md v2 (pipeline+triggers+routing+presets+isolation+hooks)
- Language protocol applied (user→KR, internal→EN)
- Harness applied to 4 projects (quietleaf, MineSweeper, StoryDirector, home_server)

## Next Action (user choice)
1. Real-world test on an actual code project
2. Add domain skills (security, performance, API, etc.)
3. Further refinement based on usage feedback
