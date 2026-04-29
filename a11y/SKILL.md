---
name: ds-a11y
version: 0.1.0
description: >
  Grades a site's accessibility from A to D and produces an annotated screenshot
  showing exactly where each problem is, in plain English. Use when the user wants
  to check accessibility, prepare to share with clients, run a pre-launch audit,
  or invokes '/ds-a11y'.
license: MIT
allowed-tools:
  - Bash
  - Read
  - AskUserQuestion
compatibility: Requires browse binary for axe-core injection and annotated screenshots. Falls back to code-only audit without it.
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
  '{"skill":"a11y","event":"started","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
```

## What accessibility means (explain this to the user if they haven't run /a11y before)

> "Accessibility means your website works for everyone — including people who are blind and use a screen reader to hear the page, people with low vision who need high contrast text, people who are color-blind, and people who use a keyboard instead of a mouse. Many countries also have legal requirements around this.
>
> I'll check your site against the main rules and give you a grade from A to D, plus a screenshot showing exactly where each problem is."

## Step 1 — Get the URL

Ask the user:
> "What page should I check for accessibility? Give me the URL (e.g. `http://localhost:3000` or your live URL). The home page is a good start, or try your most important page like checkout or signup."

## Step 2 — Take a baseline screenshot

If `BROWSE` is not `NOT_FOUND`:

```bash
$B goto <URL>
$B screenshot /tmp/dstack-a11y-before.png
```

**If the URL is not reachable:**
> "Your project doesn't seem to be running right now. Start it with `npm run dev` (or `npm start`) and then give me the URL — usually http://localhost:3000. I'll wait."

Do not continue until the user confirms the project is running.

Show the screenshot to the user:
> "Here's your page. Let me run the accessibility check now."

## Step 3 — Run the accessibility audit

If `BROWSE` is not `NOT_FOUND`:

Inject axe-core (the industry-standard accessibility testing library) and run a full audit:

```bash
$B js "
  const script = document.createElement('script');
  script.src = 'https://cdnjs.cloudflare.com/ajax/libs/axe-core/4.9.1/axe.min.js';
  document.head.appendChild(script);
  await new Promise(r => script.onload = r);
  const results = await axe.run();
  JSON.stringify({
    violations: results.violations.map(v => ({
      id: v.id,
      impact: v.impact,
      description: v.description,
      nodes: v.nodes.map(n => ({
        html: n.html.slice(0, 100),
        target: n.target,
        failureSummary: n.failureSummary
      })).slice(0, 3)
    })),
    passes: results.passes.length,
    incomplete: results.incomplete.length
  });
"
```

Also check color contrast specifically for text elements:
```bash
$B js "
  const textEls = Array.from(document.querySelectorAll('p, h1, h2, h3, h4, h5, h6, a, button, label, span, li')).filter(el => el.textContent.trim().length > 0 && getComputedStyle(el).display !== 'none').slice(0, 20);
  textEls.map(el => {
    const s = getComputedStyle(el);
    return { tag: el.tagName, color: s.color, bg: s.backgroundColor, size: s.fontSize, text: el.textContent.slice(0,20) };
  });
"
```

Take a snapshot to get element references for annotation:
```bash
$B snapshot -i
```

Then create the annotated screenshot with problem areas circled:
```bash
$B snapshot -i -a -o /tmp/dstack-a11y-annotated.png
```

## Step 4 — If browse is NOT available

If `BROWSE` is `NOT_FOUND`:
> "I can't run the automated accessibility check without the visual browser. I'll check your code manually for common accessibility issues instead."

Check the codebase for:
- `<img>` tags missing `alt` attribute
- `<button>` elements with no text content or aria-label
- `<a>` tags with no text or just "click here" / "read more"
- `<input>` elements missing `<label>` or `aria-label`
- `<form>` fields missing associated labels
- Color contrast (check CSS for known low-contrast combinations)
- Missing `lang` attribute on `<html>`
- Missing `<title>` tag
- Heading hierarchy violations (h3 before h2, etc.)

