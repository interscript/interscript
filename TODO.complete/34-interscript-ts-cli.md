# 34 — interscript-ts CLI

**Status:** TODO

## Why
Ruby gem has `exe/interscript` (Thor-based CLI) for `interscript -s system_code input.txt`. TS should have an equivalent for Node users.

## Scope

### Package
Add `bin/interscript.ts` (compiled to `dist/bin/interscript.js`):

```typescript
#!/usr/bin/env node
import { readFile, writeFile } from "node:fs/promises"
import { transliterate, configure } from "interscript-ts"
import { filesystemJsonIRStrategy } from "interscript-ts/loaders/node"

configure({
  strategies: [filesystemJsonIRStrategy("./node_modules/interscript-maps")],
})

const args = process.argv.slice(2)
const systemCode = args[0]
const inputFile = args[1]
const outputFile = args[2]

const input = await readFile(inputFile, "utf8")
const output = transliterate(systemCode, input)
if (outputFile) {
  await writeFile(outputFile, output)
} else {
  process.stdout.write(output)
}
```

### Binary in package.json
```json
{
  "bin": {
    "interscript": "./dist/bin/interscript.js"
  }
}
```

### Usage
```bash
npx interscript bgnpcgn-ukr-Cyrl-Latn-2019 input.txt output.txt
```

## Acceptance criteria
- CLI works on Node 20+
- Same exit codes as Ruby CLI (0 success, 1 error)
- `--help` shows usage

## Effort
S (2-4 hours)
