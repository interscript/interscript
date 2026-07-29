# 16 — CI status badges in READMEs

**Status:** DONE for 5 code repos

## Action taken
Prepended an AsciiDoc `image:` badge to each repo's README:

| Repo | Workflow | Badge target |
|------|----------|--------------|
| maps | test.yml | interscript/maps/actions/workflows/test.yml |
| interscript-ruby | rake.yml | interscript/interscript-ruby/actions/workflows/rake.yml |
| interscript-js | js.yml | interscript/interscript-js/actions/workflows/js.yml |
| rababa | ruby.yml | interscript/rababa/actions/workflows/ruby.yml |
| interscript-api | test.yml | interscript/interscript-api/actions/workflows/test.yml |

## Why
Badges give at-a-glance signal of CI health on the repo landing page. Without one, visitors have to click into Actions to verify tests pass.
