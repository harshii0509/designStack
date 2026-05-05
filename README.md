# designStack

**Claude Code for designers building their own products.**

Every session starts over. Claude doesn't know your colors or fonts. Plans come back in jargon you just say yes to. Something breaks and "fix it" makes it worse.

One setup wizard fixes this. Your **Design Bible** captures your brand — colors, fonts, spacing, rules — in a file Claude reads automatically, every session.

You never explain your brand to Claude again.

---

## Install

Requires [Claude Code](https://claude.ai/code).

**Via npx (recommended):**

```bash
npx skills@latest add harshii0509/designStack
```

**Via curl:**

```bash
curl -fsSL https://raw.githubusercontent.com/harshii0509/designStack/main/install | bash
```

Installs to `~/.claude/skills/ds/`. Quit and reopen Claude Code, then type `/ds:start` in the chat input.

---

## How it works

`/ds:start` asks a few questions and writes `design/DESIGN-BIBLE.md` — your brand's colors, fonts, spacing, and rules in one file. Every skill reads from it automatically. No re-explaining. No starting over.

---

## What you can do

**When things go sideways**

| Command | What it does |
|---------|--------------|
| `/ds:unstuck` | Something broke and "fix it" isn't working — one sentence diagnosis, one fix |
| `/ds:save` | Save exactly where you are so you can always come back |

**When checking how it looks**

| Command | What it does |
|---------|--------------|
| `/ds:look` | Does this match what you had in your head? Scored against your Design Bible |
| `/ds:mobile` | Phone, tablet, desktop — side by side |
| `/ds:a11y` | Accessibility grade A–D, every issue labeled |

**When setting the direction**

| Command | What it does |
|---------|--------------|
| `/ds:vibe` | Tell me how it should feel — get 3 visual directions to pick from |
| `/ds:brand` | Is this still on brand after all those changes? Full-site scan |
| `/ds:context` | Refresh your Design Bible when your brand evolves |

**When making it great**

| Command | What it does |
|---------|--------------|
| `/ds:polish` | Pre-ship check across 11 areas, results in plain English |
| `/ds:animate` | Add motion that feels natural, not flashy |
| `/ds:delight` | Add joy to the moments that matter most |

**When sharing your work**

| Command | What it does |
|---------|--------------|
| `/ds:share` | Shareable link in under 2 minutes |
| `/ds:stats` | Which skills you've used, how often, and whether they worked |

**Keeping designStack up to date**

| Command | What it does |
|---------|--------------|
| `/ds:upgrade` or `/ds:update` | Pull the latest release from GitHub (you may also get a heads-up when you run any `/ds:*` command) |

---

## How it's built

Each skill is a `SKILL.md` file — prose instructions the AI reads and follows. Shared behaviour lives in `lib/`:

| File | What it does |
|------|--------------|
| `lib/env.sh` | Single preamble all skills run first: detects the Design Bible, browse binary, git root, and fires the upgrade check |
| `lib/telemetry-end.sh` | Shared completion logging — reads the session file written by `env.sh` |
| `lib/bible-reader.md` | Standard protocol for extracting vibe, colors, fonts, and recent decisions from the Design Bible |
| `lib/visual-audit.sh` | Shared screenshot, "not running" message, and Memory Log helpers for the five visual-audit skills |
| `lib/plain-language.md` | Jargon substitution table — every skill that proposes a plan references this so output is always plain English |

---

## Works with

Claude Code (primary) · Cursor (via `.cursor/rules/`) · Codex CLI (via `AGENTS.md`) · Any [Agent Skills](https://agentskills.io)-compatible agent

---

## Questions

[GitHub Discussions](https://github.com/harshii0509/designStack/discussions) — we read everything.

---

Made for everyone who has a great idea but felt locked out by the tools. MIT.
