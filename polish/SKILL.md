---
name: ds-polish
version: 0.2.0
description: >
  Runs 11 quality checks across the full UI — layout, colors, fonts, accessibility,
  mobile — and produces a prioritized fix list before launch. Use when the user
  wants a final pre-launch review or runs '/ds-polish'.
license: MIT
allowed-tools:
  - Bash
  - Read
  - AskUserQuestion
compatibility: Requires browse binary for visual checks and axe-core injection. Falls back to code-only audit without it.
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
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/DesignBrain.md" ] && _HAS_BIBLE="yes"
_B=""
[ -x "$HOME/.claude/skills/ds/browse/dist/browse" ] && _B="$HOME/.claude/skills/ds/browse/dist/browse"
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "DESIGN_BIBLE: $_HAS_BIBLE"
echo "BROWSE: ${_B:-NOT_FOUND}"
_TEL_START=$(date +%s)
_SESSION_ID="$$-$(date +%s)"
mkdir -p "$HOME/.dstack/analytics"
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"polish","event":"started","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
```

## What this skill does

Think of this as the final check before you hit publish. I'll look at your site through 11 different lenses — from "does it look good?" to "can everyone use it?" — and tell you exactly what to fix before sharing with the world.

Takes about 3–5 minutes.

> "Checking 11 areas before you share this. Takes 3–5 minutes. I'll tell you what needs fixing and what's already great."

## Step 1 — Get the URL

Ask:
> "What's the URL of the page you want to polish? (e.g. `http://localhost:3000` or your live site). If you want me to check multiple pages, list them all."

## Step 2 — Load context

If `DESIGN_BIBLE` is `yes`, read it for brand rules.
Note from Memory Log any recent confirmed intentional changes.

## Step 3 — Run all 11 checks

For each check, take a screenshot and extract what you need. Describe findings in plain English.

---

**Check 1 — Does it look right?**
Take a screenshot. Compare against Design Bible. Are the colors, fonts, and spacing correct?
*Plain English output: "Your colors are on brand." / "The heading font is different from your brand font."*

**Check 2 — Is the layout balanced?**
Squint test: does the page feel balanced, or does something look heavy/light/off-center?
Check for obvious alignment issues — text that doesn't line up, elements that feel randomly placed.
*Plain English: "The layout feels balanced and intentional." / "The left column feels much heavier than the right."*

**Check 3 — Is the text readable?**
Font sizes: is body text at least 16px? Are headings clearly larger than body?
Line height: is text too cramped (line-height under 1.4) or too spread out (over 1.8)?
Line length: are text blocks very wide (over 80 characters per line is hard to read)?
*Plain English: "Text is easy to read." / "The paragraph text is a bit small — 14px instead of 16px."*

**Check 4 — Do the colors work together?**
Check the 60/30/10 rule: background is dominant, secondary color fills middle areas, accent pops only on the most important things.
Check contrast: can you read all the text clearly?
*Plain English: "Colors work well together." / "Your accent color is used too much — it stops standing out."*

**Check 5 — Are buttons obvious?**
Is there one clear primary action on the page? Does it stand out?
Are secondary buttons clearly less important-looking?
Do buttons look clickable? (right size, visible, labeled clearly)
*Plain English: "Your main button stands out clearly." / "There are 4 buttons that all look equally important — users won't know where to click first."*

**Check 6 — Does it work on phones?**
```bash
$B resize 375 812
$B goto <URL>
$B screenshot /tmp/dstack-polish-mobile.png
$B js "document.body.scrollWidth > window.innerWidth"
```
*Plain English: "Looks good on phones." / "Content is overflowing off the right edge of the phone screen."*

**Check 7 — Can people use it without a mouse?**
```bash
$B js "document.querySelectorAll('[tabindex], a, button, input, select, textarea').length"
```
Can all interactive elements be reached by pressing Tab?
Is there a visible focus ring when you tab through?
*Plain English: "Keyboard navigation works." / "The keyboard focus indicator is invisible — people can't see where they are when navigating without a mouse."*

**Check 8 — Does it load fast enough?**
```bash
$B js "JSON.stringify({domContentLoaded: performance.timing.domContentLoadedEventEnd - performance.timing.navigationStart, images: document.querySelectorAll('img').length, largeImages: Array.from(document.querySelectorAll('img')).filter(i => i.naturalWidth > 2000).length})"
```
Flag: DOM load over 3 seconds, images larger than 2000px wide, more than 20 images on one page.
*Plain English: "Page loads quickly." / "You have 3 very large images that are slowing things down."*

**Check 9 — Does every image have a description?**
```bash
$B js "Array.from(document.querySelectorAll('img')).filter(i => !i.alt || i.alt.trim() === '').map(i => i.src.split('/').pop()).slice(0,5)"
```
*Plain English: "All images have descriptions for blind users." / "3 images have no description — blind users won't know what they show."*

**Check 10 — Are there any empty states?**
What does the page look like when there's no data? (Empty cart, no search results, first-time user with nothing yet)
Does the page handle this gracefully, or does it look broken?
*Plain English: "Empty states are handled." / "When the list is empty, the page looks broken — consider adding a friendly message."*

**Check 11 — Are forms easy to fill out?**
(Skip if no forms on the page)
Does every input have a label above it saying what it's for?
Is there a clear error message when something is wrong?
Is the submit button obvious?
*Plain English: "Forms are easy to fill out." / "The email field label disappears when you start typing — users forget what they're filling in."*

---

## Step 4 — Write the polished report

---

**Pre-launch check for [URL]**

**Overall: [Ready to share / A few things to fix / Needs work before launch]**

Score: [X]/11 checks passed

---

✓ **Already great:**
[List checks that passed — give credit for what's working]

---

⚠️ **Fix before sharing:**

[For each failed check:]
**[Check name]** — [Plain English description of the issue]
*How to fix:* [Specific plain-English fix]
*How long:* [Quick (1 min) / Short (5-10 min) / Takes a while]

---

**My top 3 fixes (do these now):**
1. [Most visible or impactful issue]
2. [Second most important]
3. [Third]

**If you fix just these 3:** [what the result will be]

---

## Step 5 — Offer to fix

> "Want me to fix any of these? Pick the number (1, 2, or 3 from the list above), say 'fix them all', or tell me which specific thing to tackle first."

## Step 6 — After fixing, take an after screenshot

Show before and after at desktop:
```bash
$B goto <URL>
$B screenshot /tmp/dstack-polish-after.png
```

> "Before and after:"
[show /tmp/dstack-polish-before (taken in Step 3)]
[show /tmp/dstack-polish-after]

## Design Bible update

If any issues were fixed that establish new rules, append to Memory Log:
```
[date]: /polish ran on [URL]. Score: [X]/11. Issues fixed: [list]. Rules confirmed: [any new rules].
```

## Completion

Always run this bash before ending, regardless of outcome. Replace `OUTCOME` with: `success`, `error`, or `abort`.

```bash
_TEL_END=$(date +%s)
_TEL_DUR=$(( _TEL_END - _TEL_START ))
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"polish","event":"completed","outcome":"OUTCOME","duration_s":"'"$_TEL_DUR"'","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
"$HOME/.claude/skills/ds/bin/ds-telemetry-log" \
  --skill "polish" --duration "$_TEL_DUR" --outcome "OUTCOME" \
  --session "$_SESSION_ID" 2>/dev/null || true
```

Report completion status: **DONE** / **DONE_WITH_CONCERNS** / **BLOCKED** / **NEEDS_CONTEXT**
