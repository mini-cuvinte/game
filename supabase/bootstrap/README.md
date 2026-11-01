# Portable Mini Cuvinte bootstrap

This is an **application schema bootstrap** for a fresh Supabase-compatible PostgreSQL instance. It deliberately excludes player data, imported DEXonline content, and the 24-table `dexonline` staging schema. The import pipeline remains in `mini-cuvinte/dexonline-API`.

## Apply in a fresh Supabase project

Use a trusted terminal with `psql` installed and a database connection string held in a local secret manager, not committed to GitHub.

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/01-tables.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/02-constraints.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/03-indexes.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/04-rls.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/05-functions.psql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/06-rpc-grants.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/07-board-seed.sql
```

This is **not yet validated with a clean restore**. Do not deploy it to production until the bootstrap is tested against an isolated database and all game RPC smoke tests pass. The SQL assumes Supabase Auth roles and functions such as `auth.uid()`; plain PostgreSQL alone will not provide Supabase Auth or the Data API.

Configure the frontend's Supabase project URL and public/publishable key for the new project. The current `index.html` still contains the original project's connection details; it is not yet environment-agnostic. Never embed service-role credentials in browser code.

For a fresh install, the dictionary is intentionally empty; word validation will require a later approved dictionary import or separately licensed starter word list. Board bonus squares are seeded.

The bootstrap was reconstructed from live PostgreSQL catalogs; it is not the original migration history. Database grants, security-definer behavior and deployment settings must be reviewed for the target. The DEXonline import should be a separate, repeatable release job, not an API request per game.
