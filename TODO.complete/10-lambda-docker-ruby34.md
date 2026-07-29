# 10 — Lambda Docker base image 2.7 → 3.4

**Status:** DONE

## Files
- `.github/awsl-layer-docker/Dockerfile` — builder stage
- `.github/lambda/Dockerfile` — builder + runtime

## Action taken
| Stage | Before | After |
|-------|--------|-------|
| Builder | `lambci/lambda:20200812-build-ruby2.7` | `public.ecr.aws/sam/build-ruby:3.4` |
| Runtime (lambda/Dockerfile) | `public.ecr.aws/lambda/ruby:2.7` | `public.ecr.aws/lambda/ruby:3.4` |
| Yumda stage | `lambci/yumda:2` | `public.ecr.aws/sam/build-ruby:3.4` (AWS SAM build image includes yum) |

## Why
- `lambci/lambda` images are unmaintained since 2020.
- AWS Lambda Ruby 2.7 runtime reached EOL.
- Ruby 3.4 is the current Lambda runtime line; Ruby 4.0 (when released) will have its own base image.

## Side cleanup
- Removed dead commented-out blocks (`#RUN ls -all /venfor/...`, etc.)
- Stripped commented-out python path attempts.

## Test plan
- [ ] First tag-triggered release builds + publishes successfully to GHCR
- [ ] Lambda cold-start still works in staging
