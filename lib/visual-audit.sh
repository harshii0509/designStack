#!/usr/bin/env bash
# Shared visual audit helpers for look, brand, mobile, a11y, polish.
# Usage: "$HOME/.claude/skills/ds/lib/visual-audit.sh" <subcommand> [args]
#
# Subcommands:
#   screenshot <url> <skill> <variant>          — takes a screenshot, outputs path
#   not_running                                  — prints the standard "not running" message
#   memory_log <bible> <skill> <url> <outcome> <issues>  — appends to Memory Log

_CMD="${1:-}"

case "$_CMD" in
  screenshot)
    _URL="$2"; _SKILL="$3"; _VARIANT="${4:-before}"
    _OUT="/tmp/dstack-${_SKILL}-${_VARIANT}.png"
    _B=""
    [ -x "$HOME/.claude/skills/ds/browse/dist/browse" ] \
      && _B="$HOME/.claude/skills/ds/browse/dist/browse"
    if [ -z "$_B" ]; then
      echo "SCREENSHOT: not_available"
      exit 0
    fi
    "$_B" goto "$_URL" && "$_B" screenshot "$_OUT" \
      && echo "SCREENSHOT: $_OUT" || echo "SCREENSHOT: failed"
    ;;
  not_running)
    echo "Your project doesn't seem to be running right now. Start it with \`npm run dev\` (or \`npm start\`) and then give me the URL — usually http://localhost:3000. I'll wait."
    ;;
  memory_log)
    _BIBLE="$2"; _SKILL="$3"; _URL="$4"; _OUTCOME="$5"; _ISSUES="$6"
    _DATE=$(date "+%Y-%m-%d")
    printf "\n- %s: /%s ran on %s. %s. Issues: %s.\n" \
      "$_DATE" "$_SKILL" "$_URL" "$_OUTCOME" "$_ISSUES" >> "$_BIBLE" 2>/dev/null || true
    echo "MEMORY_LOG: updated"
    ;;
  *)
    echo "Usage: visual-audit.sh screenshot|not_running|memory_log ..."
    exit 1
    ;;
esac
