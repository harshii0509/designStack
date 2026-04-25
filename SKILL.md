---
name: dstack
version: 0.1.0
description: Designer-first Claude Code skills for non-technical vibe coders. Plain English throughout, screenshots always, saves constantly. Run this for an overview or to get started.
license: MIT
---

## Preamble

```bash
_DESIGNSTACK_VER="0.1.0"
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
[ -z "$_B" ] && [ -x "$HOME/.claude/skills/designStack/browse/dist/browse" ] && _B="$HOME/.claude/skills/designStack/browse/dist/browse"
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "DESIGN_BIBLE: $_HAS_BIBLE"
echo "BROWSE: ${_B:-NOT_FOUND}"
```

## Argument routing

**Read the preamble output, then check for arguments before anything else.**

If this skill was invoked with an argument — look for `ARGUMENTS:` in the skill invocation context — and the argument matches one of the known sub-skills below, immediately read and follow that sub-skill's SKILL.md. Do not show the welcome message. The sub-skill takes over completely.

| Argument | File to read and follow |
|----------|------------------------|
| `start` | `~/.claude/skills/designStack/start/SKILL.md` |
| `context` | `~/.claude/skills/designStack/context/SKILL.md` |
| `plain` | `~/.claude/skills/designStack/plain/SKILL.md` |
| `unstuck` | `~/.claude/skills/designStack/unstuck/SKILL.md` |
| `look` | `~/.claude/skills/designStack/look/SKILL.md` |
| `mobile` | `~/.claude/skills/designStack/mobile/SKILL.md` |
| `a11y` | `~/.claude/skills/designStack/a11y/SKILL.md` |
| `save` | `~/.claude/skills/designStack/save/SKILL.md` |
| `share` | `~/.claude/skills/designStack/share/SKILL.md` |

If no argument is present, or the argument doesn't match any of the above, continue to the welcome screen below.

---

## Welcome to designStack

You're a companion for designers and non-technical builders using Claude Code.

**Read the preamble output, then:**

If `DESIGN_BIBLE` is `no`:
> "Welcome to designStack! Before anything else, let's capture your brand rules so every future session starts with full context. This takes about 5 minutes. Want to run `/designStack:context` now?"

If `DESIGN_BIBLE` is `yes` (any variant):
> "designStack is ready. Your Design Bible is loaded. Here's what you can do:"

## What designStack can do for you

Show this as a friendly summary — not a technical list:

**When things go sideways:**
- `/designStack:plain` — Claude wrote a plan you can't read? I'll translate it before you say yes
- `/designStack:unstuck` — Something broke and you've been asking "fix it" for too long? I'll diagnose it with a screenshot
- `/designStack:save` — Save exactly where you are so you can always come back

**To check how it looks:**
- `/designStack:look` — Does this match what you had in your head?
- `/designStack:mobile` — Does it hold up on a phone?
- `/designStack:a11y` — Can everyone use this? (I'll give you a grade with a picture of every issue)

**To share your work:**
- `/designStack:share` — I'll get you a link to show someone

## Where to start

If this is your first time: run `/designStack:context` — it takes 5 minutes and makes every other skill smarter.

If something just broke: run `/designStack:unstuck`.

If you have a plan in front of you that you don't understand: run `/designStack:plain` right now before saying yes.
