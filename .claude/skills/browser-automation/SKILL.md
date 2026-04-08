---
name: browser-automation
description: Real-browser control via dev-browser CLI (Playwright in QuickJS sandbox). Use for scraping, E2E, research, web-app operation.
triggers: [scrape, e2e, playwright, browser, login flow, dashboard test, 스크래핑, 브라우저 자동화]
---

# Browser Automation

Pattern: dev-browser CLI runs Playwright code inside a QuickJS WASM sandbox. No MCP, no extensions. Agents invoke via `Bash(dev-browser ...)`.

## When to fire
- User asks to scrape a site, automate a login, test a web UI, extract JSON from a page, or "just open X and do Y"
- Research tasks needing live web state (prices, docs, competitor pages)
- E2E checks on the user's own deployed apps

## Hard prerequisites
- `dev-browser` installed globally (`npm install -g dev-browser && dev-browser install`). If `dev-browser --help` fails → STOP and tell the user to install.
- `.claude/settings.local.json` `permissions.allow` must include `Bash(dev-browser *)` (setup.sh module #6 adds this).

## Basic usage
```bash
dev-browser run --script - <<'JS'
const page = await browser.newPage();
await page.goto('https://example.com');
const title = await page.title();
return { title };
JS
```
Persistent session: use `dev-browser connect` to reuse an existing Chrome profile for login-required workflows.

## Procedure
1. Confirm `dev-browser --help` runs. If not → halt + install instructions.
2. Write the script as plain Playwright JS — no agent DSL.
3. Pass via stdin or `--script file.js`. Prefer stdin for one-shots, file for reusable flows.
4. Return structured JSON, not scraped HTML blobs. Extract only the fields the task needs.
5. On failure: classify per error-taxonomy (network timeout → transient; selector miss → model-fixable; captcha/2FA → interrupt).

## Hard rules
- **Credentials never in script args or stdin.** Use environment variables: `DEV_BROWSER_USER`, `DEV_BROWSER_PASS`, etc. Script reads via `process.env`. Arg-passed secrets leak into shell history + logs.
- **Never bypass robots.txt or ToS** without explicit user authorization for that specific site.
- **Do not scrape at high frequency.** Default to 1 req/sec unless user sets rate.
- **Sandbox does not mean safe for scale.** Respect target-site load.
- **Never screenshot pages containing PII/credentials** without explicit user request.
- On captcha, 2FA, or auth wall → STOP and hand back to user (interrupt, not model-fixable).

## Output
One-line report: `BROWSER {action} {url} → {result summary}`, then the structured JSON. Never paste raw HTML back into the conversation.
