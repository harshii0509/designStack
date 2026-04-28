---
name: ds:share
version: 0.1.0
description: Get a link to share your project. Preview link for feedback, or make it live for real. Step-by-step in plain language — no deployment experience needed.
---

## Preamble

```bash
_DESIGNSTACK_VER="0.1.0"
_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "NOT_A_GIT_REPO")
_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
_LAST_COMMIT=$(git log -1 --pretty=format:"%h — %s" 2>/dev/null || echo "no commits yet")
_HAS_VERCEL=$(command -v vercel 2>/dev/null && echo "yes" || echo "no")
_HAS_NETLIFY=$(command -v netlify 2>/dev/null && echo "yes" || echo "no")
_HAS_NODE=$(command -v node 2>/dev/null && echo "yes" || echo "no")
_PKG=""
[ -f "$_ROOT/package.json" ] && _PKG=$(node -e "const p=require('$_ROOT/package.json'); console.log(p.scripts?.build ? 'has-build' : 'no-build'); console.log(p.dependencies?.next ? 'next' : p.dependencies?.['react-scripts'] ? 'cra' : p.devDependencies?.vite ? 'vite' : p.devDependencies?.['@sveltejs/kit'] ? 'svelte' : 'unknown')" 2>/dev/null || echo "")
_B=""
[ -x "$HOME/.claude/skills/ds/browse/dist/browse" ] && _B="$HOME/.claude/skills/ds/browse/dist/browse"
echo "DESIGNSTACK: $_DESIGNSTACK_VER"
echo "GIT_ROOT: $_ROOT"
echo "BRANCH: $_BRANCH"
echo "LAST_COMMIT: $_LAST_COMMIT"
echo "VERCEL_CLI: $_HAS_VERCEL"
echo "NETLIFY_CLI: $_HAS_NETLIFY"
echo "NODE: $_HAS_NODE"
echo "PACKAGE: $_PKG"
echo "BROWSE: ${_B:-NOT_FOUND}"
_TEL_START=$(date +%s)
_SESSION_ID="$$-$(date +%s)"
mkdir -p "$HOME/.dstack/analytics"
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"share","event":"started","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
```

## What this skill does

Get a shareable link for your project — for feedback, for a client, or to make it real and live.

Two paths:
- **Preview** — a temporary link just for feedback. Anyone with the link can see it. Not your real domain. Takes ~2 minutes.
- **Go live** — your real site on your real domain. Takes longer, we'll walk through it together.

## Step 1 — Choose a path

Ask:
> "What are you trying to do?
>
> A) **Get a preview link** — share it with someone for feedback. It's a temporary link, not your real website.
> B) **Make it live for real** — put it on your real domain so the world can see it.
> C) **I'm not sure** — just help me figure out what makes sense."

**If C:** Ask:
> "Is this ready for the public, or do you just want someone specific to take a look at it first?"
Then route to A or B accordingly.

## Step 2A — Preview link path

### Check git status first

If `GIT_ROOT` is `NOT_A_GIT_REPO` or `LAST_COMMIT` is `no commits yet`:
> "Before I can create a preview link, your project needs at least one save. Let me set that up."
Then guide through git init + first commit (same flow as `/ds:save`).

### Check for unsaved changes

```bash
git status --short
```

If there are uncommitted changes:
> "You have changes that haven't been saved yet. If I share right now, those changes won't be included in the preview. Want me to save them first?"
If yes, run the `/ds:save` flow. If no, continue.

### Deploy preview

**If Vercel CLI is available (`VERCEL_CLI: yes`):**

```bash
vercel --yes 2>&1
```

Parse the output for the preview URL. Show it to the user:
> "✓ Your preview link is ready:
> 👉 [URL]
>
> Anyone with this link can see your project. It's temporary — it won't automatically update when you make changes. Run `/ds:share` again to get a fresh link after your next round of edits."

If browse available, take a screenshot to confirm it loaded:
```bash
$B goto <preview URL>
$B screenshot /tmp/dstack-share-preview.png
```
Show the screenshot: "Here's what it looks like live:"

**If Vercel CLI is NOT available:**

> "The sharing tool isn't set up yet. I'll get it installed — this only needs to happen once."

If `NODE` is `yes`:
```bash
npm install -g vercel
```

If `NODE` is `no`:
> "To share your project, I need to install a free tool. It takes about 2 minutes.
>
> **Here's what to do:**
> 1. Go to https://nodejs.org — click the big green button that says 'LTS' (the recommended version)
> 2. Open the file it downloads and click through the installer (just keep clicking Next)
> 3. Once it's done, come back here and type 'done'
>
> I'll wait."

Wait for the user to confirm Node is installed, then run:
```bash
npm install -g vercel
```

Tell the user: "Done — the sharing tool is installed. You won't need to do that again."

After installing:
```bash
vercel --yes 2>&1
```

