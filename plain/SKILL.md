---
name: designStack:plain
version: 0.1.0
description: Translate any Claude plan into plain English before you say yes. Shows what changes, what gets deleted, what's new, and how risky it is. Always ask before running this skill.
---

## Preamble

```bash
_DESIGNSTACK_VER="0.1.0"
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
# Count files that would be touched (rough signal for change size)
_CHANGED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
_STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "CHANGED_FILES: $_CHANGED"
echo "STAGED_FILES: $_STAGED"
```

## What this skill does

You translate the current plan — whatever Claude just proposed or is about to do — into plain English that anyone can understand. No code, no jargon, no assumptions.

**Run this before any plan with more than 2 steps, or whenever the user says they're confused.**

## Step 1 — Understand the plan

Read the current conversation context. Identify:
- What Claude is about to do (or just proposed)
- Which files will be touched
- What will be created (new things that don't exist yet)
- What will be changed (existing things that will look different)
- What will be deleted (things that will be removed — always flag these explicitly)
- How many files are involved
- Whether any data could be lost

## Step 2 — Write the plain-English translation

Output this structure — no markdown headers, just clear prose with simple bullets:

---

**Here's what's about to happen, in plain English:**

What we're building / changing:
[One sentence: what is the overall goal of this plan?]

**What will CHANGE** (things that exist now but will look or work differently):
- [specific change in plain terms — e.g. "The sign-in button will move from the bottom to the top right of the page"]
- [another change]

**What will be ADDED** (new things that don't exist yet):
- [e.g. "A new page for your pricing information"]
- [e.g. "A loading animation when the form submits"]

**What will be REMOVED** ⚠️ (things that will be deleted):
- [e.g. "The existing contact form will be replaced — you'll lose any custom styling on it"]
- [If nothing is being deleted: "Nothing is being deleted in this step."]

**How big is this change?**
[Pick one:]
- Small tweak — quick to do, easy to undo
- Medium change — takes a few minutes, easy to undo if needed
- Big change — about 15 minutes to complete, harder to undo. Run `/designStack:save` first.

---

## Step 3 — Plain-English jargon replacements

When writing the translation, apply these replacements automatically. Never use the left column:

| Technical term | Plain English |
|---|---|
| component | piece of the page |
| refactor | reorganize (without changing how it looks) |
| breaking change | this will temporarily stop working |
| deploy | make it live / publish it |
| merge | combine these two things |
| deprecate | phase out (stop using this) |
| API | the connection between two systems |
| state | the information the page is tracking |
| props / properties | settings you pass into a piece of the page |
| hook | a reusable behavior |
| render | draw on screen |
| async | happens in the background |
| dependency | another tool this one needs to work |
| env variable | a secret setting stored outside the code |
| migration | moving data from one format to another |
| lint | automated spelling/grammar check for code |
| build | package everything up to be published |

## Step 4 — Confirmation gate

**Always ask before proceeding.** End with:

> **Does this match what you had in mind?**
>
> A) Yes, go ahead
> B) No, let me describe what I actually want
> C) Wait — tell me more about [specific part]

If user says B: ask them to describe what they actually wanted in their own words, then revise the plan.

If user says C: explain that specific part in more detail without any jargon.

**Never write a single line of code until the user says A (or equivalent confirmation in their own words).**

## Step 5 — Risk flags

If the change is "Big", add this note before the confirmation:

> ⚠️ This is a bigger change — harder to undo once it starts. I'd recommend running `/designStack:save` first to create a restore point you can come back to if anything goes wrong.
