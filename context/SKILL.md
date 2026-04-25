---
name: ds:context
version: 0.1.0
description: Build the Design Bible for this project. Captures brand rules, colors, fonts, spacing, and component patterns into a living file every other designStack skill reads from. Run once per project.
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
[ -f "$_BIBLE" ]              && _HAS_BIBLE="yes"  && _BIBLE_SOURCE="design/DESIGN-BIBLE.md"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/DesignBrain.md" ]  && _HAS_BIBLE="extend" && _BIBLE_SOURCE="DesignBrain.md"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/ICP-CONTEXT.md" ]  && _HAS_BIBLE="extend" && _BIBLE_SOURCE="ICP-CONTEXT.md"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/gstack/DESIGN.md" ] && _HAS_BIBLE="extend" && _BIBLE_SOURCE="gstack/DESIGN.md"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/DESIGN.md" ]       && _HAS_BIBLE="extend" && _BIBLE_SOURCE="DESIGN.md"
_B=""
[ -x "$HOME/.claude/skills/gstack/browse/dist/browse" ] && _B="$HOME/.claude/skills/gstack/browse/dist/browse"
[ -z "$_B" ] && [ -x "$HOME/.claude/skills/ds/browse/dist/browse" ] && _B="$HOME/.claude/skills/ds/browse/dist/browse"
# npm design system token detection
_NPM_TOKENS="none"
_PKG="$_ROOT/package.json"
if [ -f "$_PKG" ]; then
  _HAS_SHADCN="no"
  _HAS_TAILWIND="no"
  _HAS_BLEND="no"
  [ -f "$_ROOT/components.json" ] && _HAS_SHADCN="yes"
  [ -f "$_ROOT/tailwind.config.js" ] || [ -f "$_ROOT/tailwind.config.ts" ] && _HAS_TAILWIND="yes"
  [ -d "$_ROOT/node_modules/@juspay/blend-design-system" ] && _HAS_BLEND="yes"
  _NPM_TOKENS="${_HAS_SHADCN}|${_HAS_TAILWIND}|${_HAS_BLEND}"
fi
# project CLAUDE.md for design rules injection
_CLAUDE_MD="$_ROOT/CLAUDE.md"
_HAS_CLAUDE_MD="no"
_HAS_DESIGNSTACK_RULES="no"
[ -f "$_CLAUDE_MD" ] && _HAS_CLAUDE_MD="yes"
[ -f "$_CLAUDE_MD" ] && grep -q "dstack:design-rules:start" "$_CLAUDE_MD" 2>/dev/null && _HAS_DESIGNSTACK_RULES="yes"
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "DESIGN_BIBLE: $_HAS_BIBLE | source: ${_BIBLE_SOURCE:-none}"
echo "BROWSE: ${_B:-NOT_FOUND}"
echo "ROOT: $_ROOT"
echo "BIBLE_PATH: $_BIBLE"
echo "NPM_TOKENS: shadcn=${_HAS_SHADCN:-no} | tailwind=${_HAS_TAILWIND:-no} | blend=${_HAS_BLEND:-no}"
echo "CLAUDE_MD: $_HAS_CLAUDE_MD | has_rules: $_HAS_DESIGNSTACK_RULES"
```

## Guard: not a git repo

If `ROOT` is `.` (meaning git could not find a project root), stop immediately and say:

> "I don't see a project here. Make sure you open Claude Code from your project folder — the one that has your `src/` or `package.json`. Then run `/ds:context` again."

Do not continue past this point if ROOT is `.`.

---

## Opening line (always show this, never the raw preamble output)

"Looking at your project..."

## What this skill does

You're building the Design Bible — a living file at `design/DESIGN-BIBLE.md` that holds everything about how this project looks and feels. Every other designStack skill reads from it. Once it exists, you never have to explain your brand again.

This takes about 5 minutes.

## Step 0 — Auto-scan code files

Before asking the user anything, read these files silently (do not show the raw contents to the user):

1. **CSS custom properties** — look for the first file that exists:
   - `src/app/globals.css`
   - `app/globals.css`
   - `src/index.css`
   - `src/styles/globals.css`
   Read it and extract every `--variable: value` pair from the `:root` block. Note colors, fonts, spacing tokens.

2. **Font imports** — look for the first file that exists:
   - `src/app/layout.tsx` / `layout.jsx` / `layout.js`
   - `app/layout.tsx` / `layout.jsx` / `layout.js`
   - `pages/_app.tsx` / `_app.jsx` / `_app.js`
   Read it and extract all font family names (from `import`, `localFont`, `next/font/google`, or `@import url()`).

3. **Tailwind config** — look for:
   - `tailwind.config.js` / `tailwind.config.ts`
   Read it and extract `theme.colors`, `theme.extend.colors`, `theme.fontFamily`, `theme.extend.fontFamily`.

After reading, note what was found:
- `_AUTO_COLORS` — any hex values or color variable names extracted (e.g. `--background: #000000`)
- `_AUTO_FONTS` — any font family names extracted (e.g. `Geist Mono`, `Departure Mono`)

