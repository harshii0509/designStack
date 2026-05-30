---
name: ds-polish
version: 0.2.0
description: >
  Runs a final pre-launch release gate across 11 UI checks and produces a
  prioritized fix list before sharing. Use when the user wants a holistic launch
  review, asks if the product is ready to share, or runs '/ds-polish'.
license: MIT
allowed-tools:
  - Bash
  - Read
  - AskUserQuestion
compatibility: Requires browse binary for visual checks and axe-core injection. Falls back to code-only audit without it.
---

## Preamble

```bash
"../lib/env.sh" "polish"
```

## What this skill does

Think of this as the final check before you hit publish. I'll look at your site through 11 different lenses — from "does it look good?" to "can everyone use it?" — and tell you exactly what to fix before sharing with the world.

This is the release gate. If the user only wants one-screen visual QA, route them to `/ds-look`. If they want cross-page brand consistency, route them to `/ds-brand`.

Takes about 3–5 minutes.

> "Checking 11 areas before you share this. Takes 3–5 minutes. I'll tell you what needs fixing and what's already great."

## Step 1 — Get the URL

Ask:
> "What's the main page you want to polish before sharing? (e.g. `http://localhost:3000` or your live site)."

If the user asks for multiple pages, tell them:
> "Let's do the most important page first. `/ds-polish` is the final release gate for one page at a time. If you want a multi-page consistency scan, use `/ds-brand`."

## Step 2 — Load context

If `DESIGN_BIBLE` is `yes`, read it for brand rules.
Note from Memory Log any recent confirmed intentional changes.

## Step 3 — Run all 11 checks

For each check, take a screenshot and extract what you need. Describe findings in plain English.
Read `references/checklist.md` and run all 11 checks in order, following its commands, thresholds, and plain-English result patterns.

## Step 4 — Write the polished report

Follow the jargon rules in `lib/plain-language.md` when writing this report — no technical terms.

---

**Pre-launch check for [URL]**

**Overall: [Ready to share / A few things to fix / Needs work before launch]**

Score: [X]/11 checks passed

---

✓ **Already great:**
[List checks that passed — give credit for what's working]

---

⚠️ **Fix before sharing:**

[For each failed check:]
**[Check name]** — [Plain English description of the issue]
*How to fix:* [Specific plain-English fix]
*How long:* [Quick (1 min) / Short (5-10 min) / Takes a while]

---

**My top 3 fixes (do these now):**
1. [Most visible or impactful issue]
2. [Second most important]
3. [Third]

**If you fix just these 3:** [what the result will be]

---

## Step 5 — Offer to fix

> "Want me to fix any of these? Pick the number (1, 2, or 3 from the list above), say 'fix them all', or tell me which specific thing to tackle first."

## Step 6 — After fixing, take an after screenshot

Show before and after at desktop:
```bash
$B goto <URL>
$B screenshot /tmp/dstack-polish-after.png
```

> "Before and after:"
[show /tmp/dstack-polish-before (taken in Step 3)]
[show /tmp/dstack-polish-after]

## Design Bible update

If any issues were fixed that establish new rules, append to Memory Log:
```
[date]: /ds-polish ran on [URL]. Score: [X]/11. Issues fixed: [list]. Rules confirmed: [any new rules].
```

## Completion

Always run this bash before ending, regardless of outcome. Replace `OUTCOME` with: `success`, `error`, or `abort`.

```bash
"../lib/telemetry-end.sh" "polish" "OUTCOME"
```

Report completion status: **DONE** / **DONE_WITH_CONCERNS** / **BLOCKED** / **NEEDS_CONTEXT**
