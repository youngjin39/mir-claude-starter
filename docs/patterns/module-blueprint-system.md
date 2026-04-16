---
title: Module Blueprint System — Per-Module Knowledge Persistence
keywords: [blueprint, module, analysis, memory, code-analysis, reassemble, architecture]
created: 2026-04-01
last_used: 2026-04-01
type: pattern
---

# Module Blueprint System

## Problem
AI loses fine-grained structural knowledge when analyzing large codebases as a single report.
Each new session requires re-reading all source files — wasteful and error-prone.

## Solution
Create **self-contained per-module blueprint files** with a master index.
Each blueprint holds enough detail for AI to implement/modify the module without reading source.

## Directory Structure
```
docs/blueprints/
  blueprint-index.md    <- module registry + dependency graph + assembly guide
  blueprints/
    <module-name>.md    <- one per module (self-contained, AI-developable unit)
```

Note: `code-analysis.md` (summary report) maps to our existing `docs/architecture/` files.

## Blueprint File Template
```markdown
---
module-id: <unique-id>
owner-files: [list of source files]
dependencies: [module-ids]
req-coverage: [requirement IDs]
---

# Module: <name>

## Purpose
One-paragraph description.

## File Inventory
| File | Role | LOC | Key Contents |
|---|---|---|---|

## Data Structures
Full definitions with field-level annotations + lifecycle/ownership.

## Function Catalog
| Function | Visibility | Signature | Side Effects |
|---|---|---|---|

## State Machine (if applicable)
States, transitions, entry/exit conditions.

## Interface Contracts
- **Provides:** APIs/events this module exposes
- **Requires:** APIs/events this module consumes

## Modification Guide
- **Safe zones:** areas that can change without ripple effects
- **Danger zones:** changes here require cross-module testing

## Change History
Append-only development log.
```

## Blueprint Index Contains
- Module registry table (ID, name, path, layer, status)
- Dependency graph (text or Mermaid)
- Boot/initialization sequence
- Cross-module interface contracts
- Assembly instructions (step-by-step system rebuild)
- Global shared resource inventory

## Quality Gate
Every blueprint must pass ALL:
- **Self-contained:** AI can implement module from this file alone?
- **Reassemble-ready:** All interface contracts explicit?
- **Function-complete:** All public functions documented?
- **Data-complete:** All data structures have field-level docs?
- **Dependency-clear:** All dependencies named with specific contracts?
- **Modification-safe:** Safe/danger zones marked?

## When to Use
| Project Size | Recommendation |
|---|---|
| < 5 modules | Skip — docs/architecture/ is sufficient |
| 5-15 modules | Recommended — blueprints for complex modules only |
| 15+ modules | Required — full blueprint coverage |

## Relationship to Starter Memory System
- Blueprints live in `docs/blueprints/` (Layer 1: Project Knowledge)
- Blueprint index registered in `docs/memory-map.md`
- Complements (not replaces) existing architecture docs
- Blueprints are more granular: module-level vs system-level
