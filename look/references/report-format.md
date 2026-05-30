# Look Report Format

Use this scoring and report shape for `/ds-look`:

- Single-page verdict first.
- Score out of 10.
- Credit what already works before listing issues.
- Prioritize the top 3 fixes.
- Distinguish intentional changes from unintentional drift using the Memory Log.

Report shape:

1. One-line verdict: `[URL] — [X]/10 — [main finding]`
2. Ask whether to show the full report or fix the biggest issue.
3. Full report sections:
   - `What's working well`
   - `Issues I found`
   - `My top 3 fixes`
   - `Design Bible drift summary`
