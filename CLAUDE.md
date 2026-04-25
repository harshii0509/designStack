# designStack

Designer-first Claude Code skills for non-technical vibe coders. Speak plain English, show screenshots, save constantly.

## Skill routing

When the user's request matches one of these, invoke the skill FIRST — before answering directly.

| When the user says... | Invoke |
|---|---|
| "translate this plan", "I don't understand what you're doing", "explain this in plain English" | `dstack:plain` |
| "something broke", "it's not working", "I'm stuck", "fix this error", error message in chat | `dstack:unstuck` |
| "does this look right", "check my design", "visual QA", "look at this" | `dstack:look` |
| "check on mobile", "does this work on phone", "responsive" | `dstack:mobile` |
| "check accessibility", "a11y", "can everyone use this" | `dstack:a11y` |
| "save my progress", "checkpoint", "commit this" | `dstack:save` |
| "share this", "deploy", "get a link", "show someone", "go live" | `dstack:share` |
| "set the vibe", "aesthetic direction", "make it look like", "style guide" | `dstack:vibe` |
| "is this on brand", "brand check", "check consistency" | `dstack:brand` |
| "polish this", "final check before sharing" | `dstack:polish` |
| "add animation", "make it move", "add motion" | `dstack:animate` |
| "add delight", "make it fun", "success state", "empty state" | `dstack:delight` |
| "set up design rules", "build design bible", "capture my brand", first-time setup | `dstack:context` |

## Available designStack skills

- `/ds:context` — Build the Design Bible (run once per project)
- `/ds:plain` — Translate plans to plain English
- `/ds:unstuck` — Diagnose errors visually
- `/ds:look` — Visual QA against design rules
- `/ds:mobile` — Responsive check (3 breakpoints)
- `/ds:a11y` — Accessibility audit with letter grade
- `/ds:save` — Git checkpoint with human-readable message
- `/ds:share` — Deploy and get a shareable link
- `/ds:vibe` — Set aesthetic direction from feeling words
- `/ds:brand` — Brand consistency scan
- `/ds:polish` — Pre-ship quality check (11 dimensions)
- `/ds:animate` — Add purposeful motion
- `/ds:delight` — Add joy moments

## Design Bible

designStack maintains `dstack/DESIGN-BIBLE.md` in the project root. Every skill reads from it. If it doesn't exist, suggest running `/ds:context` first.

If a `DesignBrain.md` or `ICP-CONTEXT.md` exists in the project, treat it as the Design Bible source of truth and read it before any design-related skill.

## Voice rules

All designStack output must be in plain English:
- No unexplained jargon ("component" → "piece of the page", "refactor" → "reorganize")
- Always show screenshots before describing issues
- Always describe what will be DELETED, not just what's added
- Use letter grades (A/B/C/D), not numeric scores, for user-facing ratings
- Every plan must get user confirmation before code is written
