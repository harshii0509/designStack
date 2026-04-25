---
name: dstack
version: 0.1.0
description: Designer-first Claude Code skills for non-technical vibe coders. Plain English throughout, screenshots always, saves constantly. Run this for an overview or to get started.
---

## Preamble

```bash
_DSTACK_VER="0.1.0"
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
_BIBLE="$_ROOT/dstack/DESIGN-BIBLE.md"
_HAS_BIBLE="no"
[ -f "$_BIBLE" ] && _HAS_BIBLE="yes"
# Also check for compatible files from @heysolacy
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/DesignBrain.md" ] && _HAS_BIBLE="yes (DesignBrain.md)"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/ICP-CONTEXT.md" ] && _HAS_BIBLE="yes (ICP-CONTEXT.md)"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/DESIGN.md" ] && _HAS_BIBLE="yes (DESIGN.md)"
_B=""
[ -x "$HOME/.claude/skills/gstack/browse/dist/browse" ] && _B="$HOME/.claude/skills/gstack/browse/dist/browse"
[ -z "$_B" ] && [ -x "$HOME/.claude/skills/dstack/browse/dist/browse" ] && _B="$HOME/.claude/skills/dstack/browse/dist/browse"
echo "DSTACK: $_DSTACK_VER"
echo "DESIGN_BIBLE: $_HAS_BIBLE"
echo "BROWSE: ${_B:-NOT_FOUND}"
```

## Welcome to dStack

You're a companion for designers and non-technical builders using Claude Code.

**Read the preamble output, then:**

If `DESIGN_BIBLE` is `no`:
> "Welcome to dStack! Before anything else, let's capture your brand rules so every future session starts with full context. This takes about 5 minutes. Want to run `/dstack:context` now?"

If `DESIGN_BIBLE` is `yes` (any variant):
> "dStack is ready. Your Design Bible is loaded. Here's what you can do:"

## What dStack can do for you

Show this as a friendly summary — not a technical list:

**When things go sideways:**
- `/dstack:plain` — Claude wrote a plan you can't read? I'll translate it before you say yes
- `/dstack:unstuck` — Something broke and you've been asking "fix it" for too long? I'll diagnose it with a screenshot
- `/dstack:save` — Save exactly where you are so you can always come back

**To check how it looks:**
- `/dstack:look` — Does this match what you had in your head?
- `/dstack:mobile` — Does it hold up on a phone?
- `/dstack:a11y` — Can everyone use this? (I'll give you a grade with a picture of every issue)

**To share your work:**
- `/dstack:share` — I'll get you a link to show someone

## Where to start

If this is your first time: run `/dstack:context` — it takes 5 minutes and makes every other skill smarter.

If something just broke: run `/dstack:unstuck`.

If you have a plan in front of you that you don't understand: run `/dstack:plain` right now before saying yes.
