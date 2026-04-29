---
name: ds:vibe
version: 0.1.0
description: >
  Presents three distinct visual directions generated from feeling words, then
  writes the chosen aesthetic into the Design Bible. Use when the user wants to
  set or change their product's look and feel, describe a feeling, or runs
  '/ds:vibe'.
license: MIT
allowed-tools:
  - Bash
  - Read
  - Write
  - AskUserQuestion
compatibility: Requires git. Updates Design Bible with chosen visual direction.
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
[ -x "$HOME/.claude/skills/ds/browse/dist/browse" ] && _B="$HOME/.claude/skills/ds/browse/dist/browse"
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "DESIGN_BIBLE: $_HAS_BIBLE | source: ${_BIBLE_SOURCE:-none}"
echo "BROWSE: ${_B:-NOT_FOUND}"
_TEL_START=$(date +%s)
_SESSION_ID="$$-$(date +%s)"
mkdir -p "$HOME/.dstack/analytics"
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"vibe","event":"started","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
```

## What this skill does

You describe the feeling you want — in plain English, no design knowledge needed. I'll give you three completely different visual directions to compare. You pick one, and I'll set up your design rules to match that direction so everything you build from now on follows the same aesthetic.

This reads your existing Design Bible first, so I'm suggesting evolution — not replacement.

## Step 1 — Read the existing Design Bible (if it exists)

If `DESIGN_BIBLE` is `yes`, read the full Bible. Note:
- Current vibe words (The feeling section)
- Current colors (L1)
- Current fonts (L1)
- Recent Memory Log entries
- What's already been built and confirmed as intentional

This context prevents suggesting something that would discard all existing confirmed design decisions. Frame the directions as evolutions of what's there.

If `DESIGN_BIBLE` is `no`:
> "I don't have your design rules yet — I'll create three directions from scratch. After you pick one, I'll set up your Design Bible so everything stays consistent going forward."

## Step 2 — Understand what they want

Ask the user:
> "How do you want your product to feel? You can describe it in any of these ways:
>
> - Feeling words: 'calm and focused', 'bold and energetic', 'warm and friendly', 'minimal and clean'
> - A reference: 'like Notion', 'like Stripe but warmer', 'like Duolingo without the green'
> - A contrast: 'the opposite of what I have now — it feels too corporate'
> - A person: 'like a really good doctor's office — trustworthy but not cold'
> - Anything: just describe it however makes sense to you"

Wait for their response. If they give very sparse input (e.g. just "modern"), follow up once:
> "Got it — anything else? Are you thinking more minimal/clean, or more bold/expressive? Light or dark?"

## Step 3 — Research references (if a reference site was mentioned)

If the user mentioned a specific website or app:

If `BROWSE` is not `NOT_FOUND`:
```bash
$B goto <mentioned URL>
$B screenshot /tmp/dstack-vibe-ref.png
$B css body font-family
$B css body background-color
$B css h1 font-family
$B js "getComputedStyle(document.querySelector('button') || document.body).backgroundColor"
```
Show the screenshot. Extract the core aesthetic principles you observe.

If browse is not available, reason about the reference from general knowledge (e.g. "Notion uses a clean, minimal aesthetic with neutral grays and Inter font").

## Step 4 — Generate three distinct directions

Based on the user's description and any existing Design Bible context, create three distinct visual directions. Make them genuinely different from each other — not subtle variations.

**Format for each direction:**

---

**Direction [A / B / C]: [Short name — e.g. "Clean & Focused" / "Bold & Energetic" / "Warm & Grounded"]**

*The feeling:* [One sentence describing what this direction evokes — e.g. "Like a high-end tool that respects your time. Nothing extra, nothing missing."]

**Colors:**
- Main background: [hex] — [description, e.g. "off-white, warm not cold"]
- Primary text: [hex] — [e.g. "near-black, softer than pure black"]
- Brand / accent: [hex] — [e.g. "muted sage green"]
- Buttons: [hex] — [e.g. "same sage, high contrast white text"]
- Hover / highlight: [hex]

**Fonts:**
- Headings: [font name] — [description, e.g. "geometric, confident, slightly condensed"]
- Body text: [font name] — [e.g. "legible, neutral, works at small sizes"]

**Spacing feel:** [Tight and dense / Balanced and breathable / Open and airy]

**Shapes:** [Sharp corners / Subtle rounding (4–6px) / Friendly rounding (8–12px) / Pill-shaped (16px+)]

**The look in words:** [3–5 sentences describing what a page built in this direction would look like. Be specific — mention what hero sections, buttons, cards, and navigation would look like.]

**Good for:** [Who this direction works best for — e.g. "Tools used by professionals who need focus, not entertainment"]
**Not great for:** [When this direction would feel wrong — e.g. "Consumer apps that need to feel fun and approachable"]

**Similar to:** [1-2 real references — e.g. "Linear, Raycast"]

---

Show all three directions clearly separated. Then ask:

> **Which direction feels right for your product?**
>
> A) [Direction A name]
> B) [Direction B name]  
> C) [Direction C name]
> D) I like parts of different ones — let me describe what I want
> E) None of these feel right — let me describe something else

## Step 5 — Handle the response

**If A, B, or C:**
Confirm the choice:
> "Great — going with [Direction name]. Here's a quick visual preview of what this would look like as a real UI element:"

Generate a small HTML preview showing the direction applied to a button, a card, and a heading:

```html
<!-- render this as an artifact or write to /tmp/dstack-vibe-preview.html -->
<!DOCTYPE html>
<html>
<head>
<style>
  /* Apply the chosen direction's exact colors, fonts, spacing, radius */
  body { background: [bg]; font-family: [body font]; color: [text]; padding: 40px; }
  h1 { font-family: [heading font]; font-size: 32px; font-weight: [weight]; margin-bottom: 8px; }
  p { font-size: 16px; line-height: 1.6; color: [secondary text]; }
  .btn { background: [accent]; color: white; border: none; padding: 12px 24px; border-radius: [radius]px; font-weight: 600; cursor: pointer; }
  .btn:hover { background: [hover color]; }
  .card { background: [card bg]; border: 1px solid [border]; border-radius: [radius]px; padding: 24px; margin-top: 24px; }