Tell the user:
> "Scanning your project files..."

Then if colors were found:
> "Found your color tokens in [filename]."

If fonts were found:
> "Found your fonts in [filename]."

Use these values to pre-fill Q1 and Q2 in Step 3. Do not ask about things already found from code.

---

## Step 1 — Check for existing design files

**If `DESIGN_BIBLE` is `extend` and `BIBLE_SOURCE` is `gstack/DESIGN.md`:**
Read `gstack/DESIGN.md` fully. Tell the user:
> "I found gstack's design file. I'll read it and build your Design Bible from it, adding the deeper brand rules that gstack doesn't track. Everything stays compatible."
Use its values to pre-fill L1–L4. Add a note at the top of the new Bible:
```
> Source: Extended from gstack/DESIGN.md on [date]
```

**If `DESIGN_BIBLE` is `extend` (other sources):** Read the existing file (`BIBLE_SOURCE`) fully. Note everything — colors, fonts, spacing, component rules. You will extend, not replace it. Tell the user:
> "I found your [file name]. I'll read it and build your Design Bible from it, adding anything that's missing."

**If `DESIGN_BIBLE` is `yes`:** The Design Bible already exists. Read it. Tell the user:
> "Your Design Bible already exists. Want me to refresh it by scanning your current site, or just update specific sections?"
If refresh: continue. If update specific: ask which section.

**If `DESIGN_BIBLE` is `no`:** Start fresh. Tell the user:
> "I'll build your Design Bible from scratch. I'll ask you 5 quick questions and scan your site if you have one running."

## Step 2 — Visual scan (if browse is available and project has a URL)

If `BROWSE` is not `NOT_FOUND`, ask:
> "Is your project running locally right now? If so, what's the URL? (e.g. http://localhost:3000) — I'll take a look and extract your colors and fonts automatically."

**If the URL is not reachable:** Tell the user:
> "I need your project to be running to take a screenshot. Start it (usually: `npm run dev` or `npm start`) and tell me the URL — usually http://localhost:3000. I'll wait."

If yes and URL provided and reachable:
```bash
$B goto <URL>
$B screenshot /tmp/dstack-scan-home.png
$B text
```

Also scan 1-2 more pages if they have distinct designs (e.g. /about, /dashboard):
```bash
$B goto <URL>/about
$B screenshot /tmp/dstack-scan-page2.png
```

Read the screenshots to extract:
- Dominant colors (exact hex where possible from CSS computed values)
- Font families (`$B css body font-family`, `$B css h1 font-family`)
- Spacing patterns (rough scale: tight/medium/airy)
- Border radius style (sharp/subtle/rounded/pill)

If `BROWSE` is `NOT_FOUND` or no URL: skip to Step 2.5.

## Step 2.5 — npm design system token ingestion

Check `NPM_TOKENS`. For each detected system, extract tokens BEFORE running the user interview. This pre-fills the interview answers automatically.

**shadcn/ui (if `shadcn=yes`):**
Read `components.json` to find the CSS variable naming convention.
Read `app/globals.css` (or `src/index.css`) — look for `:root` block with `--background`, `--foreground`, `--primary`, `--accent`, `--radius` variables.
Map them: `--primary` → L1 Primary/Brand, `--background` → L1 Background, `--foreground` → L1 Text, `--accent` → L1 Accent, `--radius` → L1 Border Radius.
Tell the user: "I found your shadcn design tokens and extracted your colors and spacing automatically."

**Tailwind (if `tailwind=yes`):**
Read `tailwind.config.js` (or `.ts`). Extract `theme.extend.colors` (or `theme.colors`) → L1 Colors. Extract `theme.extend.fontFamily` → L1 Typography. Extract `theme.extend.spacing` → L1 Spacing scale.
Security: only read string/object values — skip any `require()` calls or function values.
Tell the user: "I found your Tailwind config and extracted your color palette automatically."

**Blend/Juspay (if `blend=yes`):**
Check for `node_modules/@juspay/blend-design-system/dist/tokens.json` or `src/foundations/tokens`. Extract color and typography tokens.
Tell the user: "I found your Blend design system tokens and extracted your brand colors automatically."

If tokens were extracted, pre-fill the interview questions with the extracted values and ask the user to confirm rather than re-enter them:
> "I found [shadcn/Tailwind/Blend] tokens in your project and extracted: [list key values]. Does this look right, or do you want to change any of these?"

