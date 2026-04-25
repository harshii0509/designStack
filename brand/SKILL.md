---
name: ds:brand
version: 0.1.0
description: Is your site still on brand? Scan every page against your Design Bible rules — colors, fonts, spacing — and flag anything that's drifted. Get an annotated screenshot of the problems.
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
_BIBLE_SOURCE=""
[ -f "$_BIBLE" ] && _HAS_BIBLE="yes" && _BIBLE_SOURCE="design/DESIGN-BIBLE.md"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/DesignBrain.md" ] && _HAS_BIBLE="yes" && _BIBLE_SOURCE="DesignBrain.md"
_B=""
[ -x "$HOME/.claude/skills/gstack/browse/dist/browse" ] && _B="$HOME/.claude/skills/gstack/browse/dist/browse"
[ -z "$_B" ] && [ -x "$HOME/.claude/skills/ds/browse/dist/browse" ] && _B="$HOME/.claude/skills/ds/browse/dist/browse"
_LAST_COMMIT=$(git log -1 --pretty=format:"%h — %s" 2>/dev/null || echo "no history")
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "DESIGN_BIBLE: $_HAS_BIBLE | source: ${_BIBLE_SOURCE:-none}"
echo "BROWSE: ${_B:-NOT_FOUND}"
echo "LAST_COMMIT: $_LAST_COMMIT"
```

## What this skill does

Check if everything still looks like it belongs to the same product. As you build over time, small things drift — a button becomes the wrong shade, a font switches, padding gets inconsistent. This scan catches all of that and shows you exactly where, so you can decide what to fix.

**Requires a Design Bible.** If none exists, run `/ds:context` first.

## Step 1 — Check for Design Bible

If `DESIGN_BIBLE` is `no`:
> "I need your Design Bible to run a brand check — it's the set of rules I compare everything against. You haven't set one up for this project yet.
>
> Run `/ds:context` first — it takes about 5 minutes to set up. After that, `/ds:brand` will know exactly what to look for."

Stop here if no Bible.

If `DESIGN_BIBLE` is `yes`, read the full Bible. Extract every rule:
- L1: exact hex values for all colors, exact font families, spacing scale, radius values
- L4: component-level rules (button colors, card styles, nav style)
- Memory Log: note any recent intentional changes so you don't flag them as drift

## Step 2 — Get the pages to check

Ask the user:
> "Which pages should I check? I can:
> A) Check your main page only (fastest — 2 minutes)
> B) Check 3–5 pages you tell me (thorough)
> C) Check everything I can find (most thorough — might take a while)
>
> What's your URL? (e.g. `http://localhost:3000`)"

If they say C, discover pages by:
```bash
$B goto <base URL>
$B links
```
Collect up to 8 unique internal URLs to check.

## Step 3 — Scan each page

For each page URL, run:

```bash
$B goto <URL>
$B screenshot /tmp/dstack-brand-[page-name].png

# Extract computed CSS values for key elements
$B css body background-color
$B css body color
$B css body font-family
$B css h1 font-family
$B css h1 color

# Check button styles
$B js "const btn = document.querySelector('button, [role=button], .btn, a.button'); btn ? JSON.stringify({bg: getComputedStyle(btn).backgroundColor, color: getComputedStyle(btn).color, radius: getComputedStyle(btn).borderRadius, font: getComputedStyle(btn).fontFamily}) : 'no button found'"

# Check card/panel styles
$B js "const card = document.querySelector('.card, [class*=card], [class*=panel], section'); card ? JSON.stringify({bg: getComputedStyle(card).backgroundColor, border: getComputedStyle(card).border, radius: getComputedStyle(card).borderRadius, padding: getComputedStyle(card).padding}) : 'no card found'"

# Check navigation
$B js "const nav = document.querySelector('nav, header, [role=navigation]'); nav ? JSON.stringify({bg: getComputedStyle(nav).backgroundColor, font: getComputedStyle(nav).fontFamily}) : 'no nav found'"

# Check for any colors NOT in the Design Bible palette
$B js "const allBgColors = [...new Set(Array.from(document.querySelectorAll('*')).map(el => getComputedStyle(el).backgroundColor).filter(c => c !== 'rgba(0, 0, 0, 0)' && c !== 'transparent'))].slice(0, 20); JSON.stringify(allBgColors)"
```

## Step 4 — Compare against Design Bible rules

For each extracted value, compare against the Design Bible:

**Color drift check:**
- Convert extracted `rgb(r, g, b)` to hex for comparison
- Flag any color that doesn't match a Design Bible color (with a tolerance of ±5 per channel for rendering differences)
- Exception: colors from the Memory Log that were confirmed intentional

**Font drift check:**
- Compare extracted font-family to Design Bible body and heading fonts
- Flag any font that's not in the approved list

**Spacing drift check:**
- Check padding/margin values against the spacing scale
- Flag values that aren't multiples of the base unit (4px or 8px)

**Radius drift check:**
- Compare border-radius values to Design Bible component rules
- Flag inconsistencies (e.g. some buttons have 4px, others have 8px)

**60/30/10 color balance check:**
- ~60% of the page should be the background/base color
- ~30% should be the secondary/neutral color
- ~10% should be the accent/brand color
- Flag if the accent color is dominating more than 10% (overwhelming) or if brand color is absent (invisible)

## Step 5 — Create annotated screenshots

If drift was found on any page:

```bash
$B goto <page URL>
$B snapshot -i
$B snapshot -i -a -o /tmp/dstack-brand-annotated-[page].png
```

For each drifted element found, reference its `@ref` in the annotation. Label each circled area with the issue in plain English.

Show the annotated screenshot via Read tool.

## Step 6 — Write the brand consistency report

---

**Brand consistency check — [date]**

**Pages checked:** [list]
**Overall consistency score: [X]/10**

---

**Page by page:**

**[Page name / URL]** — [✓ On brand / ⚠ Minor drift / ✗ Off brand]

[For each drift issue on this page:]
📍 [Element — e.g. "Sign in button"]
- **What it is now:** [e.g. "Dark gray background (#333333)"]
- **What it should be:** [e.g. "Your accent color (#e94560) per Design Bible"]
- **How bad:** [Noticeable / Subtle / Only visible side-by-side]
- **Quick fix:** [plain English instruction]

[repeat for each page]

---

**Summary of all drift found:**

| Issue | Pages affected | Priority |
|-------|---------------|----------|
| [e.g. "Wrong button color"] | [e.g. "Home, Pricing"] | [High / Medium / Low] |

**Nothing drifted:** [list any pages that are perfectly on brand]

---

**My top 3 fixes:**
1. [Most widespread or visible drift]
2. [Second most important]
3. [Third]

---

## Step 7 — Ask what to do

> "Want me to fix any of these? I can:
> A) Fix the most important drift issue right now
> B) Fix everything across all pages
> C) Show me a specific issue in more detail
> D) Mark something as intentional — add it to the Design Bible so it doesn't flag next time"

**If D (intentional change):**
Ask which issue to mark as intentional, then update the Design Bible:
- Add the confirmed value to the relevant L1/L4 section
- Append to Memory Log: `[date]: [element] value changed to [X] — confirmed intentional.`

## Step 8 — Update Design Bible Memory Log

After the run, append:
```
[date]: /brand scan on [N] pages. Consistency: [X]/10. Drift found: [list issues]. Fixed: [yes/no/partial]. Pages fully on-brand: [list].
```