</style>
</head>
<body>
  <h1>Your Product Name</h1>
  <p>This is what your body text will look like. Clear, readable, on brand.</p>
  <button class="btn">Get started</button>
  <div class="card">
    <h2 style="font-size:20px; margin-bottom:8px;">A card component</h2>
    <p>This is how your content cards will look. Consistent spacing, right colors.</p>
  </div>
</body>
</html>
```

If browse is available, screenshot the preview:
```bash
$B goto file:///tmp/dstack-vibe-preview.html
$B screenshot /tmp/dstack-vibe-preview.png
```
Show the screenshot to the user.

**If D (mix of directions):**
Ask:
> "Tell me which parts you liked from each. For example: 'I liked Direction A's colors but Direction C's spacing and font.'"
Then generate a custom blended direction and confirm before proceeding.

**If E (none feel right):**
Ask:
> "What felt off? Was it the colors, the fonts, the overall feel — or something else? Describe what you were hoping for."
Then generate three new directions based on the refined description.

## Step 6 — Update the Design Bible

After the user confirms a direction, update `design/DESIGN-BIBLE.md`:

If the Bible doesn't exist yet, create it first with just the chosen direction's values.

If it exists, update these sections with the confirmed direction's values:

- **The feeling** section: replace with the 3 vibe words from the chosen direction
- **L1 Colors**: update with the exact hex values from the chosen direction
- **L1 Typography**: update fonts from the chosen direction
- **L1 Borders & Radius**: update radius from the chosen direction
- **L1 Spacing**: update spacing feel from the chosen direction

Append to Memory Log:
```
[date]: /vibe run. Chose direction: [Direction name — e.g. "Clean & Focused"]. Vibe words: [X, Y, Z]. Design Bible updated with new L1 values.
```

If the user had an existing Design Bible and the new direction changes things significantly, flag what changed:
> "I've updated your Design Bible with the new direction. Here's what changed:
> - Color: was [old], now [new]
> - Font: was [old], now [new]
> - Radius: was [old], now [new]
>
> Anything that was built before will need a pass to match the new direction. Want to run `/ds:look` on your existing pages to see what needs updating?"

## Step 7 — Next step suggestion

After updating the Bible:
> "Your Design Bible now has your new look captured. Here's what I'd suggest next:
>
> 1. Run `/ds:look` on your main page to see how it compares to the new direction
> 2. Run `/ds:brand` to scan for anything that's drifted from the new rules
> 3. Or just keep building — every new thing I create will automatically follow the new direction"

## Completion

Always run this bash before ending, regardless of outcome. Replace `OUTCOME` with: `success`, `error`, or `abort`.

```bash
_TEL_END=$(date +%s)
_TEL_DUR=$(( _TEL_END - _TEL_START ))
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"vibe","event":"completed","outcome":"OUTCOME","duration_s":"'"$_TEL_DUR"'","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
"$HOME/.claude/skills/ds/bin/ds-telemetry-log" \
  --skill "vibe" --duration "$_TEL_DUR" --outcome "OUTCOME" \
  --session "$_SESSION_ID" 2>/dev/null || true
```

Report completion status: **DONE** / **DONE_WITH_CONCERNS** / **BLOCKED** / **NEEDS_CONTEXT**
