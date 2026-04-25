# Contributing to dStack

dStack is open source and contributions are welcome. You don't need to be a technical expert to help — improving skill language, writing clearer plain-English messages, and filing bugs are just as valuable as writing code.

---

## What we're building

dStack is for people who have never written code. Every design decision should be evaluated through that lens: **would someone with zero tech background understand this?**

The three rules from the README apply here too:
- **Show, don't tell** — screenshots over code dumps
- **Translate, don't assume** — plain English throughout, no unexplained jargon
- **Save constantly** — every skill checkpoints before touching anything risky

---

## How to contribute

### Reporting a bug

Open an issue: https://github.com/harshii0509/designStack/issues

Describe:
1. What you typed
2. What you expected to happen
3. What actually happened
4. Paste any error message

### Improving skill language

Skills live in `~/.claude/skills/dstack/<skill-name>/SKILL.md`. Each one is a markdown file with instructions for Claude to follow.

If something reads as too technical, too confusing, or just unclear — open a PR. Skill language improvements are the highest-leverage changes in this repo.

**Test your change:** Open Claude Code, type the skill command, and go through the full flow. The skill should feel like talking to a helpful friend, not reading a manual.

### Adding a new skill

Skills follow this structure:

```
dstack/<skill-name>/SKILL.md
```

The SKILL.md file needs:
1. A frontmatter block (`name`, `version`, `description`)
2. A preamble bash block (environment detection — copy from an existing skill and adapt)
3. An opening line that shows instead of the raw preamble output
4. Numbered steps

Rules for new skills:
- Every skill must have a "local server not running" error state if it accesses a URL
- Every skill that produces a report must have a progressive disclosure gate (verdict first, full report on request)
- No jargon. If you must use a technical term, translate it inline on first use.
- The skill never writes code until the user explicitly says yes.

### Before submitting a PR

- [ ] The skill's opening line never shows raw bash output
- [ ] All error messages are in plain English with a recovery action
- [ ] Technical terms are translated on first use
- [ ] The skill works in text-only mode (no browse) with graceful fallback
- [ ] Any new skill is listed in README.md and CHANGELOG.md

---

## Questions?

**GitHub Discussions:** https://github.com/harshii0509/designStack/discussions

We read everything. No question is too small.
