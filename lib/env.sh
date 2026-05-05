#!/usr/bin/env bash
# designStack shared preamble. Call once per skill run.
# Usage: "$HOME/.claude/skills/ds/lib/env.sh" "skillname"
# Outputs structured vars for the AI to read. Handles upgrade check,
# Bible migration, Bible detection, browse detection, telemetry start.

_SKILL="${1:-unknown}"
_DESIGNSTACK_VER=$(cat "$HOME/.claude/skills/ds/VERSION" 2>/dev/null || echo "0.3.0")
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")

# Upgrade check (fires for all skills, not just root dispatcher)
_UPD=$([ -x "$HOME/.claude/skills/ds/bin/ds-update-check" ] \
  && "$HOME/.claude/skills/ds/bin/ds-update-check" 2>/dev/null || true)
[ -n "$_UPD" ] && echo "$_UPD"

# One-time Bible migration: dstack/ → design/
if [ -f "$_ROOT/dstack/DESIGN-BIBLE.md" ] && [ ! -f "$_ROOT/design/DESIGN-BIBLE.md" ]; then
  mkdir -p "$_ROOT/design"
  mv "$_ROOT/dstack/DESIGN-BIBLE.md" "$_ROOT/design/DESIGN-BIBLE.md"
  echo "MIGRATED: Design Bible moved to design/ — same rules, new home."
fi

# Bible detection (in priority order)
_BIBLE="$_ROOT/design/DESIGN-BIBLE.md"
_HAS_BIBLE="no"
_BIBLE_SOURCE=""
[ -f "$_BIBLE" ] \
  && _HAS_BIBLE="yes" && _BIBLE_SOURCE="design/DESIGN-BIBLE.md"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/DesignBrain.md" ] \
  && _HAS_BIBLE="yes" && _BIBLE_SOURCE="DesignBrain.md" && _BIBLE="$_ROOT/DesignBrain.md"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/ICP-CONTEXT.md" ] \
  && _HAS_BIBLE="yes" && _BIBLE_SOURCE="ICP-CONTEXT.md" && _BIBLE="$_ROOT/ICP-CONTEXT.md"
[ "$_HAS_BIBLE" = "no" ] && [ -f "$_ROOT/DESIGN.md" ] \
  && _HAS_BIBLE="yes" && _BIBLE_SOURCE="DESIGN.md" && _BIBLE="$_ROOT/DESIGN.md"

# Browse binary
_B=""
[ -x "$HOME/.claude/skills/ds/browse/dist/browse" ] \
  && _B="$HOME/.claude/skills/ds/browse/dist/browse"

# Last commit
_LAST_COMMIT=$(git log -1 --pretty=format:"%h — %s" 2>/dev/null || echo "no history yet")

# Telemetry start — write session file so telemetry-end.sh can read it
_TEL_START=$(date +%s)
_SESSION_ID="${_SKILL}-$$-${_TEL_START}"
mkdir -p "$HOME/.dstack/analytics"
printf "TEL_START=%s\nSESSION_ID=%s\n" "$_TEL_START" "$_SESSION_ID" \
  > "/tmp/dstack-${_SKILL}-session.env" 2>/dev/null || true
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"'"$_SKILL"'","event":"started","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true

echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "DESIGN_BIBLE: $_HAS_BIBLE | source: ${_BIBLE_SOURCE:-none}"
echo "BIBLE_PATH: ${_BIBLE}"
echo "BROWSE: ${_B:-NOT_FOUND}"
echo "LAST_COMMIT: $_LAST_COMMIT"
echo "TEL_START: $_TEL_START"
echo "SESSION_ID: $_SESSION_ID"
