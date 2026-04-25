# Four Principles for Building with AI — designStack

Most designers using Claude Code hit the same wall.

They type "make it look better." Claude builds something they didn't want. They ask it to fix it. Claude breaks something else. They close the laptop.

The problem isn't Claude. It's that **vague instructions produce vague results**. These four principles fix that.

---

## 1. Think in references, not descriptions

**The pitfall:** "Make it more modern." "Clean up the spacing." "The hero feels off." These are feelings, not instructions. Claude interprets them differently every time — and you have no way to tell it's wrong until something is already built.

**The fix:** Show the target. Don't describe it. Run `/ds:look` to anchor Claude to what you're actually seeing. Paste a reference URL. Name the exact element. The more concrete the target, the closer Claude gets.

Instead of: *"The typography feels wrong"*
Try: *"Run `/ds:look` — the heading on mobile is too large. Flag anything over 24px."*

Instead of: *"Make the buttons look better"*
Try: *"The primary button should match the style at [URL]. White background, black text, no border radius."*

## 2. Write the Bible once

**The pitfall:** Every new Claude session, you re-explain your brand colors. Your fonts. What "clean" means to you. Claude builds the wrong thing. You correct it. It forgets next session. You correct it again. An hour of your week is just context-setting.

**The fix:** Run `/ds:context` once per project. It reads your code and asks five questions. Then it writes a Design Bible — a file Claude reads automatically at the start of every session. You explain your brand once. Claude knows it forever.

Your brand rules shouldn't live in your head. They should live in a file.

Instead of: *[re-explaining brand in every session]*
Try: *Run `/ds:context` once. Never explain your brand again.*

## 3. Read before you say yes

**The pitfall:** Claude writes a plan. It's full of file names, function calls, a "refactoring strategy." You don't understand it. You click yes anyway because it sounds confident. Something breaks. You spend an hour undoing it — or worse, you don't realize something broke at all.

**The fix:** If you can't read the plan, you're not ready to approve it. Run `/ds:plain` before you agree to anything. It translates the plan into plain English before a single line of code is touched. If the translation still doesn't make sense, that's Claude telling you something is off.

Don't click yes on something you can't read.

Instead of: *[clicking yes on a plan full of jargon]*
Try: *Run `/ds:plain`. Read it in plain English. Then decide.*

## 4. Save before you fly

**The pitfall:** You've been building for two hours. Everything looks good. Claude suggests a "small cleanup." You say yes. It rewrites three files. Something breaks in a way you don't understand. You can't remember exactly what the site looked like before. You can't undo it.

**The fix:** Run `/ds:save` before any session where Claude will touch your code. It takes 10 seconds and creates a named restore point — a snapshot you can always come back to, no matter what breaks.

The first time you need it and don't have it, you'll save before every session for the rest of your life.

Instead of: *[building for two hours with no safety net]*
Try: *`/ds:save` first. Then build whatever you want.*

---

## The tradeoff

These principles bias toward **caution over speed**. For trivial changes — tweaking a color, fixing a typo, asking Claude a question — the overhead isn't worth it. Use your judgment.

The wins come on sessions where you're building something new, changing something significant, or working with a codebase you don't fully understand. Which, if you're a designer using Claude Code, is most sessions.

---

*These principles work with or without designStack. But `/ds:look`, `/ds:plain`, `/ds:context`, and `/ds:save` make each one take seconds instead of minutes.*

*[Install designStack →](https://github.com/harshii0509/designStack)*
