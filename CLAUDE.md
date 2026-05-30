# designStack

Designer-first Claude Code skills for designers building their own products. Speak plain English, show screenshots when available, save constantly.

## Skill routing

When the user's request matches one of these, invoke the skill FIRST — before answering directly.

| When the user says... | Invoke |
|---|---|
| "something broke", "it's not working", "I'm stuck", "fix this error", error message in chat | `dstack:unstuck` |
| "does this screen look right", "check this page after my UI change", "visual QA on this screen", "look at this page" | `dstack:look` |
| "check on mobile", "does this work on phone", "responsive" | `dstack:mobile` |
| "check accessibility", "a11y", "can everyone use this" | `dstack:a11y` |
| "save my progress", "checkpoint", "commit this" | `dstack:save` |
| "share this", "deploy", "get a link", "show someone", "go live" | `dstack:share` |
| "update designStack", "upgrade designStack", "new version of designStack" | `dstack:upgrade` |
| "set the vibe", "aesthetic direction", "pick a visual direction", "style guide" | `dstack:vibe` |
| "scan the whole site for drift", "brand check across pages", "check consistency sitewide" | `dstack:brand` |
| "polish this before launch", "final check before sharing", "release gate" | `dstack:polish` |
| "add animation", "make interactions feel less static", "make it move" | `dstack:animate` |
| "add delight", "improve the success state", "improve the empty state" | `dstack:delight` |
| "set up design rules", "build design bible", "capture my brand", first-time setup | `dstack:context` |

## Available designStack skills

- `/ds-context` — Build the Design Bible (run once per project)
- `/ds-unstuck` — Diagnose errors visually
- `/ds-look` — Visual QA against design rules
- `/ds-mobile` — Responsive check (3 breakpoints)
- `/ds-a11y` — Accessibility audit with letter grade
- `/ds-save` — Git checkpoint with human-readable message
- `/ds-share` — Deploy and get a shareable link
- `/ds-upgrade` or `/ds-update` — Pull the latest designStack release
- `/ds-vibe` — Set aesthetic direction from feeling words
- `/ds-brand` — Brand consistency scan
- `/ds-polish` — Pre-ship quality check (11 dimensions)
- `/ds-animate` — Add purposeful motion
- `/ds-delight` — Add joy moments

## Design Bible

designStack maintains `design/DESIGN-BIBLE.md` in the project root. Every skill reads from it. If it doesn't exist, suggest running `/ds-context` first.

If a `DesignBrain.md` or `ICP-CONTEXT.md` exists in the project, treat it as the Design Bible source of truth and read it before any design-related skill.

## Voice rules

All designStack output must be in plain English:
- No unexplained jargon ("component" → "piece of the page", "refactor" → "reorganize")
- Show screenshots before describing issues when visual tools are available
- Always describe what will be DELETED, not just what's added
- Use letter grades (A/B/C/D), not numeric scores, for user-facing ratings
- Every plan must get user confirmation before code is written

## Agent skills

### Issue tracker

Issues live in GitHub Issues on `harshii0509/designStack`. See `docs/agents/issue-tracker.md`.

### Triage labels

Using default label vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context — one `CONTEXT.md` at the repo root + `docs/adr/`. See `docs/agents/domain.md`.
