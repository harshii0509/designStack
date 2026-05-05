# Design Bible Reader — standard extraction protocol

When a skill instructs you to "read the Design Bible," follow this protocol:

1. Read the file at `BIBLE_PATH` (from preamble output).
2. Extract these standard fields. If a field is absent, note it as "not set":
   - **Vibe** — the "The feeling" section (2–4 vibe words + description)
   - **Colors** — L1 Colors: primary, background, text, accent hex values
   - **Typography** — L1 Typography: heading font, body font, size scale
   - **Spacing** — L1 spacing scale values
   - **Components** — L4 rules for buttons, cards, nav, forms (if present)
   - **Memory Log** — the last 5 entries (recent intentional decisions)
3. Flag any Memory Log entry that matches an issue you're about to report — that means the "drift" is intentional and should not be flagged as a problem.
