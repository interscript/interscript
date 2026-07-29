# 18 — Repository metadata consistency

**Status:** DONE

## Action taken
Via `gh repo edit` for all 10 active repos:

| Repo | Description | Topics |
|------|-------------|--------|
| maps | Interscript map data — interoperable transliteration systems | transliteration, i18n |
| interscript-ruby | Interscript Ruby runtime — interoperable script conversion | transliteration, i18n |
| interscript-js | Interscript JavaScript runtime — interoperable script conversion | transliteration, i18n |
| interscript | Interscript monorepo: bootstrap, docs, integration | transliteration, i18n |
| interscript-api | Interscript GraphQL API (AWS Lambda) | transliteration, i18n |
| interscript.github.io | Interscript.org website | transliteration, i18n |
| rababa | Middle Eastern language diacritization for Interscript | transliteration, i18n |
| Onigmo | Fork of Onigmo (Oniguruma-mod) regex library with WASM support | transliteration, i18n |
| opal | Fork of Opal (Ruby to JavaScript compiler) | transliteration, i18n |
| geonames-transliteration-data | GeoNames-based transliteration pair data | transliteration, i18n |

## Why
- Consistent descriptions make the org overview readable
- Topics make repos discoverable via GitHub topic search (`github.com/topics/transliteration`)
- All repos now have a one-line summary on the repo list

## Notes
- Default branch rename (master → main) for `Onigmo` and `opal` deferred — would force-push contributors. Will happen opportunistically.
- Homepage URLs: most repos have `homepage` set in gemspec; repo-level homepage setting left untouched for now.
