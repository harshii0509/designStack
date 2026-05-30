# Axe Translation

Use this table when turning axe rule IDs into plain English:

| axe rule ID | Severity | Plain English explanation |
|---|---|---|
| `color-contrast` | Medium | "This text is hard to read — the color doesn't stand out enough from the background" |
| `image-alt` | Critical | "This image has no description, so blind users won't know what it shows" |
| `label` | Critical | "This input field doesn't say what it's asking for — screen readers can't announce it" |
| `button-name` | Critical | "This button has no readable label — blind users won't know what it does" |
| `heading-order` | Moderate | "Your headings are out of order — screen readers expect them to go H1, H2, H3 in sequence" |
| `html-has-lang` | Serious | "Your page doesn't specify what language it's in — screen readers won't know how to pronounce it" |
| `document-title` | Serious | "Your page has no title — blind users and browser tabs will show nothing" |
| `link-name` | Serious | "This link just says 'click here' or has no text — screen readers can't tell what it leads to" |
| `region` | Moderate | "Your page content isn't organized into landmarks — screen readers can't skip to the main content" |
| `landmark-one-main` | Moderate | "Your page is missing a 'main content' area label — screen readers expect one" |
| `aria-required-attr` | Critical | "An interactive element is missing a required accessibility attribute" |
| `aria-valid-attr-value` | Critical | "An accessibility attribute has an invalid value" |
| `form-field-multiple-labels` | Moderate | "This input field has two conflicting labels — screen readers won't know which to use" |
| `select-name` | Critical | "This dropdown menu has no label — screen readers can't describe it" |
| `frame-title` | Serious | "An embedded frame has no title — screen readers can't describe its contents" |
| `scrollable-region-focusable` | Serious | "This scrollable area can't be reached with a keyboard — only mouse users can scroll it" |
| `target-size` | Minor | "This button is too small to tap comfortably on a phone (needs at least 44×44px)" |
| `focus-visible` | Serious | "When someone navigates with Tab, they can't see where they are on the page" |
| `keyboard` | Critical | "This element can't be reached or used with a keyboard at all" |
| `bypass` | Moderate | "Keyboard users have no way to skip over the navigation to get to the main content" |
| `meta-viewport` | Critical | "Your page is blocking users from zooming in — this breaks accessibility for low-vision users" |
| `tabindex` | Serious | "The keyboard tab order on your page jumps around in a confusing way" |
| `duplicate-id` | Moderate | "Two elements share the same ID — this confuses screen readers" |
| `definition-list` | Minor | "A list is not structured correctly for screen readers" |
| `list` | Minor | "A list element is used incorrectly — screen readers will announce it wrong" |
| `td-headers-attr` | Serious | "A table cell doesn't say which column or row header it belongs to" |
| `th-has-data-cells` | Serious | "A table header doesn't have any associated data cells" |
