# Changelog

All notable changes to dStack are documented here. Written for humans, not engineers.

## v0.1.0 — April 2026

First release.

**9 skills:**
- `/dstack:start` — First-session wizard. Ask 3 questions, builds your Design Bible automatically.
- `/dstack:context` — Build or refresh your Design Bible. Reads shadcn, Tailwind, and Blend tokens automatically.
- `/dstack:plain` — Translate any Claude plan into plain English before you say yes.
- `/dstack:unstuck` — Something broke? Get a plain-English diagnosis before any code is touched.
- `/dstack:look` — Visual check against your brand rules. Score out of 10 with annotated screenshot.
- `/dstack:mobile` — Phone, tablet, desktop side-by-side. Flags anything broken or hard to tap.
- `/dstack:a11y` — Accessibility grade A–D with every problem marked on a screenshot.
- `/dstack:save` — Save your progress with a human-readable description.
- `/dstack:share` — Deploy and get a shareable link for feedback or going live.

**Key features:**
- Design Bible (`dstack/DESIGN-BIBLE.md`) — living brand file every skill reads from
- CLAUDE.md auto-injection — design rules in every Claude session, not just skill runs
- gstack coexistence — reads gstack's design file automatically if you use both
- curl one-liner install — `curl -fsSL [url] | bash` with plain-English error messages
- Progressive disclosure — verdict first, full report on request
- Server-not-running recovery — plain-English message when local server is off

---

## What's coming in v0.2

- `/dstack:vibe` — Set your brand personality in 2 minutes
- `/dstack:brand` — Brand drift check across your whole site
- `/dstack:polish` — Final quality pass before launch
- `/dstack:animate` — Add purposeful motion to your UI
- `/dstack:delight` — Moments of joy — micro-interactions and personality touches
- Native Windows support (no WSL required)
