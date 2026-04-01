---
title: Computer Use — GUI Testing via MCP
keywords: [computer-use, gui, testing, screenshot, e2e, simulator, ui]
created: 2026-04-01
last_used: 2026-04-01
type: integration
---

# Computer Use — GUI Testing via MCP

## Overview
Claude Code's computer-use MCP server enables GUI interaction directly from CLI sessions.
Build, launch, click, screenshot, and verify — all in one prompt.

## Setup (one-time per project)
1. In Claude Code session: type `/mcp`
2. Enable `computer-use` server
3. Grant macOS permissions when prompted: Accessibility + Screen Recording

## Capabilities
- Native app build & visual verification
- E2E UI flow testing (tap, scroll, type, navigate)
- Layout bug reproduction + screenshot capture
- iOS Simulator / Android Emulator direct control
- Performance observation (transition delays, jank)

## Workflow Examples

### Build & Verify
```
"Build the app, run it, tap each tab, screenshot any errors."
```

### Layout Bug Reproduction
```
"The settings modal footer gets cut off on narrow screens.
Resize the window to reproduce, screenshot the clipped state,
then check the container's layout constraints."
```

### Simulator Testing (Flutter/iOS)
```
"Open iOS Simulator, run the app, swipe through onboarding screens.
Flag any screen that takes >1s to transition."
```

## When to Use
| Scenario | Use Computer Use? |
|---|---|
| Unit/integration tests | No — use CLI test runner |
| Visual layout verification | **Yes** |
| E2E user flow testing | **Yes** |
| Screenshot-based regression | **Yes** |
| Performance profiling (precise) | No — use DevTools |

## Integration with Testing Skill
Add to test plan when the project has GUI components.
Computer-use tests complement (not replace) unit/integration tests.

## Requirements
- Claude Code Pro or Max plan (research preview)
- macOS with Accessibility + Screen Recording permissions
- For mobile: Xcode Simulator or Android Emulator installed
