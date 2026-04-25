Install designStack: run `git clone https://github.com/harshii0509/designStack.git ~/.claude/skills/ds` and then run `~/.claude/skills/ds/setup --quiet`. Then add a "designStack" section to ~/.claude/CLAUDE.md with these routing rules:

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

After that, ask the user: "Would you also like to add designStack to this project's CLAUDE.md so it's set up for anyone who works on it? (Recommended if this is a team project.)" If yes, append the same designStack section to ./CLAUDE.md in the current directory (create the file if it doesn't exist). Then tell them: "You're all set. Open your project folder and type /ds:start — the setup wizard takes about 5 minutes."