## Step 5 — Translate violations to plain English

For each violation found, translate the axe rule ID to plain English using this table:

| axe rule ID | Severity | Plain English explanation |
|---|---|---|
| `color-contrast` | Medium | "This text is hard to read — the color doesn't stand out enough from the background" |
| `image-alt` | Critical | "This image has no description, so blind users won't know what it shows" |
| `label` | Critical | "This input field doesn't say what it's asking for — screen readers can't announce it" |
| `button-name` | Critical | "This button has no readable label — blind users won't know what it does" |
| `heading-order` | Moderate | "Your headings are out of order — screen readers expect them to go H1, H2, H3 in sequence" |
| `html-has-lang` | Serious | "Your page doesn't specify what language it's in — screen readers won't know how to pronounce it" |
| `document-title` | Serious | "Your page has no title — blind users and browser tabs will show nothing" |
| `link-name` | Serious | "This link just says 'click here' or has no text — screen readers can't tell what it leads to" |
| `region` | Moderate | "Your page content isn't organized into landmarks — screen readers can't skip to the main content" |
| `landmark-one-main` | Moderate | "Your page is missing a 'main content' area label — screen readers expect one" |
| `aria-required-attr` | Critical | "An interactive element is missing a required accessibility attribute" |
| `aria-valid-attr-value` | Critical | "An accessibility attribute has an invalid value" |
| `form-field-multiple-labels` | Moderate | "This input field has two conflicting labels — screen readers won't know which to use" |
| `select-name` | Critical | "This dropdown menu has no label — screen readers can't describe it" |
| `frame-title` | Serious | "An embedded frame has no title — screen readers can't describe its contents" |
| `scrollable-region-focusable` | Serious | "This scrollable area can't be reached with a keyboard — only mouse users can scroll it" |
| `target-size` | Minor | "This button is too small to tap comfortably on a phone (needs at least 44×44px)" |
| `focus-visible` | Serious | "When someone navigates with Tab, they can't see where they are on the page" |
| `keyboard` | Critical | "This element can't be reached or used with a keyboard at all" |
| `bypass` | Moderate | "Keyboard users have no way to skip over the navigation to get to the main content" |
| `meta-viewport` | Critical | "Your page is blocking users from zooming in — this breaks accessibility for low-vision users" |
| `tabindex` | Serious | "The keyboard tab order on your page jumps around in a confusing way" |
| `duplicate-id` | Moderate | "Two elements share the same ID — this confuses screen readers" |
| `definition-list` | Minor | "A list is not structured correctly for screen readers" |
| `list` | Minor | "A list element is used incorrectly — screen readers will announce it wrong" |
| `td-headers-attr` | Serious | "A table cell doesn't say which column or row header it belongs to" |
| `th-has-data-cells` | Serious | "A table header doesn't have any associated data cells" |

For any axe rule not in this table, translate the `description` field from axe directly, removing all technical jargon.

## Step 6 — Calculate the grade

Count violations by severity level:

- **critical** — blocks access entirely for some users
- **serious** — significantly reduces usability for some users
- **moderate** — creates obstacles but workarounds exist
- **minor** — small improvements that help edge cases

**Grading scale:**
- **A** — 0 violations. Fully accessible.
- **B** — 1–3 violations, none critical or serious. Minor issues only.
- **C** — 4–8 violations, OR any 1–2 serious violations, OR no critical violations.
- **D** — 9+ violations, OR any critical violation, OR anything that blocks a core user action.

**Bonus points toward better grade (note these in the report):**
- Page has a skip-to-main link (+1 tier bump if at C or below)
- All images have meaningful alt text
- All forms are fully labeled
- Keyboard navigation works throughout

## Step 7 — Show annotated screenshot

Show the annotated screenshot via Read tool:
> "Here's your page with the problems circled:"
[show /tmp/dstack-a11y-annotated.png]

Each circled area should correspond to a numbered issue in the report below.

## Step 8 — Write the report

