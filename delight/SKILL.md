---
name: ds:delight
version: 0.1.0
description: Add moments of joy to your product. Find the two moments where users succeed or arrive for the first time — and make those moments feel special. Subtle, intentional, on-brand.
---

## Preamble

```bash
_DESIGNSTACK_VER="0.1.0"
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
_BIBLE="$_ROOT/dstack/DESIGN-BIBLE.md"
_HAS_BIBLE="no"
[ -f "$_BIBLE" ] && _HAS_BIBLE="yes"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/DesignBrain.md" ] && _HAS_BIBLE="yes"
_B=""
[ -x "$HOME/.claude/skills/gstack/browse/dist/browse" ] && _B="$HOME/.claude/skills/gstack/browse/dist/browse"
[ -z "$_B" ] && [ -x "$HOME/.claude/skills/ds/browse/dist/browse" ] && _B="$HOME/.claude/skills/ds/browse/dist/browse"
# Check for gstack's delight skill
_DELIGHT=""
[ -f "$HOME/.agents/skills/delight/SKILL.md" ] && _DELIGHT="$HOME/.agents/skills/delight/SKILL.md"
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "DESIGN_BIBLE: $_HAS_BIBLE"
echo "BROWSE: ${_B:-NOT_FOUND}"
echo "UNDERLYING_DELIGHT: ${_DELIGHT:-not found}"
```

## What this skill does

The best products have moments that make you smile. Not silly — just thoughtful. The "you did it" confetti. The empty state that makes you feel welcomed instead of lost. The little thing that makes your product feel like it was built by someone who cared.

That's what this skill adds.

**Two focus areas (always start here):**
1. **The success moment** — when a user completes something important (submits a form, finishes onboarding, makes their first purchase, creates their first item)
2. **The first-time experience** — when a user arrives for the very first time and sees nothing yet

These two moments have the most impact and the most room to feel special.

> "Where do users succeed in your app? Tell me about the moment when they accomplish something — the first time they do the thing your product is built for."

## Step 1 — Load the Design Bible vibe

If `DESIGN_BIBLE` is `yes`, read "The feeling" section.

Let the vibe words guide delight style:
- **"calm, focused"** → subtle celebration. A gentle color pulse, a quiet checkmark animation. No confetti.
- **"warm, approachable"** → a friendly success message with warmth. Maybe a small illustrated character. Soft animation.
- **"bold, playful"** → real celebration. Confetti, color burst, expressive copy. Go for it.
- **"professional, minimal"** → almost invisible delight. A smooth checkmark, clean success state, precise copy. Restraint is the delight.

## Step 2 — Understand their product

Ask:
> "Tell me about two moments in your product:
>
> 1. **The success moment** — what's the most important thing a user can do? When they finish it, what happens right now? (e.g. 'they submit the form and just get a gray text message')
> 2. **The empty moment** — when a new user first signs up and there's nothing yet, what do they see? (e.g. 'just a blank list with nothing in it')"

Also ask:
> "Is there any other moment that feels flat to you? Somewhere you wish the product felt more alive?"

## Step 3 — Take screenshots of the current moments

If browse available:

```bash
# Success state
$B goto <success page or show success state>
$B screenshot /tmp/dstack-delight-success-before.png

# Empty state
$B goto <empty state URL>
$B screenshot /tmp/dstack-delight-empty-before.png
```

Show both screenshots.

## Step 4 — Design the delight moments

For each moment, propose specific, concrete delight additions. Show the plan before writing code.

---

### Moment 1: The success moment

**What's happening now:** [description from user]
**What I'll add:**

[Pick from these based on the vibe:]

**Option A — Confetti burst (for playful/bold products)**
A shower of colored confetti bursting from the center of the screen. Uses the brand colors. Lasts 2 seconds then fades. Add to: the moment the form submits or the action completes.

**Option B — Checkmark celebration (for calm/professional products)**
A large animated checkmark draws itself on screen. Smooth, satisfying. Paired with a genuine, human success message. No gimmicks.

**Option C — Color pulse (for minimal products)**
The background briefly flashes to the accent color and fades back. 600ms. Barely there — just enough to feel intentional.

**Option D — Progress completion**
A progress bar that fills to 100% with a satisfying pop, then transitions to the success state. Paired with specific encouraging copy.

**Success copy** (always rewrite the generic "Success!" message):
- Instead of: "Form submitted successfully."
- Write: "[Specific thing they did] — you're all set! [What happens next]."
Example: "Your project is live. Anyone with the link can see it now."
Example: "Account created. Let's get started."

---

### Moment 2: The empty/first-time experience

**What's happening now:** [description from user]
**What I'll add:**

**Option A — The welcome illustration**
A small, on-brand illustration (or emoji composition) in the empty space. Not stock art — something that fits the vibe. Plus a warm headline: "Nothing here yet" → "Your [things] will live here" + a clear first action button.

**Option B — The guide rails**
Instead of empty nothingness: a ghost/placeholder card showing what a real item will look like, with gentle copy: "Your first [thing] will look like this." Click to create.

**Option C — The personal welcome**
If you know the user's name: "Hi [name], you're all set. Here's where to start." With a clear single next action — not 5 options, just one.

**Option D — The sample content**
Auto-populate 1–2 example items so the interface doesn't feel empty. Label them clearly as examples. Let users delete them when ready.

---

Ask the user: "Which of these feels right for your product's personality? Or describe something different and I'll build it."

## Step 5 — Build it

After confirmation, implement the chosen delight moments.

**Technical approach:**

For confetti: use canvas-confetti library (CDN, no install needed):
```html
<script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.2/dist/confetti.browser.min.js"></script>
<script>
function celebrate() {
  confetti({
    particleCount: 80,
    spread: 70,
    colors: ['#BRAND_COLOR', '#ACCENT_COLOR', '#SECONDARY'],
    origin: { y: 0.6 }
  });
}
</script>
```

For checkmark animation (CSS only):
```css
@keyframes drawCheck {
  from { stroke-dashoffset: 100; }
  to   { stroke-dashoffset: 0; }
}
.checkmark path {
  stroke-dasharray: 100;
  stroke-dashoffset: 100;
  animation: drawCheck 500ms ease-out 200ms forwards;
}
```

For empty states: write a proper React/HTML component with illustration + headline + CTA.

Always wrap animations in `prefers-reduced-motion` media query.

**No sound design in v1.** Sound requires system permission dialogs and is too disruptive. Skip it.

## Step 6 — Show the after

If browse available:
```bash
$B goto <success URL>
$B screenshot /tmp/dstack-delight-success-after.png

$B goto <empty state URL>
$B screenshot /tmp/dstack-delight-empty-after.png
```

Show before and after for each moment:
> "Here's the difference:"
[before / after side by side for success moment]
[before / after side by side for empty state]

## Step 7 — Wrap up

> "Done! Here's what changed:
>
> **Success moment:** [what was added — e.g. "A checkmark animation appears with the message: 'Project saved — you can always come back to this.'"]
>
> **Empty state:** [what was added — e.g. "New users now see a friendly welcome with a single 'Create your first project' button instead of a blank screen"]
>
> These moments are small but they matter. They're the things users remember and tell other people about.
>
> Want to add delight anywhere else? Tell me which moment feels flat."

## Design Bible update

Append to Memory Log:
```
[date]: /delight run. Added: [success moment description]. [Empty state description]. Vibe reference: [words from Bible].
```

If the illustration or copy style established a new pattern, note it in L4 Component Rules:
```
### Delight Patterns
- Success state: [description]
- Empty state: [description]
- Celebration style: [confetti / checkmark / pulse / etc]
```
