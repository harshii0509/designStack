# Changelog

All notable changes to designStack are documented here. Written for humans, not engineers.

## v0.2.0 — May 2026

**5 new skills shipped.**

- `/ds:vibe` — Set your brand personality in 2 minutes. Tell it how your product should feel, get 3 visual directions to pick from, Design Bible updates automatically.
- `/ds:brand` — Brand drift scanner. Checks every page against your Design Bible rules — catches color, font, spacing, and radius drift.
- `/ds:polish` — 11-point pre-launch quality check. Plain English results across layout, readability, color, buttons, mobile, keyboard, load speed, alt text, empty states, and forms.
- `/ds:animate` — Motion that fits your vibe. Calm brand gets subtle motion, bold brand gets expressive. `prefers-reduced-motion` accessibility built in.
- `/ds:delight` — Two high-impact moments: the success state (what happens after someone completes something) and the empty/first-time state (what new users see first).

---

## v0.1.0 — April 2026

First release.

**9 skills:**
- `/ds:start` — First-session wizard. Ask 3 questions, builds your Design Bible automatically.
- `/ds:context` — Build or refresh your Design Bible. Reads shadcn, Tailwind, and Blend tokens automatically.
- `/ds:plain` — Translate any Claude plan into plain English before you say yes.
- `/ds:unstuck` — Something broke? Get a plain-English diagnosis before any code is touched.
- `/ds:look` — Visual check against your brand rules. Score out of 10 with annotated screenshot.
- `/ds:mobile` — Phone, tablet, desktop side-by-side. Flags anything broken or hard to tap.
- `/ds:a11y` — Accessibility grade A–D with every problem marked on a screenshot.
- `/ds:save` — Save your progress with a human-readable description.
- `/ds:share` — Deploy and get a shareable link for feedback or going live.

**Key features:**
- Design Bible (`design/DESIGN-BIBLE.md`) — living brand file every skill reads from
- CLAUDE.md auto-injection — design rules in every Claude session, not just skill runs
- curl one-liner install — `curl -fsSL [url] | bash` with plain-English error messages
- Progressive disclosure — verdict first, full report on request
- Server-not-running recovery — plain-English message when local server is off

---

## What's coming in v0.3

- Native Windows support (no WSL required)
- `/ds:vibe` design preview improvements — richer HTML preview with real font loading
- Design Bible diffing — show what changed between sessions