**First, show the verdict — one line only, with the grade prominently:**
> **Grade [A/B/C/D] — [URL] — [one sentence: what the grade means in plain English]**
> e.g. "Grade C — http://localhost:3000 — Three issues would stop blind users from using your navigation."

Then ask:
> A) Show me the full report
> B) Just fix the biggest issue now

If the user picks B: jump directly to Step 9 with the top Critical or Serious issue.
If the user picks A (or any affirmative): continue with the full report below.

---

**Accessibility grade for [URL]:**

# Grade: [A / B / C / D]

[One plain-English sentence about what the grade means — e.g. "Your site has 3 serious issues that would block blind users from using your navigation."]

---

**What this grade means:**
[A: "Your site works well for everyone — great job."]
[B: "Your site is mostly accessible with a few small issues to fix."]
[C: "Your site has accessibility issues that would frustrate some users. Worth fixing before launch."]
[D: "Your site has issues that block some users entirely. Fix the critical ones before sharing with clients."]

---

**Issues found:**

[For each violation, numbered to match the annotated screenshot:]

**#1** [🔴 Critical / 🟠 Serious / 🟡 Moderate / ⚪ Minor]
📍 [Where on the page — e.g. "Header navigation", "Sign up button", "Hero image"]
What's wrong: [plain-English explanation from translation table above]
Who it affects: [e.g. "Blind users using screen readers" / "Keyboard-only users" / "People with low vision" / "Color-blind users"]
How to fix: [plain-English instruction — e.g. "Add a description to this image that says what it shows, like: alt='Team photo at our 2024 company offsite'"]

[repeat for each issue]

---

**What's working well ✓**
- [Things that passed — e.g. "All your form labels are correctly set up"]
- [e.g. "Your page has a proper title"]
- [e.g. "Your main navigation is keyboard-accessible"]

---

**My top 3 fixes (do these first):**

1. [Most impactful fix — always start with Critical issues]
   What to do: [exact plain-English instruction]
   Who it helps: [who benefits]
   How long: [quick / a few minutes / might take a while]

2. [Second fix]
   What to do: [...]
   Who it helps: [...]

3. [Third fix]
   What to do: [...]
   Who it helps: [...]

---

**If you fix these 3 things, your grade goes from [X] to [Y].**

---

## Step 9 — Ask what to do next

> "Want me to fix any of these? Say which one (or 'fix them all in order') and I'll take care of it.
>
> After fixing, I'll rerun the check and show you the new grade."

## Step 10 — After fixes, rerun and compare

If fixes are made, rerun the axe audit:

```bash
$B goto <URL>
$B js "[same axe injection as Step 3]"
$B screenshot /tmp/dstack-a11y-after.png
```

Show the new grade and compare:
> "Before: Grade [X] — [N] issues
> After: Grade [Y] — [M] issues
>
> [New screenshot]"

## Step 11 — Update the Design Bible

Append to `design/DESIGN-BIBLE.md` Memory Log:
```
[date]: /a11y ran on [URL]. Grade: [A/B/C/D]. Issues: [count by severity]. Fixed: [yes/no/partial]. Remaining: [count].
```

If new accessibility rules were established (e.g. "all images must have alt text"), add them to the L4 Component Rules section:
```
### Accessibility Rules
- All images: must have descriptive alt text
- All buttons: must have visible text or aria-label
- [any other rules established during this session]
```

## Completion

Always run this bash before ending, regardless of outcome. Replace `OUTCOME` with: `success`, `error`, or `abort`.

```bash
_TEL_END=$(date +%s)
_TEL_DUR=$(( _TEL_END - _TEL_START ))
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"a11y","event":"completed","outcome":"OUTCOME","duration_s":"'"$_TEL_DUR"'","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
"$HOME/.claude/skills/ds/bin/ds-telemetry-log" \
  --skill "a11y" --duration "$_TEL_DUR" --outcome "OUTCOME" \
  --session "$_SESSION_ID" 2>/dev/null || true
```

Report completion status: **DONE** / **DONE_WITH_CONCERNS** / **BLOCKED** / **NEEDS_CONTEXT**