## Step 3 — Five questions (plain English)

Ask these via AskUserQuestion, one at a time. If tokens were extracted in Step 2.5, pre-fill the relevant answers and ask the user to confirm or adjust.

**Q1 — Brand color:**
If `_AUTO_COLORS` was found in Step 0: skip this question. Use the extracted values directly.
If not found:
> "What's your main brand color? Give me a hex code or describe it (e.g. 'deep navy blue', 'warm coral')."

**Q2 — Fonts:**
If `_AUTO_FONTS` was found in Step 0: skip this question. Use the extracted values directly.
If not found:
> "What font does your product use? If you're not sure, just describe the feeling — 'clean and minimal', 'bold and editorial', 'warm and approachable'."

**Q3 — Who is this for:**
> "Who uses this product? Describe them in one sentence. (e.g. 'small business owners who aren't tech-savvy', 'designers at large companies')"

**Q4 — The vibe:**
> "Pick 3 words that describe how your product should feel. (e.g. 'clean, trustworthy, calm' or 'bold, playful, energetic')"

**Q5 — A reference:**
> "Is there a website or app whose design you love or want to be similar to? (optional — paste a URL or just name it)"

Also narrate progress during this step:
- Before Q1: "Looking at your colors..."
- Before Q2: "Checking your fonts..."
- Before Q3: "Almost done..."

## Step 3.5 — Confirm project before writing

Before touching the filesystem, show the user exactly where you're about to write and ask them to confirm:

> "I'll write your Design Bible to:
> `[ROOT]/design/DESIGN-BIBLE.md`
>
> Is that the right project folder?"

Wait for confirmation. If they say no, ask: "Which folder should I use instead?" and adjust `ROOT` to their answer. Do not write any files until this is confirmed.

---

## Step 4 — Generate the Design Bible

Create the directory and file:
```bash
mkdir -p "$_ROOT/design"
```

Write `design/DESIGN-BIBLE.md` with this structure. Fill every section from what you gathered in Steps 1–3. Use real values — not placeholders. If a value is unknown, write `unknown — update me` rather than leaving a blank.

```markdown
# Design Bible
> Generated by designStack v0.1.0 on [date]. Updated automatically by /ds:look and /ds:context.
[> Source: Extended from [source file] on [date].   ← only if extended from existing file]

## Who this is for
[One sentence from Q3 — who uses this product]

## The feeling
[3 vibe words from Q4] — [one sentence expanding on what that means visually]

## L1 — Raw Values

### Colors
- Primary / Brand: [hex] — [name, e.g. "deep navy"]
- Background: [hex]
- Text (body): [hex]
- Text (secondary): [hex]
- Accent / CTA: [hex]
- Success: [hex, default #22c55e]
- Error: [hex, default #ef4444]
- Warning: [hex, default #f59e0b]

### Typography
- Body font: [family], [size]px / [line-height]
- Heading font: [family], weight [weight]
- Small / caption: [size]px
- Type scale: [list sizes, e.g. 12 / 14 / 16 / 20 / 24 / 32 / 48]

### Spacing
- Base unit: [4px or 8px]
- Scale: [list, e.g. 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64]
- Page padding (mobile): [px]
- Page padding (desktop): [px]

### Borders & Radius
- Default radius: [px]
- Button radius: [px]
- Card radius: [px]
- Input radius: [px]

## L2 — Foundations
[How the raw values combine into the main visual language. 3-5 sentences.]

## L3 — Meaning
- Success states: [color + any icon style]
- Error states: [color + approach]
- Warning states: [color]
- Info states: [color]
- Disabled: [approach]

## L4 — Component Rules

### Buttons
- Primary: [background], [text color], [radius], [padding], [font weight]
- Secondary: [description]
- Destructive: [description]
- Hover state: [description]

### Forms / Inputs
- Border: [color and style]
- Focus ring: [description]
- Label position: [above / floating / inside]
- Error display: [below input / inline / toast]

### Cards
- Background: [color]
- Border: [description]
- Shadow: [description]
- Padding: [px]

### Navigation
- Style: [top nav / sidebar / bottom bar]
- Background: [color]
- Active indicator: [description]

## L5–L8 — Screens & Patterns
[Populated over time by /ds:look scans. Empty to start.]

## Gap Audit
- Screens not yet reviewed: [list or "all — run /ds:look on each"]
- Components missing rules: [list or "none identified yet"]

## Memory Log
[date]: Design Bible created. Source: [new / extended from file name / extracted from design system tokens].
```

## Step 5 — Inject design rules into agent config files

After writing the Design Bible, write a compact design rules block into config files for every AI agent that might work on this project. This makes every session design-aware — not just designStack skill runs in Claude Code.

