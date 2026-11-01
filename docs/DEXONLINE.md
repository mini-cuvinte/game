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
