#!/usr/bin/env bash
# designStack shared telemetry completion.
# Usage: "$HOME/.claude/skills/ds/lib/telemetry-end.sh" "skillname" "outcome"
# outcome: success | error | abort
# Reads session data written by lib/env.sh.

_SKILL="${1:-unknown}"
_OUTCOME="${2:-success}"
_SESSION_FILE="/tmp/dstack-${_SKILL}-session.env"

_TEL_START=$(grep "^TEL_START=" "$_SESSION_FILE" 2>/dev/null | cut -d= -f2 || echo "0")
_SESSION_ID=$(grep "^SESSION_ID=" "$_SESSION_FILE" 2>/dev/null | cut -d= -f2 || echo "")
_TEL_END=$(date +%s)
_TEL_DUR=$(( _TEL_END - _TEL_START ))

"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"'"$_SKILL"'","event":"completed","outcome":"'"$_OUTCOME"'","duration_s":"'"$_TEL_DUR"'","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
"$HOME/.claude/skills/ds/bin/ds-telemetry-log" \
  --skill "$_SKILL" --duration "$_TEL_DUR" --outcome "$_OUTCOME" \
  --session "$_SESSION_ID" 2>/dev/null || true

rm -f "$_SESSION_FILE" 2>/dev/null || true
