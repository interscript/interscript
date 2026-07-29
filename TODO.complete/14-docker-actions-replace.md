# 14 — Replace `elgohr/Publish-Docker-Github-Action` with official Docker actions

**Status:** DONE

## Why
- `elgohr/Publish-Docker-Github-Action@master` is unpinned (uses `@master` ref)
- Project abandoned; last release years ago
- `docker.pkg.github.com` registry is deprecated — `ghcr.io` is the current home

## Action taken
`.github/workflows/on-api-release.yml` now uses:
- `docker/login-action@v4` — explicit GHCR login
- `docker/build-push-action@v7` — standard build + push

Tags published:
- `ghcr.io/<repo>/awslambda-interscript-api:latest`
- `ghcr.io/<repo>/awslambda-interscript-api:<tag>`

## Side benefits
- Explicit `permissions: contents: read, packages: write` (security)
- `build-args: INTERSCRIPT_GEM_VERSION=...` is properly typed
- Cleaner separation of login vs build vs dispatch steps

## Test plan
- [ ] First tag-triggered release publishes to GHCR successfully
- [ ] Image appears at expected tag
- [ ] `infrastructure-lambda-api` dispatch still fires
