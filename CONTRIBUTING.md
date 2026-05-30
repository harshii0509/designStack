# Contributing to designStack

designStack is open source and contributions are welcome. You don't need to be a technical expert to help — improving skill language, writing clearer plain-English messages, and filing bugs are just as valuable as writing code.

---

## What we're building

designStack is for people who have never written code. Every design decision should be evaluated through that lens: **would someone with zero tech background understand this?**

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

Skills live in this repo as `<skill-name>/SKILL.md` plus shared helpers in `lib/`. The installed Claude Code path is still `~/.claude/skills/ds/`, but most runtime skill instructions are now written bundle-relative so they also work when evaluated directly from the repo.

If something reads as too technical, too confusing, or just unclear — open a PR. Skill language improvements are the highest-leverage changes in this repo.

**Test your change:**
- Run `bin/designStack-validate`
- Run `bin/designStack-eval`
- Run `bash -n` on any touched shell script
- If you changed a user-facing skill, open Claude Code and walk through the full flow

The skill should feel like talking to a helpful friend, not reading a manual.

### Adding a new skill

Skills follow this structure:

```
<skill-name>/SKILL.md
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

### Runtime structure

designStack now has two kinds of files:

- **Portable runtime files** — the root `SKILL.md`, public skills, and shared runtime helpers. These should prefer bundle-relative references like `../lib/env.sh` or `upgrade/SKILL.md`.
- **Install-specific files** — setup, install, upgrade, updater, and telemetry sync scripts. These are allowed to reference `~/.claude/skills/ds` because they manage the real install location.

If you touch runtime files, do not reintroduce hardcoded install-path assumptions unless the file is intentionally install-specific.

### skills.sh packaging

designStack is also packaged for the open skills ecosystem.

- `agents/openai.yaml` is the UI metadata for marketplace-style skill lists and chips. Keep it short, user-facing, and aligned with the root `SKILL.md`.
- `skills.sh.json` only curates how the repository page is grouped on skills.sh. It does not change install behavior, routing, or runtime behavior.
- Curated groups should only include public skills. Do not promote internal-only or de-emphasized skills like `supabase` or `stats` there unless the product surface changes intentionally.

### Local checks

Before opening a PR, run:

```bash
bin/designStack-validate
bin/designStack-eval
```

If you touched shell scripts, also run:

```bash
bash -n path/to/script
```

These checks are the fastest way to catch:
- routing overlap between skills
- stale command syntax or old marker formats
- portability regressions
- missing fallback language
- public-surface drift
- broken skills.sh packaging metadata or invalid curated groupings

### Before submitting a PR

- [ ] The skill's opening line never shows raw bash output
- [ ] All error messages are in plain English with a recovery action
- [ ] Technical terms are translated on first use
- [ ] The skill works in text-only mode (no browse) with graceful fallback
- [ ] `bin/designStack-validate` passes
- [ ] `bin/designStack-eval` passes
- [ ] Any touched shell scripts pass `bash -n`
- [ ] If I changed routing, portability, or fallback behavior, I verified that explicitly
- [ ] Any new skill is listed in README.md and CHANGELOG.md

---

## Questions?

**GitHub Discussions:** https://github.com/harshii0509/designStack/discussions

We read everything. No question is too small.
