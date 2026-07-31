# 75 — Deployment story (close the API gap)

**Status:** TODO
**Priority:** P0 (currently broken — API runs locally but not in prod)

## Problem

GitHub Pages is static-only. The new SSR API endpoints (`/api/*`) only
work locally. Production is currently broken for the API surface.

## Recommended path: Vercel

- Free tier covers our traffic
- First-class Astro + Node adapter support
- Edge functions for low-latency API
- Automatic deploys from GitHub
- Preview deploys per PR

Steps:
1. Add `vercel.json` with Node runtime config
2. Move deploy target from GitHub Pages to Vercel
3. Keep static pages CDN-cached; API routes are on-demand
4. Configure custom domain `interscript.org` (already owned)
5. Keep GitHub Pages as a fallback mirror if desired

## Alternative: Cloudflare Pages + Workers

- Free tier is generous
- Workers run on edge — global low latency
- More setup (Worker scripts for `/api/*`)
- Better for high-volume API use

## Alternative: Render / Fly.io

- Plain Node host
- `node dist/server/entry.mjs` as start command
- More control, more ops burden

## Acceptance

- [ ] Decision documented
- [ ] Deploy pipeline updated (`deploy.yml` or new workflow)
- [ ] Production URL serves both static pages AND `/api/*`
- [ ] Smoke test in CI verifying live API
- [ ] DNS cutover plan if changing domain target
