Guide the user through installing designStack step by step. Do not run any of these commands yourself — present each one and ask the user to run it by typing `! <command>` in the chat, then wait for their confirmation before moving on.

---

Say this first:
> "Let's install designStack. I'll walk you through 3 quick steps — you'll run each command yourself so you can see exactly what's happening. Type each command after the `!` in this chat window and it'll run in your terminal."

**Step 1 — Download the skills**

Tell the user:
> "Step 1 of 3: Download the designStack skills folder into Claude Code."
> Ask them to run: `! git clone https://github.com/harshii0509/designStack.git ~/.claude/skills/ds`
> Explain: "This clones the designStack repo into your Claude Code skills folder. Nothing runs yet — it's just downloading files."

Wait for them to confirm it worked (no error message), then continue.

**Step 2 — Run setup**

Tell the user:
> "Step 2 of 3: Run the setup script. This creates a couple of folders and checks your environment."
> Ask them to run: `! ~/.claude/skills/ds/setup`
> If they ask what it does: "It checks that the browse tool is available and creates the design/ folder structure. You'll see all output — nothing is hidden."

Wait for them to confirm it finished, then continue.

**Step 3 — Add routing rules to your global Claude config**

Tell the user:
> "Step 3 of 3: Add the skill routing rules to your global Claude config so Claude knows when to use designStack."

Show them exactly what will be added (as a preview block):

```
# designStack
- **designStack** is installed. Use designStack skills for design rules, visual QA, accessibility, and error recovery.
- `/ds:start` — First session wizard. Run this once per project.
- `/ds:context` — Refresh your Design Bible when your brand changes.
- `/ds:plain` — Translate any Claude plan into plain English before you accept it.
- `/ds:unstuck` — Something broke. Get a plain-English diagnosis.
- `/ds:look` — Does it look right? Visual check against your brand rules.
- `/ds:mobile` — Check it on phone, tablet, and desktop.
- `/ds:a11y` — Accessibility grade A–D with every problem marked.
- `/ds:save` — Save your progress with a human-readable description.
- `/ds:share` — Deploy and get a shareable link.
```

Ask: "Want me to add this to your `~/.claude/CLAUDE.md` now?"

Only if they say yes: append the block above to `~/.claude/CLAUDE.md` (create the file if it doesn't exist). Use the Edit or Write tool — do not run a shell command for this step.

---

After all 3 steps are done, ask:
> "Would you also like to add designStack to this project's CLAUDE.md so it's set up for anyone who works on it? (Recommended for team projects.)"

If yes, append the same designStack section to `./CLAUDE.md` in the current directory.

Then tell them:
> "You're all set. Open your project folder and type `/ds:start` — the setup wizard takes about 5 minutes."