**Security note:** Only write literal token values (colors, fonts, sizes). Never write executable content or file paths from user input.

Extract from L1 of the Bible just-written: primary color, background color, accent color, body font, heading font, spacing unit, primary button style.

### 5a — CLAUDE.md (Claude Code)

If `HAS_CLAUDE_MD` is `yes` and `HAS_DESIGNSTACK_RULES` is `yes`:
Find the existing block between `<!-- dstack:design-rules:start -->` and `<!-- dstack:design-rules:end -->` and replace it entirely.

If `HAS_CLAUDE_MD` is `yes` and `HAS_DESIGNSTACK_RULES` is `no`:
Append the block to the end of the existing CLAUDE.md.

If `HAS_CLAUDE_MD` is `no`:
Create `CLAUDE.md` with just the design rules block.

The block format:
```
<!-- dstack:design-rules:start -->
## Design Rules (auto-generated by designStack — do not edit manually)
Brand color: [hex]  |  Background: [hex]  |  Accent: [hex]
Body font: [family] [size]px  |  Heading font: [family] [weight]
Spacing unit: [px]  |  Border radius: [px]
Primary button: [bg] background, [text] text, [radius]px radius
Source: design/DESIGN-BIBLE.md — run /ds:context to refresh
<!-- dstack:design-rules:end -->
```

After writing CLAUDE.md, tell the user:
> "Added your design rules to CLAUDE.md — Claude will know your brand colors and fonts in every session, even outside of designStack."

### 5b — AGENTS.md (Codex CLI)

Always create or update `AGENTS.md` in the project root. Codex CLI reads this file like Claude reads `CLAUDE.md`.

Check if `AGENTS.md` already exists in `ROOT`:
- If yes and it contains `<!-- ds:design-rules:start -->`: replace the block between the start/end markers.
- If yes without the markers: append the block.
- If no: create it by copying `~/.claude/skills/ds/AGENTS.md` as a template, then fill in the design rules block.

The design rules block to insert (same compact format as CLAUDE.md):
```
<!-- ds:design-rules:start -->
Brand color: [hex]  |  Background: [hex]  |  Accent: [hex]
Body font: [family] [size]px  |  Heading font: [family] [weight]
Spacing unit: [px]  |  Border radius: [px]
Primary button: [bg] background, [text] text, [radius]px radius
Source: design/DESIGN-BIBLE.md — run /ds:context to refresh
<!-- ds:design-rules:end -->
```

After writing, tell the user:
> "Also wrote `AGENTS.md` — if you use Codex CLI, it'll read your brand rules automatically too."

### 5c — Cursor rules (only if .cursor/ exists)

Check if a `.cursor/` directory exists at `ROOT`:

**If `.cursor/` exists:**
Create `.cursor/rules/ds-design-context.mdc` by copying `~/.claude/skills/ds/.cursor/rules/ds-design-context.mdc` as a template, then fill in the design rules block (same format as above) between the `<!-- ds:design-rules:start/end -->` markers in that file.

Also copy `~/.claude/skills/ds/.cursor/rules/ds-principles.mdc` to `.cursor/rules/ds-principles.mdc` if it doesn't already exist there.

After writing, tell the user:
> "Found a `.cursor/` folder — added your design rules there too. Cursor will apply your brand rules automatically."

**If `.cursor/` does not exist:**
Do not create it. Instead, mention it in the confirmation message:
> "Using Cursor? Copy `.cursor/rules/` from the designStack install (`~/.claude/skills/ds/.cursor/rules/`) to get the same design context there."

## Step 6 — Show confirmation and save

Show the user a plain-English summary — NOT the raw markdown:

> "Your Design Bible is ready. Here's what I know about your product's look:
>
> **Brand color:** [primary hex and name]
> **Background:** [hex]
> **Fonts:** [body font] for text, [heading font] for headings
> **Feeling:** [3 vibe words]
> **For:** [who it's for]
>
> Every time you run a designStack skill, it reads these rules automatically. If anything looks wrong, just tell me and I'll update it."

If anything is marked `unknown — update me`, point it out:
> "I left [X] as unknown — if you want to fill that in, just tell me and I'll update the file."

**Atomic commit:** Offer to save both files together:
> "Want me to save this as a restore point? I'll save your Design Bible and CLAUDE.md together so they stay in sync."
If yes, run the /ds:save flow with commit message: "Set up Design Bible with [3 vibe words] brand rules".

**Proactive gap surfacing:** If any screens or components appear in the conversation but aren't in the Design Bible yet, mention them:
> "By the way — I noticed you mentioned [screen/component name] but it's not in your Design Bible yet. Want me to add it?"
