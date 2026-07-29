# 20 — Dual ESM/CJS packaging + npm provenance (`interscript-js`)

**Status:** DEFERRED — depends on TS port (TODO 24)

## Why
- Phase C1 kept `"type": "commonjs"` for compatibility
- Modern consumers want ESM (`import Interscript from 'interscript'`)
- `npm publish --provenance` enables supply-chain attestation

## What to do (post-TS port)
1. TS port produces `dist/` with both `.js` (CJS) and `.mjs` (ESM)
2. `package.json`:
   ```json
   {
     "type": "module",
     "main": "./dist/index.js",
     "module": "./dist/index.mjs",
     "exports": {
       ".": {
         "import": "./dist/index.mjs",
         "require": "./dist/index.js",
         "types": "./dist/index.d.ts"
       }
     }
   }
   ```
3. Release workflow:
   ```yaml
   permissions:
     id-token: write
     contents: read
   - run: npm publish --provenance --access public
   ```

## Blocker
TS port (TODO 24) sets the dist/ shape. Until then, this is moot.

## Effort
S (mostly mechanical once TS port lands)
