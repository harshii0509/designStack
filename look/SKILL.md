---
name: ds:look
version: 0.1.0
description: Does this look right? Screenshot your site, compare it against your Design Bible rules, and get an annotated visual with plain-English issues labeled. Run after any UI change.
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
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/DesignBrain.md" ] && _HAS_BIBLE="yes" && _BIBLE="$_ROOT/DesignBrain.md"
_B=""
[ -x "$HOME/.claude/skills/ds/browse/dist/browse" ] && _B="$HOME/.claude/skills/ds/browse/dist/browse"
_LAST_COMMIT=$(git log -1 --pretty=format:"%h — %s" 2>/dev/null || echo "no history yet")
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "DESIGN_BIBLE: $_HAS_BIBLE | path: ${_BIBLE}"
echo "BROWSE: ${_B:-NOT_FOUND}"
echo "LAST_COMMIT: $_LAST_COMMIT"
_TEL_START=$(date +%s)
_SESSION_ID="$$-$(date +%s)"
mkdir -p "$HOME/.dstack/analytics"
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"look","event":"started","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
```

## What this skill does

Check if your site actually looks like it should. You point me at a page, I take a screenshot, compare it against your Design Bible (colors, fonts, spacing, brand rules), and give you a plain-English report with an annotated image showing exactly where things are off.

This skill never changes code — it only looks and reports.

## Step 1 — Load the Design Bible

If `DESIGN_BIBLE` is `yes`, read the Bible file fully. Extract:
- L1 colors (primary, background, text, accent)
- L1 typography (font families, sizes, weights)
- L1 spacing scale
- L1 border radius rules
- L4 component rules (buttons, cards, forms, nav)
- Memory Log (recent changes, known intentional decisions)

If `DESIGN_BIBLE` is `no`:
> "I don't have your design rules yet, so I can't check for brand drift. I'll still look for layout issues and obvious problems. Want me to set up your Design Bible first? Run `/ds:context` — it takes 5 minutes and makes every future check much smarter."

Continue the check either way.

## Step 2 — Get the URL

Ask the user:
> "What page should I check? Give me the URL — e.g. `http://localhost:3000` or `https://your-site.com/dashboard`. If you have a specific part in mind (like the signup flow or the pricing page), tell me that too."

If the user already mentioned a URL in the conversation, use that and confirm:
> "I'll check [URL] — is that the right page?"

## Step 3 — Take a screenshot (if browse available)

If `BROWSE` is not `NOT_FOUND`:

```bash
$B goto <URL>
$B screenshot /tmp/dstack-look-before.png
$B text
```

**If the URL is not reachable:**
> "Your project doesn't seem to be running right now. Start it with `npm run dev` (or `npm start`) and then give me the URL — usually http://localhost:3000. I'll wait."

Do not continue until the user confirms the project is running.

Also extract CSS values to verify against Design Bible:
```bash
$B css body font-family
$B css body font-size
$B css body color
$B css body background-color
$B css h1 font-family
$B css h1 font-size
$B js "getComputedStyle(document.querySelector('button') || document.body).backgroundColor"
$B js "getComputedStyle(document.querySelector('a') || document.body).color"
```

Show the screenshot to the user via the Read tool immediately:
> "Here's what your page looks like right now:"
[show screenshot]

If `BROWSE` is `NOT_FOUND`:
> "I can't take a screenshot — the visual browser isn't installed. I'll still check your code for design rule violations."

Ask the user to paste any relevant code or describe what they're seeing instead.

## Step 4 — Ask what the user expected

Ask:
> "Does anything jump out as obviously wrong to you? Or should I just check everything against your brand rules and report what I find?"

If they describe something specific, note it as a priority issue to look for.

## Step 5 — Run the Design Bible check

Compare what you extracted (CSS values, screenshot visual) against the Design Bible rules.

**Check these in order:**

### Color check
- Is the background color correct? Compare extracted `body background-color` to L1 Background color.
- Is the text color on brand? Compare to L1 Text color.
- Are buttons using the right accent color? Compare to L1 Accent / CTA.
- Are there any colors that appear on screen but aren't in the Design Bible palette? (Possible drift)

### Typography check
- Is the body font correct? Compare `body font-family` to L1 Body font.
- Is the heading font correct? Compare `h1 font-family` to L1 Heading font.
- Are font sizes on the type scale? (Flag any font size not in the L1 scale)
- Are font weights appropriate?

### Spacing check
- Does the layout feel consistent with the spacing scale? (Look for irregular gaps)
- Is the page padding consistent with L1 Page padding rules?

