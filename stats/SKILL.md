---
name: ds:stats
version: 0.1.0
description: View your designStack usage analytics — which skills you've used, success rates, and recent history. Requires analytics to be enabled (opt-in during setup).
---

## Preamble

```bash
_DESIGNSTACK_VER="0.1.0"
_ANALYTICS="$HOME/.dstack/analytics/skill-usage.jsonl"
_TEL_CONFIG="$HOME/.dstack/config"
_TEL=$(grep "^telemetry=" "$_TEL_CONFIG" 2>/dev/null | cut -d= -f2 || echo "on")
_HAS_DATA="no"
[ -f "$_ANALYTICS" ] && [ -s "$_ANALYTICS" ] && _HAS_DATA="yes"
_TOTAL=$(wc -l < "$_ANALYTICS" 2>/dev/null | tr -d ' ' || echo "0")
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "TELEMETRY: $_TEL"
echo "HAS_DATA: $_HAS_DATA"
echo "TOTAL_RUNS: $_TOTAL"
echo "ANALYTICS_FILE: $_ANALYTICS"
```

## What this skill does

Show how you've used designStack — which skills you run most, how many succeeded, and when you last used each one.

## Step 1 — Check telemetry status

If `TELEMETRY` is `off`:
> "Analytics is turned off — no data has been collected. To enable it, edit `~/.dstack/config` and change `telemetry=off` to `telemetry=on`. Future skill runs will be tracked from that point."

Stop here if telemetry is off.

If `HAS_DATA` is `no`:
> "No usage data yet — run a few designStack skills first and then come back. Analytics are stored in `~/.dstack/analytics/skill-usage.jsonl`."

Stop here if no data.

## Step 2 — Read the analytics file

Run this bash to extract usage data:

```bash
# Count per skill
awk -F'"' '/"skill":/ {for(i=1;i<=NF;i++) if($i=="skill") print $(i+2)}' "$HOME/.dstack/analytics/skill-usage.jsonl" | sort | uniq -c | sort -rn

# Count by outcome
awk -F'"' '/"outcome":/ {for(i=1;i<=NF;i++) if($i=="outcome") print $(i+2)}' "$HOME/.dstack/analytics/skill-usage.jsonl" | sort | uniq -c

# Last 5 runs (most recent)
tail -5 "$HOME/.dstack/analytics/skill-usage.jsonl"
```

## Step 3 — Show the report

Present a plain-English summary:

---

**designStack usage so far**

**Total skill runs:** [TOTAL_RUNS]

**Most used skills:**
[For each skill in usage count order:]
- `/ds:[skill]` — used [N] times

**Outcomes:**
- Success: [N] ([X]%)
- Error/abort: [N] ([Y]%)

**Last 5 sessions:**
[For each of last 5 entries — show skill name + outcome + timestamp in plain English, e.g. "ran /ds:look · success · 2 days ago"]

**Analytics stored in:** `~/.dstack/analytics/skill-usage.jsonl`

---

To turn off analytics: edit `~/.dstack/config` and set `telemetry=off`.

## Step 4 — Offer next steps

Based on which skills they've used most:
- If they've used `/ds:look` a lot but never `/ds:brand`: suggest running `/ds:brand` for a full consistency scan
- If they've never run `/ds:a11y`: mention it for accessibility grading
- If they've had `error` outcomes on any skill: offer to troubleshoot with `/ds:unstuck`
