---
name: ds:save
version: 0.1.0
description: Save your progress with a human-readable description. Creates a restore point you can always come back to. Run this before any risky change.
---

## Preamble

```bash
_DESIGNSTACK_VER="0.1.0"
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "NOT_A_GIT_REPO")
_CHANGED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
_NEW=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
_LAST_COMMIT=$(git log -1 --pretty=format:"%h — %s" 2>/dev/null || echo "no history yet")
_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "ROOT: $_ROOT"
echo "CHANGED_FILES: $_CHANGED"
echo "NEW_FILES: $_NEW"
echo "LAST_COMMIT: $_LAST_COMMIT"
echo "BRANCH: $_BRANCH"
```

## What this skill does

Save where you are right now. Like hitting Save in a game — you can always come back to this exact moment.

## Step 1 — Check git is set up

If `ROOT` is `NOT_A_GIT_REPO`:
> "This project doesn't have saving turned on yet — which means if something breaks, there's no way to get back to where you are now. I can set it up in a few seconds. Want me to?"

If yes, run:
```bash
git init
git add -A
```

Tell the user: "Done — saving is now turned on. I'll create your first snapshot in a moment."

Then continue.

If no:
> "OK, I won't set it up right now. Just know that without saving enabled, there's no undo if something goes wrong. You can always run `/ds:save` again later to set it up."
Stop here.

## Step 2 — First-time explanation (if no git history)

If `LAST_COMMIT` is `no history yet`, explain once:
> "Quick note: I use something called 'git' to save your progress — think of it as a time machine for your project. Every time you save, I create a snapshot you can jump back to at any point. You'll never permanently break anything as long as you save regularly."

## Step 3 — Summarize what changed

Look at the changed files:
```bash
git diff --name-only
git ls-files --others --exclude-standard
git diff --stat
```

Translate what changed into one plain English sentence. Examples:

- "Added the pricing page and updated the navigation to include a link to it"
- "Changed the button color to match your brand and fixed the header layout on mobile"
- "Updated the contact form and added a success message when it submits"
- "Added three new product cards to the homepage"
- "Fixed the typo in the footer and updated the copyright year"

**Rules for writing the message:**
- No technical terms (no "refactor", "fix typo in CSS", "update component props")
- Always describe WHAT the user can now see or do, not what code changed
- Maximum 1 sentence
- If many things changed, pick the most important 2 and write "... and other small fixes"

## Step 4 — Show what will be saved

Show the user:

---

**Saving your progress**

What I'll save in plain English:
"[your human sentence]"

Files being saved: [number] files changed, [number] new
Last save was: [time of last commit, e.g. "20 minutes ago" or "this is your first save"]

---

Ask: "Ready to save?" — proceed immediately unless they say no.

## Step 5 — Commit

```bash
git add -A
git commit -m "[the human sentence you wrote]"
```

## Step 6 — Confirm

After committing, show:

> ✓ Saved! You can always come back to this moment.
>
> **Saved:** "[the sentence]"
> **When:** right now
> **On branch:** [branch name in plain terms, e.g. "main" or just the branch name]
>
> Tip: run `/ds:save` before any big change. That way, if something goes wrong, you can always get back here.

## Step 7 — Update Design Bible if it was changed

If `dstack/DESIGN-BIBLE.md` was among the saved files, append to the Memory Log:
```
[date]: Design Bible saved as part of: [the human sentence]
```
