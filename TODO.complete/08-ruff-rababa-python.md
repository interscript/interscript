# 08 — ruff baseline for `rababa/python`

**Status:** DONE (baseline established; 36 violations remain as documented tech debt)

## Why
`rababa/python` had no Python lint. Research code that has accumulated F821 undefined-name and F811 duplicate-definition issues that real lints catch.

## Action taken
- Created `python/pyproject.toml` (PEP 621) with metadata + `[tool.ruff]` config
- Rule set: `E, F, W, I, UP` (conservative); ignore `E501` (line length — formatter handles), `E402` (research scripts configure paths first), `E741` (math/ML naming)
- Auto-applied **245 fixes** (165 safe + 80 unsafe): PEP 585 annotations (`list[str]` not `List[str]`), deprecated imports, unused vars, isort ordering, `yield` simplification
- Ran `ruff format` on all 56 .py files
- Added CI `lint` job (non-blocking via `continue-on-error: true`) running `ruff check` + `ruff format --check`
- Hardened `.gitignore` for `python/{log_dir,data,models}/`, `__pycache__/`, `*.pt`, `*.onnx`

## Mistake fixed mid-execution
First pass committed 6 MB of training artifacts (`log_dir/`, TensorBoard event files). Reset, staged only `*.py` + `pyproject.toml` + `.gitignore` + workflow, force-pushed clean commit.

## Remaining violations (36)
- **19 F821** undefined-name — mostly false positives on tuple-unpack assigns like `outputs, (hn, cn) = layer(...)` followed by `layer(outputs, (hn, cn))` (the second branch references names bound in the first). Static analysis limitation, not a runtime bug.
- **11 E701** multi-statement-on-one-line-colon — `if x: do_y()` style; cosmetic
- **3 E722** bare-except — should be `except Exception:` minimum
- **2 F811** redefined-while-unused — duplicate function defs in trainer.py; real code smell
- **1 E721** type-comparison — `type(x) == Y` should be `isinstance(x, Y)`

## Follow-up
Manual cleanup of the 36 remaining. CI will start enforcing (remove `continue-on-error`) once those land.

## Note on torch
`requirements.txt` still pins torch 1.9.0; bumping to 2.x is tracked in TODO 19.
