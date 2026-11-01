# Application bootstrap (new Supabase instance only)

This directory reconstructs the **game application** schema from live PostgreSQL metadata, without personal data or the DEXonline staging dataset.

Run from the repository root against a NEW Supabase PostgreSQL database:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/01-tables.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/02-constraints.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/03-indexes.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/04-rls.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/05-functions.psql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/06-rpc-grants.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/07-board-seed.sql
```

Apply functions from the repository root; `05-functions.psql` uses relative `\\ir` paths into `../snapshots/`.

Contents: 15 tables (`public`, `private`, `dictionary_private`), 47 constraints, 3 additional indexes, RLS for 7 public tables, 23 SQL functions, function execution grants, 49 board bonus positions.

This is **not a verified migration**. A new Supabase project must provide `auth.uid()`, Auth roles, PostgREST RPC and other Supabase facilities. Verify extensions, function ownership, RLS, grants and multiplayer behavior in an isolated test project before production.

The DEXonline import is separate. A new install starts with no dictionary data, so word validation may not accept words until a licensed dictionary release is published.

See [full deployment guide](../../docs/DEPLOY_FROM_ZERO.md).
