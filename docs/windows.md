# Windows setup with WSL

designStack is supported on Windows through WSL.

## What to install

1. Install [WSL](https://learn.microsoft.com/windows/wsl/install)
2. Install Ubuntu or another Linux distro inside WSL
3. Install [Claude Code](https://claude.ai/code) inside that Linux environment
4. Install `git` inside WSL

## Recommended flow

Open your WSL terminal, then run:

```bash
npx skills@latest add harshii0509/designStack
```

If Claude Code was already open, restart it. Then run:

```text
/ds-start
```

## Common issues

- `claude` not found:
  Install Claude Code inside WSL, not only on the Windows side.
- `git` not found:
  Run `sudo apt update && sudo apt install git`.
- Skills not appearing:
  Restart Claude Code after install.

## If setup still feels wrong

Run:

```bash
~/.claude/skills/ds/bin/designStack-check
```
