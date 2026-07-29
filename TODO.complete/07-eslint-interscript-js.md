# 07 — ESLint + Prettier for `interscript-js`

**Status:** DONE

## Why
No JS lint existed. The TS runtime port (Phase C2) will inherit this baseline; better to fix obvious issues now.

## Action taken
- Install `eslint@10`, `@eslint/js@10`, `prettier@3`, `eslint-config-prettier@10` as devDeps
- Flat config (`eslint.config.js`): `js.configs.recommended` + prettier disables
- `.prettierrc.json` (100-col, double-quote, ES5 trailing comma)
- Browser globals declared for `src/stdlib.js` (it runs in both Node and browser)
- Mocha globals declared for `test/**/*.js`
- CI: lint + format:check before tests + standalone lint-only job

## Bugs fixed by lint
- `map_list(map)` had an unused `map` parameter — removed (real bug, callers may have been passing map name expecting filtering but got all keys)
- Multiple `==`/`!=` replaced with `===`/`!==` (correctness — coercion footguns)
- Unused `opts` parameters in `downcase`/`compose`/`decompose` prefixed with `_`

## Defensive cleanup
- Removed `interscript.js` (26k-line local Opal bundle) from a botched commit and added it to `.gitignore`. Force-pushed to clean up the PR branch.

## Validation
- `npm run lint` clean
- `npm run format:check` clean
- `node -e "require('./src/stdlib')"` succeeds
