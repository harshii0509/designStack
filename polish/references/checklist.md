# Polish Checklist

Run these 11 checks in order and describe each result in plain English:

1. Does it look right?
   - Take a before screenshot with `visual-audit.sh`.
   - Compare colors, fonts, and spacing against the Design Bible when present.
2. Is the layout balanced?
   - Do a squint test for weight, alignment, and awkward placement.
3. Is the text readable?
   - Body text at least 16px, reasonable line height, no overly wide text blocks.
4. Do the colors work together?
   - Check contrast and the 60/30/10 balance.
5. Are buttons obvious?
   - One clear primary action, clear secondary hierarchy, visibly clickable controls.
6. Does it work on phones?
   - Resize to 375x812, take a screenshot, and check horizontal overflow.
7. Can people use it without a mouse?
   - Check keyboard reachability and visible focus state.
8. Does it load fast enough?
   - Look for DOM load over 3 seconds, very large images, or image-heavy pages.
9. Does every image have a description?
   - List images missing alt text.
10. Are there any empty states?
   - Note whether no-data or first-time states look broken or unfinished.
11. Are forms easy to fill out?
   - Skip if no forms. Check labels, errors, and submit clarity.

Use these plain-English result patterns:

- Pass example: "Looks good on phones."
- Fail example: "Content is overflowing off the right edge of the phone screen."
