---
name: ds-a11y
version: 0.1.0
description: >
  Audits one page for accessibility, grades it from A to D, and explains the
  blocking issues in plain English with annotations when visual tools are
  available. Use when the user wants an accessibility check on a specific page,
  needs a grade before sharing, or runs '/ds-a11y'.
license: MIT
allowed-tools:
  - Bash
  - Read
  - AskUserQuestion
compatibility: Requires browse binary for axe-core injection and annotated screenshots. Falls back to code-only audit without it.
---

## Preamble

```bash
"../lib/env.sh" "a11y"
```

## What accessibility means (explain this to the user if they haven't run `/ds-a11y` before)

> "Accessibility means your website works for everyone — including people who are blind and use a screen reader to hear the page, people with low vision who need high contrast text, people who are color-blind, and people who use a keyboard instead of a mouse. Many countries also have legal requirements around this.
>
> I'll check your site against the main rules and give you a grade from A to D, plus a screenshot showing exactly where each problem is."

This is a one-page accessibility audit. If the user wants a broader launch review, route them to `/ds-polish` instead.

## Step 1 — Load Design Bible (if present)

If `DESIGN_BIBLE` is `yes`, follow the standard extraction protocol in `lib/bible-reader.md`. Focus on L1 Colors and L4 component rules for contrast checking.

## Step 2 — Get the URL

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

## Step 3 — Take screenshot and run accessibility audit

If `BROWSE` is not `NOT_FOUND`:

```bash
"../lib/visual-audit.sh" screenshot "<URL>" "a11y" "before"
```

If the URL is not reachable, run and show the output of:
```bash
"../lib/visual-audit.sh" not_running
```
Do not continue until the user confirms the project is running.

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

Read `references/axe-translation.md` and use its mapping table to translate axe rule IDs into plain English. For any rule not listed there, translate the axe `description` directly, removing jargon.

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

Follow the jargon rules in `lib/plain-language.md` when writing this report — no technical terms.

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
[date]: /ds-a11y ran on [URL]. Grade: [A/B/C/D]. Issues: [count by severity]. Fixed: [yes/no/partial]. Remaining: [count].
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
"../lib/telemetry-end.sh" "a11y" "OUTCOME"
```

Report completion status: **DONE** / **DONE_WITH_CONCERNS** / **BLOCKED** / **NEEDS_CONTEXT**
