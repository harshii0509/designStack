---
name: designStack:animate
version: 0.1.0
description: Add motion to your product. Tell me what feels too static — buttons, page transitions, loading states — and I'll add animations that feel natural, not showy. Before/after screenshots included.
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
[ -z "$_B" ] && [ -x "$HOME/.claude/skills/designStack/browse/dist/browse" ] && _B="$HOME/.claude/skills/designStack/browse/dist/browse"
# Check for gstack's animate skill as underlying engine
_ANIMATE=""
[ -f "$HOME/.agents/skills/animate/SKILL.md" ] && _ANIMATE="$HOME/.agents/skills/animate/SKILL.md"
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "DESIGN_BIBLE: $_HAS_BIBLE"
echo "BROWSE: ${_B:-NOT_FOUND}"
echo "UNDERLYING_ANIMATE: ${_ANIMATE:-not found}"
```

## What this skill does

Right now your site probably feels a little flat or stiff. Motion fixes that. I add small, purposeful animations that make things feel alive — buttons that respond when you click them, pages that transition smoothly, loading states that feel fast instead of frozen.

> "Tell me what feels too static — buttons? Page transitions? Everything? I'll add motion that feels natural, not over-the-top."

Dstack's approach to animation: **less is more**. Every animation should have a reason. We never animate just to animate.

## Step 1 — Load Design Bible vibe

If `DESIGN_BIBLE` is `yes`, read the "The feeling" section.

Let the vibe words guide animation style:
- **"calm, focused, minimal"** → very subtle animations, longer durations (300–400ms), ease-out only
- **"bold, energetic, playful"** → more expressive animations, spring physics, bouncy easing
- **"warm, approachable"** → gentle fades, soft movements, nothing too mechanical
- **"professional, trustworthy"** → barely-there animations, functional only (not decorative)

If no Design Bible: default to subtle and purposeful.

## Step 2 — Understand what the user wants to animate

Ask:
> "What feels too static right now? Pick the things that bother you most:
>
> A) **Buttons** — they click but nothing happens visually
> B) **Page transitions** — jumping from page to page feels abrupt
> C) **Loading states** — the page just sits there while things load
> D) **Elements appearing** — content just pops in instead of flowing in
> E) **Forms** — filling in fields feels mechanical
> F) **Something specific** — I'll describe it
> G) **Everything** — just make the whole site feel more alive"

If G: prioritize in this order — page load/appearance, button interactions, transitions, loading states.

## Step 3 — Take a before screenshot

If browse available:
```bash
$B goto <URL>
$B screenshot /tmp/dstack-animate-before.png
```
Show it: "Here's what it looks like now. Let me add some motion."

## Step 4 — Propose the animations

Before writing any code, show the user what you're planning in plain English:

---

**Here's what I'll add:**

[For each animation:]
**[Where]:** [the element — e.g. "The 'Get started' button"]
**Motion:** [plain English — e.g. "Gently scales up 3% when you hover over it, and gives a quick press-down feeling when you click"]
**Speed:** [e.g. "Quick — 150ms — so it feels responsive, not slow"]
**Why:** [e.g. "Right now clicking it gives no feedback — this makes it feel alive and confirms the click registered"]

---

Ask: "Does this sound right? Anything you want me to skip or add?"

## Step 5 — Implement the animations

**Never add animations that:**
- Take more than 500ms (they feel slow, not elegant)
- Loop continuously unless there's a functional reason (like a loading spinner)
- Animate on every single scroll (too noisy)
- Move more than ~8–12px from original position (too much movement)
- Use bounce/spring for anything serious/professional

**Plain English timing guide:**
- "Quick" = 100–150ms — button clicks, micro-interactions
- "Natural-feeling" = 200–300ms — hover states, small transitions
- "Smooth" = 300–400ms — page-level transitions, modals appearing
- "Slow and deliberate" = 400–600ms — hero animations, first-load reveals (use sparingly)

**Easing guide (in plain English):**
- `ease-out` (starts fast, slows down) = most natural for things appearing or expanding
- `ease-in` (starts slow, speeds up) = for things disappearing or collapsing
- `ease-in-out` = for things moving from one place to another
- Never use `linear` for UI — it feels robotic

**Animation recipes to apply based on user's choices:**

*Buttons:*
```css
transition: transform 150ms ease-out, box-shadow 150ms ease-out;
&:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
&:active { transform: translateY(0px); box-shadow: 0 1px 4px rgba(0,0,0,0.1); }
```

*Elements appearing on page load:*
```css
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(12px); }
  to   { opacity: 1; transform: translateY(0); }
}
animation: fadeInUp 300ms ease-out both;
```

*Page transitions (for client-side routing):*
```css
/* Exiting page */
@keyframes fadeOut { to { opacity: 0; } }
/* Entering page */
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
```

*Loading spinner:*
```css
@keyframes spin { to { transform: rotate(360deg); } }
animation: spin 800ms linear infinite;
```

*Form focus:*
```css
transition: border-color 200ms ease-out, box-shadow 200ms ease-out;
&:focus { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(accent, 0.15); }
```

*Staggered list reveal:*
```css
/* Each child gets an increasing delay */
animation: fadeInUp 300ms ease-out both;
animation-delay: calc(var(--index) * 60ms);
```

**Respect accessibility: always wrap animations in:**
```css
@media (prefers-reduced-motion: reduce) {
  * { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }
}
```
This ensures animations are disabled for users who have turned off motion in their system settings (motion sensitivity, vestibular disorders).

## Step 6 — Show the after

If browse available, revisit the page and take a screenshot:
```bash
$B goto <URL>
$B screenshot /tmp/dstack-animate-after.png
```

Note: screenshots can't capture motion, so acknowledge this:
> "Screenshots can't show the motion — you'll need to visit the page to see it in action. Here's what the static view looks like, which should be identical to before (animations are invisible until you interact)."

If possible, record a short demo using browser automation to show hover/click states.

## Step 7 — Summary

> "Done! Here's what's now animated:
>
> [List each added animation in plain English]
>
> **A note on animation:** I've set everything up to respect users who prefer reduced motion — if someone has that setting turned on in their phone or computer, the animations will automatically be skipped for them. That's the right thing to do.
>
> If anything feels too fast, too slow, or just wrong — tell me and I'll adjust it."

## Design Bible update

If the vibe was used to guide animation style, append to Memory Log:
```
[date]: /animate run. Added: [list of what was animated]. Style: [quick/natural/slow] — based on vibe words: [words].
```