**First-time Vercel setup:**
If this is the first time running `vercel` on this project, it will prompt for login. Walk the user through:
> "Vercel needs you to log in. Open this link in your browser: [link from output]
> After you log in, come back here and I'll continue."

## Step 2B — Go live path

Going live means your site is at a real URL (your own domain or a vercel.app address). This is a bigger step — walk through it carefully.

### Sub-step 1: Check what we're working with

Based on `PACKAGE` value:
- `next` → Next.js project
- `vite` → Vite project  
- `cra` → Create React App
- `svelte` → SvelteKit
- `unknown` → Ask the user what kind of project

For each framework, know the right build command and output folder:
- Next.js: `npm run build`, output: `.next/`
- Vite: `npm run build`, output: `dist/`
- CRA: `npm run build`, output: `build/`
- SvelteKit: `npm run build`, adapter-dependent

### Sub-step 2: Make sure it builds

```bash
npm run build 2>&1 | tail -30
```

If the build fails, tell the user what went wrong in plain English:
> "The build failed before we could go live. Here's what went wrong:
> [plain English translation of the error]
>
> Want me to fix it? Or run `/ds:unstuck` for a full diagnosis."

### Sub-step 3: Deploy

```bash
vercel --prod --yes 2>&1
```

### Sub-step 4: Custom domain (if they want one)

Ask:
> "Do you want to connect a custom domain (like www.yourproduct.com)? Or is a vercel.app address fine for now?"

If custom domain:
> "To connect your domain, you'll need to add a DNS record in wherever you bought your domain. This is a 2-step process:
>
> **Step 1:** I'll set up the domain on Vercel (I can do this)
> **Step 2:** You'll add a record in your domain registrar (GoDaddy / Namecheap / Cloudflare / etc)
>
> What's the domain you want to use?"

```bash
vercel domains add <domain> 2>&1
```

Show the DNS record Vercel requires. Walk the user through adding it:
> "Go to wherever you bought [domain.com] — that's usually GoDaddy, Namecheap, Cloudflare, or Google Domains. Look for 'DNS Settings' or 'DNS Records'.
>
> Add this record:
> **Type:** [A or CNAME]
> **Name:** [@ or www]
> **Value:** [IP or Vercel URL]
>
> After you add it, wait 5–30 minutes and then come back. DNS changes take a little time to spread across the internet."

### Sub-step 5: Confirm it's live

After deployment:
```bash
$B goto <live URL>
$B screenshot /tmp/dstack-share-live.png
```

Show the screenshot:
> "✓ Your site is live at [URL]!
>
> [screenshot]
>
> Here's what you should know:
> - **From now on**, every time you want to update it, run `/ds:share` again and choose 'go live'
> - **If something breaks**, run `/ds:unstuck` and I'll help diagnose it
> - **Save regularly** with `/ds:save` — this makes it easy to roll back if anything goes wrong"

## Step 3 — Environment variables (if the build needs them)

If the build fails with a message about missing environment variables (API keys, database URLs, etc.):

> "Your project needs some secret settings to work — things like API keys or database connections. These can't be stored in your code (that would be a security risk), so they're stored separately.
>
> Tell me what the missing setting is called and what the value is. I'll add it to your Vercel project so it works when deployed."

```bash
vercel env add <KEY_NAME> production
```

Walk through each missing variable one at a time.

## Step 4 — Netlify fallback

If the user prefers Netlify or Vercel isn't working:

```bash
netlify deploy --dir=<output dir> --prod
```

Walk through Netlify login if needed (same pattern as Vercel).

## Step 5 — Confirm and save the URL

After any successful deployment:
> "✓ Shared! Here's everything in one place:
>
> **Your link:** [URL]
> **Type:** [Preview / Live]
> **Last updated:** right now
> **What's in it:** [LAST_COMMIT message in plain English]"

If the project has a Design Bible, append to Memory Log:
```
[date]: /share ran. URL: [URL]. Type: [preview/live]. Build: success.
```

## Completion

Always run this bash before ending, regardless of outcome. Replace `OUTCOME` with: `success`, `error`, or `abort`.

```bash
_TEL_END=$(date +%s)
_TEL_DUR=$(( _TEL_END - _TEL_START ))
"$HOME/.claude/skills/ds/bin/ds-timeline-log" \
  '{"skill":"share","event":"completed","outcome":"OUTCOME","duration_s":"'"$_TEL_DUR"'","session":"'"$_SESSION_ID"'"}' 2>/dev/null || true
"$HOME/.claude/skills/ds/bin/ds-telemetry-log" \
  --skill "share" --duration "$_TEL_DUR" --outcome "OUTCOME" \
  --session "$_SESSION_ID" 2>/dev/null || true
```

Report completion status: **DONE** / **DONE_WITH_CONCERNS** / **BLOCKED** / **NEEDS_CONTEXT**
