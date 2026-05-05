---
name: ds-unstuck
version: 0.1.0
description: >
  Diagnoses a broken feature with a screenshot and annotated plain-English
  explanation of the problem — before any code is touched. Use when something
  stopped working, the user doesn't know why, or runs '/ds-unstuck'.
license: MIT
allowed-tools:
  - Bash
  - Read
  - AskUserQuestion
compatibility: Requires browse binary for screenshots and console error capture. Falls back to code + error message analysis without it.
---

## Preamble

```bash
"$HOME/.claude/skills/ds/lib/env.sh" "unstuck"
```

## What this skill does

Something stopped working. You're going to diagnose it visually, explain it in plain English, then propose exactly one fix — and wait for approval before touching anything.

This skill never writes code until the user says yes.

## Step 1 — Understand the problem

Ask the user (if it's not already clear from context):
> "What happened? Describe it like you'd tell a friend — 'the button doesn't do anything when I click it', 'the page looks broken', 'I get a red error message', etc."

Also check the conversation history for any error messages, stack traces, or descriptions already provided.

## Step 2 — Take a screenshot (if browse available)

If `BROWSE` is not `NOT_FOUND` and the project has a running URL:

Ask: "Is your project running right now? What's the URL?"

If yes:
```bash
$B goto <URL>
$B screenshot /tmp/dstack-unstuck.png
$B console --errors
```

**If the URL is not reachable:**
> "It looks like your project isn't running right now. To start it, open your terminal and type `npm run dev` (or `npm start`) — then tell me the URL, usually http://localhost:3000. I'll wait."

Do not continue until the user confirms the project is running.

Show the screenshot to the user via the Read tool so they can see it.

Also check the browser console for errors:
```bash
$B console
```

Note any red errors in the console output.

If `BROWSE` is `NOT_FOUND`: skip screenshots. Work from the error message and code context only.

## Step 3 — Diagnose in plain English

Follow the jargon rules in `lib/plain-language.md` when diagnosing — no technical terms.

Write ONE sentence that describes exactly what's wrong. No technical jargon. Examples:

- "The submit button isn't working because it's pointing to a page that doesn't exist yet."
- "The page looks blank because there's an error in the data it's trying to load."
- "The layout is broken because a piece of the page is missing a required setting."
- "The image isn't showing up because the file path has a typo."
- "The login isn't working because the connection to your database timed out."

If you can identify WHERE on the screen the problem is and browse is available, create an annotated screenshot:
```bash
$B snapshot -i -a -o /tmp/dstack-unstuck-annotated.png
```

Show the annotated screenshot via Read tool. Point to the specific element with the problem.

## Step 4 — Check the Design Bible

If `DESIGN_BIBLE` is yes, read `design/DESIGN-BIBLE.md`. Ask: was this a design rule being ignored (e.g. wrong color, missing component) or a pure code error?

If it's a design drift issue, note it: "This also drifted from your brand rules — the [X] should be [Y] according to your Design Bible."

## Step 5 — Propose one fix

Present exactly one fix in plain English:

---

**Here's what I think happened:**
[One-sentence plain-English diagnosis]

**Here's what I'd do to fix it:**
[Plain English — e.g. "Update the button to point to the /pricing page instead of /prices"]

**What will change:**
- [specific file or piece of the page] — [what will be different]

**What will NOT change:**
- Everything else stays exactly as it is.

**How long will this take:** [quick fix / a few minutes / longer]

---

Then ask:
> **Ready to fix it?**
>
> A) Yes, fix it
> B) Let me try to fix it myself — just point me to the right place
> C) Actually, undo the last change instead — take me back to before this happened

## Step 6 — Handle the response

**If A:** Implement the fix. Show before/after screenshot after. Update Design Bible memory log if it was a brand drift issue.

**If B:** Tell them exactly which file and line to look at in plain terms. Point to the section, not just the file name. Example: "Open the `pages/contact.js` file — look for the button near the bottom of the file. Change `/prices` to `/pricing`."

**If C — Undo:**
```bash
git log --oneline -5
```

Show the last 5 saves in plain English (not commit hashes — translate them). Then:
```bash
git stash
```
Or if they want to go back to a specific commit:
> "I'll take you back to [X]. This will undo everything since then. Are you sure?"
Only run `git reset` if they confirm.

## Completion

Always run this bash before ending, regardless of outcome. Replace `OUTCOME` with: `success`, `error`, or `abort`.

```bash
"$HOME/.claude/skills/ds/lib/telemetry-end.sh" "unstuck" "OUTCOME"
```

Report completion status: **DONE** / **DONE_WITH_CONCERNS** / **BLOCKED** / **NEEDS_CONTEXT**
