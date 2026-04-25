# designStack — Claude Code for designers building their own products.

> Built for designers who are tired of asking engineers for help.

---

## Why this exists

**The tools are incredible. But they're built for people who already know how to use them.**

You're a designer. You know exactly what you want to build. You open Claude Code, describe what you need, and Claude writes a plan. You don't understand half the words in it. You click yes.

Something breaks.

You ask Claude to fix it. Something else breaks. You close the laptop.

designStack fixes the moment before you click yes.

It translates any Claude plan into plain English before a line of code changes. It saves your brand colors, fonts, and design rules so every session starts with full context. It gives you a restore point before anything risky — and tells you exactly what to do when something breaks.

No engineering background needed. Just your design sense and the product you're building.

---

## The four principles

Before the commands, the mindset. designStack is built around four principles for working with AI as a designer. Read them once — they'll change how every session goes.

| Principle | The short version |
|-----------|------------------|
| **Think in references, not descriptions** | "Make it modern" is useless. Show Claude what you mean. |
| **Write the Bible once** | Stop re-explaining your brand every session. Run `/ds:context` once. |
| **Read before you say yes** | Don't approve a plan you can't read. Run `/ds:plain` first. |
| **Save before you fly** | `/ds:save` before every session that touches your code. |

[Read the full principles →](PRINCIPLES.md)

---

## Without it vs. with it

**Without designStack:**

> "Make the hero section look better"  
> *Claude rewrites the whole layout. It's not what you meant. You spend 20 minutes trying to explain the difference.*

> "Fix the button"  
> *Claude writes a plan full of file names and function calls. You don't understand it. You click yes. Something unrelated breaks.*

> Every new session: re-explain your brand colors, fonts, what "minimal" means to you.

**With designStack:**

> `/ds:look` → "Hero heading is 48px on mobile — your Design Bible says max 32px. Fix it?"  
> One clear problem. One fix to approve. Done.

> `/ds:plain` → "Claude wants to change how your button looks by editing one CSS class. It will only affect the checkout page."  
> You understand it. You say yes.

> `/ds:context` → Brand Bible written once. Claude knows your colors, fonts, and rules in every future session. You never explain them again.

---

## What it looks like

```
Running /ds:plain on the current plan...

────────────────────────────────────────────
Here's what's about to happen, in plain English:

What we're changing:
The checkout button will move to a fixed position at the bottom of
the screen so it's always visible while users scroll.

What will CHANGE:
• The "Buy Now" button position — from the middle of the page
  to a bar that sticks to the bottom of the browser window

What will be ADDED:
• A thin shadow above the sticky bar to show it's floating

What will be REMOVED:
• Nothing is being deleted in this step.

How big is this change?
Small tweak — quick to do, easy to undo if anything goes wrong.

Does this match what you had in mind?
A) Yes, go ahead
B) No, let me describe what I actually want
C) Wait — tell me more about the sticky bar
────────────────────────────────────────────
```

---

## What it does

| Command | What it does |
|---------|--------------|
| `/ds:start` | First-session wizard — 3 questions, sets up everything in 5 minutes |
| `/ds:plain` | Translates any plan to plain English before you say yes |
| `/ds:unstuck` | Diagnoses what broke in one sentence — then one fix to approve |
| `/ds:save` | Restore point before any risky change — like hitting Save in a game |
| `/ds:look` | Checks your live site against your brand rules and flags what drifted |
| `/ds:mobile` | Checks your site on phone, tablet, and desktop side-by-side |
| `/ds:a11y` | Accessibility grade A–D — every problem shown in plain English |
| `/ds:context` | Builds your Design Bible once — Claude knows your brand in every future session |
| `/ds:share` | Shareable link in under 2 minutes |
| `/ds:vibe` | Set the look and feel from feeling words — get three directions to choose from |
| `/ds:brand` | Drift check across your whole site — flags what stopped matching your rules |
| `/ds:polish` | Pre-ship quality check — 11 areas, plain English results |
| `/ds:animate` | Add purposeful motion that feels natural, not flashy |
| `/ds:delight` | Add joy to the moments that matter most |

---

## Install

