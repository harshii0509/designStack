# designStack — Claude Code for people who think in pixels, not pull requests.

> Built by a designer who got tired of asking engineers for help.

---

## Why this exists

I kept watching the same thing happen.

A designer or founder gets access to Claude Code, excited to finally build their own product without depending on a developer. They open it up. It asks them to type a command. They type something. Claude responds with a wall of text — file paths, function names, a "refactoring plan" they don't understand. They click yes. Something breaks. They ask Claude to fix it. Something else breaks. They close the laptop.

**The tools are incredible. But they're built for people who already know how to use them.**

designStack fixes that. It's a set of 9 slash commands built specifically for designers, no-code builders, and non-technical founders. Every command speaks plain English. Every error message tells you exactly what to do next. Nothing is hidden behind jargon.

You don't need to know what a pull request is. You don't need to understand git. You just need to know what you're trying to build.

---

## What it does

| Problem you've had | What designStack does |
|--------------------|-----------------|
| Claude writes a plan in tech-speak. You say yes. It builds the wrong thing. | `/designStack:plain` translates any plan into plain English before you accept it |
| Something breaks. You ask Claude to fix it. New error. You give up. | `/designStack:unstuck` gives you a one-sentence diagnosis and one fix to approve |
| Your site slowly stops looking like your design. Nobody tells you. | `/designStack:look` compares your live site to your brand rules and shows you what drifted |
| Every Claude session, it forgets your brand colors and fonts. | `/designStack:context` builds a Design Bible — Claude reads it every session automatically |
| A client asks if your site is accessible. You have no idea. | `/designStack:a11y` gives you an A–D grade and shows every problem on a screenshot |
| You want to share your work but deployment is scary. | `/designStack:share` gets you a shareable link in under 2 minutes |

---

## Install

**Requires:** [Claude Code](https://claude.ai/download) installed first. (Free to download.)

### Step 1 — Open Claude Code.
### Step 2 — Paste this. Claude does the rest.

```
Install designStack: run `git clone https://github.com/harshii0509/designStack.git ~/.claude/skills/designStack` and then run `~/.claude/skills/designStack/setup --quiet`. Then add a "designStack" section to ~/.claude/CLAUDE.md listing all 9 skills with plain-English descriptions. Then ask: "Would you also like to add designStack to this project's CLAUDE.md so it's ready for anyone who works on it?" If yes, append the designStack section to ./CLAUDE.md in the current directory (create it if missing). Then tell them to type /designStack:start.
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

**Optional:** Install [gstack](https://github.com/garrytan/gstack) for screenshot and annotation features. Not required — every command works in text-only mode without it.

---

## Your first 5 minutes

After installing, open Claude Code in your project folder and type:

```
/designStack:start
```

The wizard asks you 3 questions about your product — what it does, how it should feel, what your brand color is. Then it sets up your Design Bible automatically. Every other designStack command works from that point on.

You never have to explain your brand again.

---

## All commands

### Get started
| Command | What it does |
|---------|--------------|
| `/designStack:start` | First-session wizard. Run once, sets up everything. Takes 5 minutes. |
| `/designStack:context` | Refresh your Design Bible. Run when your brand changes. |

### When things go wrong
| Command | What it does |
|---------|--------------|
| `/designStack:plain` | Shows you exactly what Claude is about to do in plain English, before a single line of code is touched. |
| `/designStack:unstuck` | Something broke. Get a one-sentence diagnosis and one fix — no spiraling. |
| `/designStack:save` | Create a restore point. Like hitting Save in a game — you can always come back. |

### Check how it looks
| Command | What it does |
|---------|--------------|
| `/designStack:look` | Does it look right? Score out of 10 with your brand issues labeled on a screenshot. |
| `/designStack:mobile` | See your site on phone, tablet, and desktop side-by-side. Every broken thing flagged. |
| `/designStack:a11y` | Accessibility grade A–D. Every problem shown on an annotated screenshot, in plain English. |

### Share your work
| Command | What it does |
|---------|--------------|
| `/designStack:share` | Get a shareable preview link or go live — step-by-step, no deployment experience needed. |

### Keep it up to date
| Command | What it does |
|---------|--------------|
| `/designStack:update` | Pull the latest version of designStack. |

---

## The Design Bible

Every designStack project gets a file at `dstack/DESIGN-BIBLE.md`. It holds everything about your product's look and feel:

```
- Your brand colors (exact hex codes)
- Your fonts and type sizes
- Your spacing rules
- How your buttons, cards, and forms should look
- Which screens have been reviewed and which haven't
```

Every designStack command reads from this file automatically. When `/designStack:look` checks your site, it's checking against your Design Bible. When `/designStack:a11y` runs, it knows what your design was supposed to look like.

You build it once with `/designStack:start`. You never have to explain your brand to Claude again.

designStack also writes a compact version of your rules into your project's `CLAUDE.md` — so even outside of designStack skill runs, Claude knows your brand colors and fonts in every session.

**Already using DesignBrain.md** (from [@heysolacy](https://heysolacy.com))? designStack reads it automatically and extends it. Compatible from day one.

**Using shadcn, Tailwind, or Blend?** `/designStack:context` reads your existing design tokens and pre-fills your Design Bible automatically. No manual entry.

---

## Philosophy

> gstack is for builders who can read a code review.  
> designStack is for builders who can't — and shouldn't have to.

Three rules everything here is built around:

- **Show, don't tell** — screenshots and plain English, not terminal output
- **Translate, don't assume** — every error message tells you what to do next, not just what went wrong
- **Save constantly** — every command that touches your project asks you to save first

---

## What's coming in v0.2

- `/designStack:vibe` — Set your brand personality in 2 minutes
- `/designStack:brand` — Drift check across your whole site at once
- `/designStack:polish` — Final quality pass before sharing with a client
- `/designStack:animate` — Add purposeful motion without writing animation code
- `/designStack:delight` — Micro-interactions and personality touches
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

**Do I need gstack?**
No. Visual features (screenshots, annotated images) use gstack's browser if installed — but every command works in text mode without it. designStack will say "I'll describe what I found instead of showing a screenshot" when it can't take one.

**Is my code sent anywhere?**
designStack runs entirely on your machine. Your code stays local. Claude processes your descriptions and answers your questions — your files are only read when you explicitly ask it to check something.

**What's a Design Bible?**
A file designStack creates at `dstack/DESIGN-BIBLE.md` in your project. It holds your brand rules — colors, fonts, spacing, and how your components should look. Every designStack skill reads from it automatically. Run `/designStack:start` once and Claude knows your brand in every future session.

**Can I use designStack alongside gstack?**
Yes. They're designed to coexist. If you have a `gstack/DESIGN.md` file, designStack reads it and builds your Design Bible from it. If you use gstack's browse tool, designStack uses it automatically for screenshots.

**Does designStack work on an existing project?**
Yes. Run `/designStack:start` in any project folder — new or existing. If you already have design tokens (shadcn, Tailwind, Blend), designStack reads them automatically.

---

## License

MIT. Fork it, make it better, build something.

---

*Made for everyone who has a great idea but felt locked out by the tools.*
