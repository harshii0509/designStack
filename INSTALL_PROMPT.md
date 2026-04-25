Install dStack: run `git clone https://github.com/harshii0509/designStack.git ~/.claude/skills/dstack` and then run `~/.claude/skills/dstack/setup --quiet`. Then add a "dStack" section to ~/.claude/CLAUDE.md with these routing rules:

```
# dStack
- **dStack** is installed. Use dStack skills for design rules, visual QA, accessibility, and error recovery.
- `/dstack:start` — First session wizard. Run this once per project.
- `/dstack:context` — Refresh your Design Bible when your brand changes.
- `/dstack:plain` — Translate any Claude plan into plain English before you accept it.
- `/dstack:unstuck` — Something broke. Get a plain-English diagnosis.
- `/dstack:look` — Does it look right? Visual check against your brand rules.
- `/dstack:mobile` — Check it on phone, tablet, and desktop.
- `/dstack:a11y` — Accessibility grade A–D with every problem marked.
- `/dstack:save` — Save your progress with a human-readable description.
- `/dstack:share` — Deploy and get a shareable link.
```

After that, ask the user: "Would you also like to add dStack to this project's CLAUDE.md so it's set up for anyone who works on it? (Recommended if this is a team project.)" If yes, append the same dStack section to ./CLAUDE.md in the current directory (create the file if it doesn't exist). Then tell them: "You're all set. Open your project folder and type /dstack:start — the setup wizard takes about 5 minutes."