**Requires:** [Claude Code](https://claude.ai/download) installed first. (Free to download.)

### Step 1 — Open Claude Code.
### Step 2 — Paste this. Claude does the rest.

```
Install designStack: run `git clone https://github.com/harshii0509/designStack.git ~/.claude/skills/ds` and then run `~/.claude/skills/ds/setup --quiet`. Then add a "designStack" section to ~/.claude/CLAUDE.md listing all 14 skills with plain-English descriptions. Then ask: "Would you also like to add designStack to this project's CLAUDE.md so it's ready for anyone who works on it?" If yes, append the designStack section to ./CLAUDE.md in the current directory (create it if missing). Then tell them to type /ds:start.
```

Claude will clone designStack, run setup, update your global settings, and ask if you want to add it to your current project too. You never need to open Terminal.

> The full install prompt is also at [`INSTALL_PROMPT.md`](INSTALL_PROMPT.md) if you want to copy it from the repo directly.

---

**Prefer Terminal?** If you're comfortable with the command line:

```bash
# Via curl
curl -fsSL https://raw.githubusercontent.com/harshii0509/designStack/main/install | bash

# Via npx skills (Agent Skills ecosystem)
npx skills add harshii0509/designStack
```

**On Windows** — works via WSL. [Step-by-step guide here](docs/windows.md). Native Windows support coming in v0.2.

**Using another agent (Cursor, Cline, Windsurf)?** designStack follows the [Agent Skills](https://agentskills.io) open standard. Install via `npx skills add harshii0509/designStack` and the skills work across any compatible agent.

---

## Works with

| Agent | How to use |
|-------|-----------|
| **Claude Code** | Install via the paste prompt above. Full `/ds:*` skill commands. |
| **Cursor** | Copy `.cursor/rules/` from this repo to your project. Or run `/ds:context` in Claude Code — it adds Cursor rules automatically if you have a `.cursor/` folder. |
| **Codex CLI** | `AGENTS.md` is written to your project when you run `/ds:context`. Or copy `AGENTS.md` from this repo directly. |
| **Cline / Continue / Windsurf** | `npx skills add harshii0509/designStack` — the Agent Skills spec is supported natively. |

---

## Your first 5 minutes

After installing, open Claude Code in your project folder and type:

```
/ds:start
```

The wizard asks you 3 questions about your product — what it does, how it should feel, what your brand color is. Then it sets up your Design Bible automatically. Every other designStack command works from that point on.

You never have to explain your brand again.

---

## All commands

### Get started
| Command | What it does |
|---------|--------------|
| `/ds:start` | First-session wizard. Run once, sets up everything. Takes 5 minutes. |
| `/ds:context` | Refresh your Design Bible. Run when your brand changes. |

### When things go wrong
| Command | What it does |
|---------|--------------|
| `/ds:plain` | Shows you exactly what Claude is about to do in plain English, before a single line of code is touched. |
| `/ds:unstuck` | Something broke. Get a one-sentence diagnosis and one fix — no spiraling. |
| `/ds:save` | Create a restore point. Like hitting Save in a game — you can always come back. |

### Check how it looks
| Command | What it does |
|---------|--------------|
| `/ds:look` | Does it look right? Score out of 10 with your brand issues labeled on a screenshot. |
| `/ds:mobile` | See your site on phone, tablet, and desktop side-by-side. Every broken thing flagged. |
| `/ds:a11y` | Accessibility grade A–D. Every problem shown on an annotated screenshot, in plain English. |

### Set the direction
| Command | What it does |
|---------|--------------|
| `/ds:vibe` | Describe how it should feel — get three visual directions to choose from. |
| `/ds:brand` | Full-site drift check. Flags everything that stopped matching your rules. |

### Make it great
| Command | What it does |
|---------|--------------|
| `/ds:polish` | Pre-ship quality check — 11 areas, plain English results. |
| `/ds:animate` | Add purposeful motion without writing animation code. |
| `/ds:delight` | Add joy to the moments that matter most. |

### Share your work
| Command | What it does |
|---------|--------------|
| `/ds:share` | Get a shareable preview link or go live — step-by-step, no deployment experience needed. |

### Keep it up to date
| Command | What it does |
|---------|--------------|
| `/ds:update` | Pull the latest version of designStack. |

---

## The Design Bible

Every designStack project gets a file at `design/DESIGN-BIBLE.md`. It holds everything about your product's look and feel:

```
- Your brand colors (exact hex codes)
- Your fonts and type sizes
- Your spacing rules
- How your buttons, cards, and forms should look
- Which screens have been reviewed and which haven't
```

Every designStack command reads from this file automatically. When `/ds:look` checks your site, it's checking against your Design Bible. When `/ds:a11y` runs, it knows what your design was supposed to look like.

You build it once with `/ds:start`. You never have to explain your brand to Claude again.

designStack also writes a compact version of your rules into your project's `CLAUDE.md` — so even outside of designStack skill runs, Claude knows your brand colors and fonts in every session.

**Using shadcn, Tailwind, or Blend?** `/ds:context` reads your existing design tokens and pre-fills your Design Bible automatically. No manual entry.

---

## Philosophy

- **Show, don't describe** — a reference beats a thousand adjectives
- **Translate, don't assume** — every error tells you what to do next, not just what went wrong
- **Save before you fly** — every command that touches your project saves first
- **Read before you click yes** — if you can't understand the plan, you're not ready to approve it

---

## What's coming in v0.2

- Native Windows support (no WSL required)

---

## Contribute

designStack is open source and actively maintained. Contributions of all kinds are welcome — you don't need to write code.

**The highest-leverage thing you can do:** read through a skill file and tell us if any part of it sounds too technical. Our users have zero engineering background. If something reads like a dev doc, it needs to be rewritten.

[CONTRIBUTING.md](CONTRIBUTING.md) has everything you need to get started.

---

## Community & support

**Questions, ideas, show-and-tell:**
[GitHub Discussions](https://github.com/harshii0509/designStack/discussions) — ask anything. We read everything.

**Found a bug:**
[Open an issue](https://github.com/harshii0509/designStack/issues) — describe what you typed, what you expected, what happened.

**Built something with designStack:**
Drop it in Discussions. We want to see what you're making.

---

## FAQ

**Do I need to know how to code?**
No. designStack is built for people who don't code and don't want to learn. Every command is in plain English. Every error message tells you exactly what to do.

**Is my code sent anywhere?**
designStack runs entirely on your machine. Your code stays local. Claude processes your descriptions and answers your questions — your files are only read when you explicitly ask it to check something.

**What's a Design Bible?**
A file designStack creates at `design/DESIGN-BIBLE.md` in your project. It holds your brand rules — colors, fonts, spacing, and how your components should look. Every designStack skill reads from it automatically. Run `/ds:start` once and Claude knows your brand in every future session.

**Does designStack work on an existing project?**
Yes. Run `/ds:start` in any project folder — new or existing. If you already have design tokens (shadcn, Tailwind, Blend), designStack reads them automatically.

---

## License

MIT. Fork it, make it better, build something.

---

*Made for everyone who has a great idea but felt locked out by the tools.*
