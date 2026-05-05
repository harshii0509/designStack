---
name: ds
version: 0.3.0
description: >
  Designer-first Claude Code skills for non-technical founders and designers
  building their own products. Plain English throughout, screenshots always,
  saves constantly. Use when user says "/ds", "designStack", "what skills do
  I have", "help me get started with my design", or runs with no argument for
  an overview.
license: MIT
allowed-tools:
  - Bash
  - AskUserQuestion
compatibility: Requires git for Design Bible and save features. Visual skills require browse binary installed via ds setup.
---

## Preamble

```bash
"$HOME/.claude/skills/ds/lib/env.sh" "ds"
```

**After the preamble:** If any printed line starts with `UPGRADE_AVAILABLE`, read `~/.claude/skills/ds/upgrade/SKILL.md` and follow its **Inline upgrade flow** before argument routing or welcome. If a line starts with `JUST_UPGRADED`, say briefly you're on the new version (`JUST_UPGRADED` shows old and new), then continue — no upgrade prompt.

## Argument routing

**Read the preamble output, then check for arguments before anything else.**

If this skill was invoked with an argument — look for `ARGUMENTS:` in the skill invocation context — and the argument matches one of the known sub-skills below, immediately read and follow that sub-skill's SKILL.md. Do not show the welcome message. The sub-skill takes over completely.

| Argument | File to read and follow |
|----------|------------------------|
| `start` | `~/.claude/skills/ds/start/SKILL.md` |
| `context` | `~/.claude/skills/ds/context/SKILL.md` |
| `unstuck` | `~/.claude/skills/ds/unstuck/SKILL.md` |
| `look` | `~/.claude/skills/ds/look/SKILL.md` |
| `mobile` | `~/.claude/skills/ds/mobile/SKILL.md` |
| `a11y` | `~/.claude/skills/ds/a11y/SKILL.md` |
| `save` | `~/.claude/skills/ds/save/SKILL.md` |
| `share` | `~/.claude/skills/ds/share/SKILL.md` |
| `vibe` | `~/.claude/skills/ds/vibe/SKILL.md` |
| `brand` | `~/.claude/skills/ds/brand/SKILL.md` |
| `polish` | `~/.claude/skills/ds/polish/SKILL.md` |
| `animate` | `~/.claude/skills/ds/animate/SKILL.md` |
| `delight` | `~/.claude/skills/ds/delight/SKILL.md` |
| `stats` | `~/.claude/skills/ds/stats/SKILL.md` |
| `upgrade` | `~/.claude/skills/ds/upgrade/SKILL.md` |
| `update` | `~/.claude/skills/ds/upgrade/SKILL.md` |

If no argument is present, or the argument doesn't match any of the above, continue to the welcome screen below.

---

## Welcome to designStack

You're a companion for designers building their own products with Claude Code.

**Read the preamble output, then:**

If `DESIGN_BIBLE` is `no`:
> "Welcome to designStack! Before anything else, let's capture your brand rules so every future session starts with full context. This takes about 5 minutes. Want to run `/ds-context` now?"

If `DESIGN_BIBLE` is `yes` (any variant):
> "designStack is ready. Your Design Bible is loaded. Here's what you can do:"

## What designStack can do for you

Show this as a friendly summary — not a technical list:

**When things go sideways:**
- `/ds-unstuck` — Something broke and you've been asking "fix it" for too long? I'll diagnose it with a screenshot
- `/ds-save` — Save exactly where you are so you can always come back

**To check how it looks:**
- `/ds-look` — Does this match what you had in your head?
- `/ds-mobile` — Does it hold up on a phone?
- `/ds-a11y` — Can everyone use this? (I'll give you a grade with a picture of every issue)

**To set the direction:**
- `/ds-vibe` — Tell me how it should feel, I'll generate three directions to pick from
- `/ds-brand` — Is this still on brand after all those changes?

**To make it great:**
- `/ds-polish` — Pre-ship checklist, 11 areas, plain English results
- `/ds-animate` — Add motion that feels natural, not flashy
- `/ds-delight` — Add joy to the moments that matter most

**To share your work:**
- `/ds-share` — I'll get you a link to show someone

**To see your usage:**
- `/ds-stats` — How much have you used designStack? Success rates and history.

**Keeping designStack current:**
- `/ds-upgrade` or `/ds-update` — Get the latest skills and fixes (you may also see a prompt when a new version ships).

## Where to start

If this is your first time: run `/ds-context` — it takes 5 minutes and makes every other skill smarter.

If something just broke: run `/ds-unstuck`.

If you have a plan in front of you that you don't understand: describe it to me and I'll explain it in plain English before you say yes.
