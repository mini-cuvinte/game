# DEXonline integration and update playbook

## Responsibility boundaries

- [mini-cuvinte/game](https://github.com/mini-cuvinte/game) contains the game and its PostgreSQL schema, including versioned dictionary tables.
- [mini-cuvinte/dexonline-API](https://github.com/mini-cuvinte/dexonline-API) contains the existing Python DEXonline HTML client. It is **not an official API**, and its current functions fetch individual definitions, word-of-day/month, paradigms and random words. It does **not** yet implement a bulk ETL pipeline to Supabase.
- The game should validate moves against its own local, published dictionary version. No live request to DEXonline is needed for a turn.

## When DEXonline changes its website

1. Check the upstream source: [dexonline.ro](https://dexonline.ro/), [its public source repository](https://github.com/dexonline/dexonline), and [project wiki](https://wiki.dexonline.ro/). Confirm the current endpoints, HTML structure, robots/usage rules and dataset license; do not assume the old scraper still works.
2. Clone `mini-cuvinte/dexonline-API`. Update `dexonlineBK/dexonlineBK.py` if the URL paths or parsing structure changed. `DEXONLINE_BASE_URL` controls the host, `DEXONLINE_DEFINITION_SELECTOR` controls the CSS selector for definitions, and `DEXONLINE_TIMEOUT` controls HTTP timeout.
3. Run a small smoke test against a **permitted** word with `getWordDefinition`, `getParadigms` and `getWordOfTheDay`; check nonempty results and special Romanian characters. Avoid aggressive automated scraping.
4. Add/update fixture-based parser tests for the changed HTML, and review changes before release.
5. When the future importer is implemented: download only licensed data, stage in `dictionary_private`, validate counts/normalization/duplicates, approve license provenance, then publish a new version atomically. Preserve the old active version for rollback.

## Updating the Python client

```bash
git clone https://github.com/mini-cuvinte/dexonline-API.git
cd dexonline-API
python3 -m venv .venv
. .venv/bin/activate
python -m pip install requests beautifulsoup4 html5lib
DEXONLINE_BASE_URL=https://dexonline.ro python -c "from dexonlineBK import dexonlineBK as dex; print(dex.getWordDefinition('casa'))"
```

The original `setup.py` is legacy and may need packaging cleanup before `pip install -e .` works reliably. Do not assume this client offers a stable or authorized bulk dictionary API.

## Dictionary version and rollback strategy

Keep an import manifest with source URL, retrieval date, source license, normalization rules, checksums and counts. Publish a new dictionary version only after tests and explicit license approval. The game stays on the previously active version during import. Rolling back means selecting the previous validated version, not re-scraping the website.

## Current limitations

The existing game bootstrap includes dictionary table structure but intentionally **no DEXonline words**. The full DEXonline ETL job and promotion automation are future work. This guide describes the intended workflow, not an already functioning import service.

## Verified bulk ETL implementation (2026-11-01)

The preceding legacy-client description is incomplete: the repository **also has an active bulk ETL implementation on branch `modernize/python-fastapi`**. The workflow files on `master` explicitly check out that branch.

- Official archive URL used by [DEXonline import workflow](https://github.com/mini-cuvinte/dexonline-API/blob/master/.github/workflows/dexonline-import.yml): `https://dexonline.ro/static/download/dex-database.sql.gz`.
- `scripts/preflight_dexonline.py`: verify archive table/column format and `Source.canDistribute` licensing metadata.
- `scripts/import_dexonline.py`: conservative archive/schema audit; it intentionally refuses production import in non-dry-run mode.
- `scripts/import_licensed_definitions.py`: licensed definition staging import.
- `scripts/build_word_index.py`, `scripts/audit_expanded_eligibility.py`, `scripts/audit_word_provenance.py`: normalize/filter/audit candidate words.
- `scripts/dictionary_build.py`: create an inactive version with `license_approved=false`.
- `scripts/dictionary_release.py`: publish an approved version via `dictionary_private.publish_version`.
- `scripts/set_dictionary_override.py`: controlled correction; `scripts/cleanup_dictionary_version.py`: archived version cleanup.

### Source changes: exact files to edit

| Upstream change | Files to review on `modernize/python-fastapi` (workflow on `master`) |
|---|---|
| Archive download URL | `.github/workflows/dexonline-import.yml` (master) |
| SQL table/column format | `scripts/preflight_dexonline.py`, `scripts/import_licensed_definitions.py`, `scripts/test_sql_parser.py` |
| Licensing metadata | `scripts/preflight_dexonline.py`, `scripts/import_licensed_definitions.py`, `scripts/build_word_index.py` — fail closed until reviewed |
| Inflection/lexeme mappings | `scripts/build_word_index.py`, `scripts/audit_expanded_eligibility.py`, `scripts/audit_word_provenance.py` |
| Legacy HTML selectors | `dexonlineBK/dexonlineBK.py` (`span.def`, `ul.commaList`) |
| Dictionary target database | GitHub Actions `DATABASE_URL` secret, not source code |

### Actual update and release flow

Run **DEXonline import (manual)** from GitHub Actions with `dry_run=true`. Review the schema and license audit. If approved, test a bounded `smoke_import=true` into staging. The full licensed import is explicitly gated by `import_licensed_definitions=true` and `dry_run=false`. Then run **Dictionary build** with a reviewed word file and source label, approve the resulting version separately, and run **Dictionary release or rollback** with its version ID and `confirm=PUBLISH`.

**Critical:** do not edit only `master` and expect ETL code changes to execute; current workflows check out `modernize/python-fastapi`. Test changes in that branch or intentionally migrate workflows to a stable branch. No raw DEXonline data should be published in the public GitHub repository without redistribution rights.
