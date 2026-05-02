---
name: ds-upgrade
version: 0.3.0
description: |
  Upgrade designStack to the latest version. Detects the standard install path,
  runs the update script, shows what's new. Use when asked to "upgrade designStack",
  "update designStack", "/ds:upgrade", or "/ds:update".
  Triggers: /ds:upgrade, /ds:update, update designStack.
license: MIT
allowed-tools:
  - Bash
  - AskUserQuestion
  - Read
compatibility: Standard install at ~/.claude/skills/ds with git remote.
---

# /ds:upgrade — Update designStack

Keep users on the latest designStack with the same flow as the root skill’s update check.

## Inline upgrade flow (from root `/ds` preamble)

When root `SKILL.md` printed `UPGRADE_AVAILABLE <old> <new>` from `ds-update-check`, **read this file** and run **Step 1** before continuing to the sub-skill the user asked for.

### Step 1: Auto-upgrade or ask

Resolve auto-upgrade:

```bash
_AUTO=""
[ "${DS_AUTO_UPGRADE:-}" = "1" ] && _AUTO="true"
if [ -z "$_AUTO" ] && [ -f "$HOME/.ds/config.yaml" ]; then
  if grep -qiE '^[[:space:]]*auto_upgrade:[[:space:]]*true' "$HOME/.ds/config.yaml" 2>/dev/null; then
    _AUTO="true"
  fi
fi
echo "AUTO_UPGRADE=${_AUTO:-false}"
```

**If `AUTO_UPGRADE=true`:** Skip AskUserQuestion. Tell the user you're auto-upgrading designStack v{old} → v{new}, then go to **Step 2**. If the update script fails, say auto-upgrade failed and suggest running `/ds:upgrade` manually.

**Else** use **AskUserQuestion**:
- Question: "designStack **v{new}** is available (you're on v{old}). Upgrade now?"
- Options: `["Yes, upgrade now", "Always keep me up to date", "Not now", "Never ask again"]`

**"Yes, upgrade now"** → **Step 2**

**"Always keep me up to date":**

```bash
mkdir -p "$HOME/.ds"
_CFG="$HOME/.ds/config.yaml"
if [ ! -f "$_CFG" ]; then
  echo "update_check: true" > "$_CFG"
  echo "auto_upgrade: true" >> "$_CFG"
else
  if grep -qiE '^[[:space:]]*auto_upgrade:' "$_CFG" 2>/dev/null; then
    sed -i.bak 's/^[[:space:]]*auto_upgrade:.*/auto_upgrade: true/' "$_CFG" 2>/dev/null || \
      perl -i -pe 's/^\s*auto_upgrade:.*/auto_upgrade: true/' "$_CFG" 2>/dev/null || true
  else
    echo "auto_upgrade: true" >> "$_CFG"
  fi
  rm -f "$_CFG.bak" 2>/dev/null || true
fi
```

Say: "Auto-upgrade is on — future releases will install without asking." Then **Step 2**.

**"Not now":** Write snooze (same version escalation as gstack):

```bash
_SNOOZE_FILE="$HOME/.ds/update-snoozed"
_REMOTE_VER="{new}"
_CUR_LEVEL=0
if [ -f "$_SNOOZE_FILE" ]; then
  _SNOOZED_VER=$(awk '{print $1}' "$_SNOOZE_FILE")
  if [ "$_SNOOZED_VER" = "$_REMOTE_VER" ]; then
    _CUR_LEVEL=$(awk '{print $2}' "$_SNOOZE_FILE")
    case "$_CUR_LEVEL" in *[!0-9]*) _CUR_LEVEL=0 ;; esac
  fi
fi
_NEW_LEVEL=$((_CUR_LEVEL + 1))
[ "$_NEW_LEVEL" -gt 3 ] && _NEW_LEVEL=3
echo "$_REMOTE_VER $_NEW_LEVEL $(date +%s)" > "$_SNOOZE_FILE"
```

Tell the user the next reminder timing: level 1 → 24h, 2 → 48h, 3+ → 7 days. Tip: they can set `auto_upgrade: true` in `~/.ds/config.yaml`. **Continue** with the skill the user originally invoked — do not upgrade.

**"Never ask again":**

```bash
mkdir -p "$HOME/.ds"
_CFG="$HOME/.ds/config.yaml"
if [ ! -f "$_CFG" ]; then
  echo "update_check: false" > "$_CFG"
else
  if grep -qiE '^[[:space:]]*update_check:' "$_CFG" 2>/dev/null; then
    sed -i.bak 's/^[[:space:]]*update_check:.*/update_check: false/' "$_CFG" 2>/dev/null || \
      perl -i -pe 's/^\s*update_check:.*/update_check: false/' "$_CFG" 2>/dev/null || true
  else
    echo "update_check: false" >> "$_CFG"
  fi
  rm -f "$_CFG.bak" 2>/dev/null || true
fi
```

Say: "Update checks are off. To turn them back on, set `update_check: true` in `~/.ds/config.yaml` or remove that line." **Continue** with the original skill.

### Step 2: Install directory

Standard install:

```bash
INSTALL_DIR="$HOME/.claude/skills/ds"
if [ ! -d "$INSTALL_DIR/.git" ]; then
  echo "ERROR: No git install at $INSTALL_DIR — reinstall with the curl command from the README."
  exit 1
fi
echo "INSTALL_DIR=$INSTALL_DIR"
```

If not a git repo, stop with plain-English reinstall instructions (don’t mutate the user’s tree).

### Step 3: Remember old version and run update

```bash
OLD_VERSION=$(cat "$INSTALL_DIR/VERSION" 2>/dev/null | tr -d '[:space:]' || echo "unknown")
```

Run the bundled updater (handles `git pull --ff-only`, CHANGELOG snippet, `setup --quiet`):

```bash
bash "$INSTALL_DIR/bin/designStack-update"
```

Capture output for the user.

### Step 4: Post-upgrade marker and cache

```bash
mkdir -p "$HOME/.ds"
echo "$OLD_VERSION" > "$HOME/.ds/just-upgraded-from"
rm -f "$HOME/.ds/last-update-check" "$HOME/.ds/update-snoozed"
```

### Step 5: Summarize

Read `$INSTALL_DIR/CHANGELOG.md` if it exists. Summarize **5–7 bullets** of user-facing changes between **v{old}** and the new **VERSION** (read `VERSION` again after update). Keep tone friendly and non-technical.

Then **continue** with whatever the user was doing (the original `/ds:*` command).

---

## Standalone `/ds:upgrade` or `/ds:update`

1. Force a fresh check:

```bash
"$HOME/.claude/skills/ds/bin/ds-update-check" --force 2>/dev/null || true
```

2. If output is `UPGRADE_AVAILABLE <old> <new>`: follow **Step 1** onward (substitute `{old}` / `{new}`).

3. If no upgrade line: read `$HOME/.claude/skills/ds/VERSION` and say they're on the latest v{X}.

4. If output is `JUST_UPGRADED <from> <to>`: one line — "You're on designStack v{to} (just updated from v{from})." Then offer changelog highlights if useful.
