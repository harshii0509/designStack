# Deploy Playbook

Use this reference for framework-specific deployment expectations and go-live steps.

## Build Expectations

- Next.js: `npm run build`, output `.next/`
- Vite: `npm run build`, output `dist/`
- Create React App: `npm run build`, output `build/`
- SvelteKit: `npm run build`, adapter-dependent output

## Preview Path

- Prefer Vercel when available.
- If the project has no git history or no commits yet, route through the `/ds-save` flow first.
- If there are uncommitted changes, offer to save before preview deployment.

## Go-Live Path

1. Run a production build.
2. Translate build failures into plain English and offer `/ds-unstuck` if needed.
3. Deploy with `vercel --prod --yes`.
4. If the user wants a custom domain, walk them through `vercel domains add <domain>` and the DNS record they need to add.
5. If Vercel is unavailable or the user prefers it, use Netlify as the fallback.

## Environment Variables

- If deployment fails because secrets are missing, explain that the project needs separate secret settings.
- Add missing values one at a time with `vercel env add <KEY_NAME> production`.
