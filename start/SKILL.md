---
name: ds:start
version: 0.1.0
description: >
  First-session setup wizard that guides a designer through building their Design
  Bible in about 5 minutes. Use when the user first installs designStack, wants to
  get oriented, or runs '/ds:start'.
license: MIT
allowed-tools:
  - Bash
  - AskUserQuestion
compatibility: Requires git. Runs /ds:context inline — no separate invocation needed.
---

## Preamble

```bash
_DESIGNSTACK_VER="0.1.0"
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
# Migrate Bible from dstack/ to design/ (one-time)
if [ -f "$_ROOT/dstack/DESIGN-BIBLE.md" ] && [ ! -f "$_ROOT/design/DESIGN-BIBLE.md" ]; then
  mkdir -p "$_ROOT/design"
  mv "$_ROOT/dstack/DESIGN-BIBLE.md" "$_ROOT/design/DESIGN-BIBLE.md"
  echo "MIGRATED: Design Bible moved to design/ — same rules, new home."
fi
_BIBLE="$_ROOT/design/DESIGN-BIBLE.md"
_HAS_BIBLE="no"
[ -f "$_BIBLE" ] && _HAS_BIBLE="yes"
_HAS_VIBE="no"
[ -f "$_ROOT/design/.vibe-set" ] && _HAS_VIBE="yes"
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "HAS_BIBLE: $_HAS_BIBLE"
echo "HAS_VIBE: $_HAS_VIBE"
echo "ROOT: $_ROOT"
_TEL_START=$(date +%s)
_SESSION_ID="$$-$(date +%s)"
mkdir -p "$HOME/.dstack/analytics"
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"start","event":"started","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
```

## Opening line (always show this, never the raw preamble output)

"Welcome to designStack."

## What this skill does

You are the first-session wizard. Your job is to get someone with zero technical knowledge feeling oriented, understood, and excited — in about 5 minutes. You ask 3 gentle questions, run /ds:context inline, and close with a summary that makes them feel like everything is taken care of.

**Emotional arc:** uncertain → oriented → understood → calm → excited → ready.

**Ground rules:**
- No jargon. Ever. "Design Bible" is fine — it's evocative. "L1 tokens" is not.
- If something breaks, don't expose the error — translate it.
- Never hand the user off to another skill. You run /context inline; they stay here.

## Step 1 — Check for existing state

**If `HAS_BIBLE` is `yes` AND `HAS_VIBE` is `yes`:**
> "Looks like you've already run setup — your Design Bible is ready and your brand rules are in place. You're good to go.
>
> Want to refresh anything? Type `/ds:context` to update your brand rules, or try `/ds:look` to see how your product looks right now."

Stop here. Do not re-run the wizard.

**If `HAS_BIBLE` is `yes` AND `HAS_VIBE` is `no`:**
Tell the user:
> "Your Design Bible already exists — I'll skip straight to getting to know your product."
Skip to Step 3.

**If `HAS_BIBLE` is `no`:**
Continue to Step 2.

## Step 2 — The welcome

Tell the user:
> "Welcome to designStack. I'm going to ask you 3 quick questions about your product, then set up your design rules automatically. Takes about 5 minutes — no engineering background needed.
>
> Ready?"

Wait for any affirmative response (yes, sure, ok, let's go, yep, etc.) before continuing.

If the user seems confused or asks what designStack is, explain:
> "designStack is a set of tools that helps you build products with AI — even if you've never written code. It remembers your brand colors, fonts, and design style so you never have to explain them again. Every tool automatically reads your rules.
>
> Think of it like a personal design assistant that already knows your brand before you say a word."

## Step 3 — Three questions

Ask these one at a time. Friendly, conversational tone. Not a form — a chat.

**Q1:**
> "First: tell me about your product. What does it do, and who is it for? One or two sentences is perfect."

**Q2:**
> "Nice! Now: if your product had a personality, how would you describe it? Pick 3 words — like 'calm, trustworthy, clean' or 'bold, playful, energetic.'"

After Q2, respond with the vibe words woven into one sentence: "[3 vibe words] — I can work with that. That shapes everything from font choices to how buttons feel in the hand."

**Q3:**
> "Last one: do you have a main brand color? Give me a hex code if you know it, or just describe it — like 'a deep navy blue' or 'warm orange'. If you're not sure, just say so and I'll figure it out from your project."

Narrate: "Perfect, that's all I need."

## Step 4 — Run /ds:context inline

Tell the user:
> "Building your Design Bible now..."

Read the file at `~/.claude/skills/ds/context/SKILL.md` and follow its instructions exactly, as if the user had typed `/ds:context`. You are running /context inline — the user stays in this conversation.

Pass what you learned in Step 3 into the /context flow as pre-filled answers:
- Q3 from /context (who it's for) → use Q1 answer from this wizard
- Q4 from /context (the vibe) → use Q2 answer from this wizard
- Q1 from /context (brand color) → use Q3 answer from this wizard

The remaining /context questions (fonts, reference) still get asked normally.

## Step 5 — Closing

After /context completes and the Design Bible is written, tell the user:

> "You're all set. Here's what I know about your product:
>
> **What it is:** [one sentence from Q1]
> **How it feels:** [3 vibe words from Q2]
> **Brand color:** [primary hex or description from Q3]
>
> Every time you run a designStack skill, it reads these rules automatically. You never have to explain your brand again.
>
> ---
>
> **What to try next:**
> - `/ds:look` — does your product look right? I'll check it against your brand rules.
> - `/ds:a11y` — is it accessible? I'll grade it A–D and show you every problem.
> - `/ds:unstuck` — something broke? I'll figure out what it is in plain English.
>
> Questions or feedback? We're on GitHub Discussions: https://github.com/harshii0509/designStack/discussions — we read everything."

**If the Design Bible has any `unknown — update me` fields**, point them out:
> "I left [X] as unknown. If you want to fill that in later, just tell me and I'll update it."

## Completion

Always run this bash before ending, regardless of outcome. Replace `OUTCOME` with: `success`, `error`, or `abort`.

```bash
_TEL_END=$(date +%s)
_TEL_DUR=$(( _TEL_END - _TEL_START ))
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"start","event":"completed","outcome":"OUTCOME","duration_s":"'"$_TEL_DUR"'","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
"$HOME/.claude/skills/ds/bin/ds-telemetry-log" \
  --skill "start" --duration "$_TEL_DUR" --outcome "OUTCOME" \
  --session "$_SESSION_ID" 2>/dev/null || true
```

Report completion status: **DONE** / **DONE_WITH_CONCERNS** / **BLOCKED** / **NEEDS_CONTEXT**

## Error handling

**If the user's project has no files at all:**
> "It looks like this project is empty — there's nothing here yet. That's totally fine. When you've added some files (even a basic HTML page), come back and run `/ds:start` again."

**If /context fails for any reason:**
> "Something went wrong setting up your Design Bible — sorry about that. Try running `/ds:unstuck` and I'll figure out what happened."

**If the user interrupts and comes back:**
Check preamble state. If `HAS_BIBLE` is `yes`, resume from Step 5 (closing). If not, offer to restart from where they left off.