### Component check (if Design Bible has L4 rules)
- Buttons: right background color, right radius, right text color?
- Cards: right padding, border, shadow?
- Navigation: right style, background, active indicator?

### Layout check (regardless of Design Bible)
- Is anything obviously misaligned?
- Any text that appears cut off or overflows its container?
- Any images that look stretched or have broken src?
- Any sections that feel visually unbalanced?

## Step 6 — Create annotated screenshot

If browse is available and issues were found:

```bash
$B snapshot -i -a -o /tmp/dstack-look-annotated.png
```

For each issue identified, reference the element by its `@ref` from the snapshot. Add plain-English annotations for each problem area.

Show the annotated screenshot via Read tool.

## Step 7 — Write the report

**First, show the verdict — one line only:**
> **[URL] — [X]/10 — [one sentence: what's the main finding]**
> e.g. "http://localhost:3000 — 7/10 — Looks mostly on brand but has two color issues and tight spacing on mobile."

Then ask:
> A) Show me the full report
> B) Just fix the biggest issue now

If the user picks B: jump directly to Step 8 with issue #1 from your top-3 list.
If the user picks A (or any affirmative): continue with the full report below.

Format the full report like this — plain English only, no technical terms:

---

**Here's what I found on [page name/URL]:**

**Score: [X]/10**
[One sentence explaining the score in plain language — e.g. "Your page is close to your brand rules but has a few color and spacing issues."]

**What's working well ✓**
- [e.g. "Your main color and button style match your brand rules perfectly"]
- [e.g. "The fonts are correct throughout"]
- [add up to 3 things that are right]

**Issues I found:**

[For each issue, write:]
📍 [Where on the page] — [What's wrong in plain English] — [What it should be according to your Design Bible]

Examples:
- 📍 Top navigation bar — The background is white but your Design Bible says it should be [#1a1a2e]. This is a color drift.
- 📍 "Sign up" button — The button is using a gray color, but your accent color should be [#e94560]. It won't stand out to users.
- 📍 Heading on hero section — The font looks like Arial, but your brand font is Inter. This happened at some point during recent edits.
- 📍 Card section — The spacing between cards is tighter than your spacing scale allows. Cards feel cramped.

**My top 3 fixes (in order of importance):**
1. [Most important fix — plain English, specific]
2. [Second fix]
3. [Third fix]

---

**Design Bible drift summary:**
- Intentional changes since last save: [from Memory Log]
- Unintentional drift found: [list what was found but isn't in the Memory Log]

---

## Step 8 — Ask to fix

After showing the report:
> "Want me to fix any of these? Tell me which one and I'll take care of it. Or say 'fix them all' and I'll work through the list. After fixing, I'll take another screenshot so you can compare."

## Step 9 — If fixes are made, take an after screenshot

After applying any fixes:
```bash
$B goto <URL>
$B screenshot /tmp/dstack-look-after.png
```

Show both before and after:
> "Here's the before and after:"
[show /tmp/dstack-look-before.png]
[show /tmp/dstack-look-after.png]

## Step 10 — Update the Design Bible Memory Log

After the run, append to `design/DESIGN-BIBLE.md` Memory Log:

```
[date]: /look ran on [URL]. Score: [X]/10. Issues found: [short list]. Fixed: [yes/no/partial].
```

If any drift was found that turned out to be intentional (user said "actually that's on purpose"):
```
[date]: [element] — [value] — confirmed intentional by user. Design Bible updated.
```

And update the relevant L1–L4 section in the Design Bible to reflect the confirmed intentional value.

## Step 11 — Proactive gap surfacing

If during the check you noticed screens or components that appeared on the page but aren't in the Design Bible yet (e.g. a modal, a data table, a sidebar), mention them:

> "By the way — I saw a [component/screen] on this page that isn't in your Design Bible yet. Want me to add rules for it so future checks can include it?"

## Completion

Always run this bash before ending, regardless of outcome. Replace `OUTCOME` with: `success`, `error`, or `abort`.

```bash
_TEL_END=$(date +%s)
_TEL_DUR=$(( _TEL_END - _TEL_START ))
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"look","event":"completed","outcome":"OUTCOME","duration_s":"'"$_TEL_DUR"'","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
"$HOME/.claude/skills/ds/bin/ds-telemetry-log" \
  --skill "look" --duration "$_TEL_DUR" --outcome "OUTCOME" \
  --session "$_SESSION_ID" 2>/dev/null || true
```

Report completion status: **DONE** / **DONE_WITH_CONCERNS** / **BLOCKED** / **NEEDS_CONTEXT**
