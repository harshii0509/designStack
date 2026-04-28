Walk the user through installing designStack. Present each command and ask them to run it using `! <command>` in chat. Wait for confirmation before each next step.

Opening:
"Let's install designStack. Run each command by typing it after `!` in this chat — like `! git clone ...`. I'll walk you through 3 quick steps."

Step 1 — Download:
Command to run: `! git clone https://github.com/harshii0509/designStack.git ~/.claude/skills/ds`
Wait for success confirmation.

Step 2 — Setup:
Command to run: `! ~/.claude/skills/ds/setup`
Wait for setup to complete.

Step 3 — Done:
Tell the user: "Restart Claude Code so it picks up the new skills, then open your project folder and type /ds:start"

Optionally ask if they want the designStack routing block added to the current project's CLAUDE.md. If yes, append the block from the setup script output to ./CLAUDE.md (create if missing).
