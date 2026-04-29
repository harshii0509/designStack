---
name: ds:mobile
version: 0.1.0
description: Check how your site looks on phones and tablets. Shows three side-by-side screenshots at phone, tablet, and desktop sizes with plain-English flags for anything that's broken or hard to use.
license: MIT
allowed-tools:
  - Bash
  - Read
  - AskUserQuestion
compatibility: Requires browse binary for viewport screenshots. Falls back to code analysis for fixed widths, small tap targets, and overflow issues without it.
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
  '{"skill":"mobile","event":"started","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
```

## What this skill does

Check if your site works on phones and tablets. I'll show you three side-by-side screenshots — phone, tablet, desktop — and flag anything that looks broken or is hard to use on smaller screens. In plain English. No code until you ask.

## Step 1 — Get the URL

Ask the user:
> "What page should I check on mobile? Give me the URL (e.g. `http://localhost:3000` or your live site URL). If you want me to check a specific page like checkout or signup, say that too."

If the URL was already mentioned in the conversation, confirm it:
> "I'll check how [URL] looks on different screen sizes. Sound right?"

## Step 2 — Check browse availability

If `BROWSE` is `NOT_FOUND`:
> "I can't take screenshots without the visual browser. I'll check your code for mobile problems instead — fixed widths, text that's too small, and buttons that are too small to tap."

Then proceed to Step 5 (code-only check).

## Step 3 — Take screenshots at three sizes

**If the URL is not reachable:**
> "Your project doesn't seem to be running right now. Start it with `npm run dev` (or `npm start`) and then give me the URL — usually http://localhost:3000. I'll wait."

Do not continue until the user confirms the project is running.

```bash
# Phone (iPhone size)
$B resize 375 812
$B goto <URL>
$B screenshot /tmp/dstack-mobile-375.png

# Tablet (iPad size)
$B resize 768 1024
$B goto <URL>
$B screenshot /tmp/dstack-mobile-768.png

# Desktop
$B resize 1280 900
$B goto <URL>
$B screenshot /tmp/dstack-mobile-1280.png
```

Show all three screenshots to the user:
> "Here's how your page looks across screen sizes:"

[show /tmp/dstack-mobile-375.png — label: "📱 Phone (375px)"]
[show /tmp/dstack-mobile-768.png — label: "📟 Tablet (768px)"]
[show /tmp/dstack-mobile-1280.png — label: "🖥️ Desktop (1280px)"]

## Step 4 — Check for mobile issues with browser tools

While at each size, run these checks:

**At 375px (phone):**
```bash
$B resize 375 812
$B goto <URL>

# Check for horizontal scroll (content overflowing off screen)
$B js "document.body.scrollWidth > window.innerWidth"

# Find text that might be too small
$B js "Array.from(document.querySelectorAll('p, span, a, li')).filter(el => parseFloat(getComputedStyle(el).fontSize) < 14).map(el => el.tagName + ': ' + el.textContent.slice(0,30)).slice(0,5)"

# Find buttons that are too small to tap (under 44px — the minimum comfortable tap size)
$B js "Array.from(document.querySelectorAll('button, a, input[type=submit], [role=button]')).filter(el => { const r = el.getBoundingClientRect(); return (r.width < 44 || r.height < 44) && r.width > 0; }).map(el => el.tagName + ' ' + (el.textContent || el.value || '').slice(0,20)).slice(0,5)"

# Check for fixed widths that might cause overflow
$B js "Array.from(document.querySelectorAll('[style*=\"width\"]')).filter(el => el.style.width && !el.style.width.includes('%') && !el.style.width.includes('vw') && parseInt(el.style.width) > 375).map(el => el.tagName + ': ' + el.style.width).slice(0,5)"
```

**At 768px (tablet):**
```bash
$B resize 768 1024
$B goto <URL>
$B js "document.body.scrollWidth > window.innerWidth"
```

## Step 5 — Code-only check (if no browse)

Search the codebase for common mobile problems:
- Fixed pixel widths wider than 375px
- Text smaller than 14px / 0.875rem
- Elements using `position: fixed` without mobile consideration
- Missing `viewport` meta tag in HTML head
- `overflow: hidden` on body that might hide mobile content

## Step 6 — Analyze and flag issues

For each problem found, translate it into plain English. Use this pattern:

| What you found | Plain English flag |
|---|---|
| `body.scrollWidth > window.innerWidth` | "Content is spilling off the right side of the screen on phones — users would have to scroll sideways to see it" |
| Font size < 14px | "This text is too small to read comfortably on a phone — it should be at least 14px" |
| Button height < 44px | "This button is too small to tap reliably on a phone — fingers need at least 44px to hit it without missing" |
| Fixed pixel width > 375px | "This section has a fixed width that's wider than a phone screen — it will overflow off the edge" |
| Missing viewport meta | "Your page is missing a setting that tells phones how to display it — everything might look tiny or zoomed out" |
| Layout breaks at tablet | "Your layout doesn't adapt at tablet size — elements overlap or stack in an unreadable way" |
| Images overflow | "Images are wider than the screen and cut off on phones" |
| Nav items don't collapse | "Your navigation bar tries to show too many items on a small screen — items get cut off" |
| Form inputs too small | "The input fields are hard to tap on a phone — they need more height and padding" |
| Text contrast shifts at mobile | "The text becomes hard to read on phone because of a background color change" |

## Step 7 — Write the report

**First, show the verdict — one line only:**
> **[URL] — Phone: [✓/⚠/✗] · Tablet: [✓/⚠/✗] · Desktop: [✓/⚠/✗] — [one sentence: biggest finding]**
> e.g. "http://localhost:3000 — Phone: ✗ · Tablet: ⚠ · Desktop: ✓ — Navigation overflows on phones and a button is too small to tap."

Then ask:
> A) Show me the full report
> B) Just fix the biggest issue now

If the user picks B: jump directly to Step 8 with issue #1 from your top-3 list.
If the user picks A (or any affirmative): continue with the full report below.

---

**Mobile check for [URL]:**

**Phone (375px) — [✓ Looks good / ⚠ Has issues / ✗ Broken]**
- [issue 1 in plain English — e.g. "Content spills off the right side — users have to scroll sideways"]
- [issue 2 — e.g. "The 'Get started' button is too small to tap reliably"]
- [or: "Looks good at this size — no obvious problems"]

**Tablet (768px) — [✓ / ⚠ / ✗]**
- [issues or "Looks good"]

**Desktop (1280px) — [✓ / ⚠ / ✗]**
- [issues or "Looks good"]

---

**My top 3 fixes for mobile:**
1. [Most impactful fix — e.g. "Make the navigation collapse into a hamburger menu on phones — right now it overflows"]
2. [Second fix — e.g. "Increase the tap size of your main CTA button from 32px to at least 44px tall"]
3. [Third fix — e.g. "Set a max-width on your hero section so it doesn't overflow on small screens"]

**Quick wins (easy to fix right now):**
- [fast small fixes]

---

## Step 8 — Offer to fix

> "Want me to fix any of these? I'll start with the most important one. After fixing, I'll take new screenshots so you can see the difference."

If yes, implement the fix, then retake the 375px screenshot to confirm:
```bash
$B resize 375 812
$B goto <URL>
$B screenshot /tmp/dstack-mobile-after-375.png
```

Show before and after at phone size:
> "Here's the phone view before and after the fix:"

## Step 9 — Update Design Bible

If a mobile spacing or layout rule was established during this session (e.g. "we decided the nav should collapse below 768px"), append to `design/DESIGN-BIBLE.md`:

```
[date]: Mobile check on [URL]. Phone: [status]. Tablet: [status]. Fixes applied: [yes/no]. New mobile rules: [any rules established].
```

If new mobile rules were confirmed, add them to the L4 Component Rules or L1 Spacing section in the Design Bible.

## Completion

Always run this bash before ending, regardless of outcome. Replace `OUTCOME` with: `success`, `error`, or `abort`.

```bash
_TEL_END=$(date +%s)
_TEL_DUR=$(( _TEL_END - _TEL_START ))
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"mobile","event":"completed","outcome":"OUTCOME","duration_s":"'"$_TEL_DUR"'","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
"$HOME/.claude/skills/ds/bin/ds-telemetry-log" \
  --skill "mobile" --duration "$_TEL_DUR" --outcome "OUTCOME" \
  --session "$_SESSION_ID" 2>/dev/null || true
```

Report completion status: **DONE** / **DONE_WITH_CONCERNS** / **BLOCKED** / **NEEDS_CONTEXT**
