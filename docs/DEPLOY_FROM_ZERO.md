# Deploy Mini Cuvinte from zero

## Architecture and repository ownership

- [game](https://github.com/mini-cuvinte/game): static browser UI, Supabase RPCs, game rules, database bootstrap, deployment build.
- [dexonline-API](https://github.com/mini-cuvinte/dexonline-API): unofficial Python adapter and future dictionary ETL, independently maintained.
- Target infrastructure: static web host (Vercel, Netlify, nginx, S3-compatible hosting) + **Supabase-compatible** PostgreSQL, Auth and PostgREST RPC. Plain PostgreSQL without these services is not a drop-in backend.

Browser -> Supabase Auth (anonymous/email) -> RPCs (rooms, moves, scoring, leaderboard) -> application tables. The browser does not call DEXonline. The dictionary importer later publishes an approved version into Supabase.

## 1. Provision backend

Create a NEW Supabase project, or equivalent self-hosted Supabase stack. Enable/configure the Auth providers used by the game, including anonymous sign-in if required. Obtain the new project URL and **publishable** key. Keep the database URL and secret keys private.

Run the bootstrap on the NEW database, from repository root, in this order:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/01-tables.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/02-constraints.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/03-indexes.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/04-rls.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/05-functions.psql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/06-rpc-grants.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f supabase/bootstrap/07-board-seed.sql
```

The SQL is catalog-reconstructed and **not yet tested on a clean Supabase project**. Before production, verify table ownership, SECURITY DEFINER/search_path behavior, RLS, grants, auth-related dependencies and extension prerequisites. Do not run this bootstrap against the current live database.

## 2. Deploy frontend

Requires Node.js 20+; no npm dependencies are needed for the build. `index.html` loads `@supabase/supabase-js@2.57.0` from esm.sh at runtime, so this CDN is an additional runtime dependency.

```bash
git clone https://github.com/mini-cuvinte/game.git
cd game
export SUPABASE_URL="https://YOUR_PROJECT.supabase.co"
export SUPABASE_PUBLISHABLE_KEY="YOUR_PUBLIC_PUBLISHABLE_KEY"
npm run build
# Upload dist/ to any static hosting service.
```

The build creates `dist/index.html`, `dist/manifest.webmanifest`, and `dist/config.js` with the target URL and public key. Optional `sw.js`/`icon.svg` are copied only if present.

For Vercel: connect the `mini-cuvinte/game` repository, set root directory to repository root, build command `npm run build`, output directory `dist`, and environment variables `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY`. Update the project's Auth site URL/redirect allowlist for the deployed domain. Do not assume the existing Vercel project has been reconnected after the GitHub organization transfer.

Local testing with the generated `dist/` can use `python3 -m http.server 8080 -d dist`. Do not open `index.html` directly from the file system.

## 3. Validate deployment

1. Confirm `config.js` points to the new project, not the original production project.
2. Verify anonymous/email authentication and room creation.
3. Join from a second browser session, start a room, place tiles, score, advance turns and finish.
4. Verify room privacy and that direct reads of RLS-protected tables are blocked.
5. Confirm board bonus positions, leaderboard and profile updates.
6. Without an imported dictionary, word validation may reject normal words. This is expected until the separate import is ready.

## 4. Dictionary imports and DEXonline changes

Dictionary content is deliberately **not** part of the game bootstrap. The game keeps a local, versioned dictionary in `dictionary_private` and does not query DEXonline during gameplay.

The [DEXonline adapter](https://github.com/mini-cuvinte/dexonline-API) is updated independently. Its source host and HTML definition selector are configurable. When DEXonline changes, update the adapter, test against permitted sample words, then release an import pipeline version. See [source maintenance](https://github.com/mini-cuvinte/dexonline-API/blob/master/docs/DEXONLINE_SOURCE.md) and [import pipeline](https://github.com/mini-cuvinte/dexonline-API/blob/master/docs/IMPORT_PIPELINE.md).

Import only with appropriate source permissions and after validation; never push full dictionary data to public GitHub. The import runner is still planned, not implemented.

## 5. Recovery and portability

`supabase/snapshots/` holds 23 extracted function definitions and metadata. `supabase/scripts/backup.sh` and `restore.sh` are separate private-data backup helpers; they are not required for a clean game install. See [BACKUP_RESTORE.md](../supabase/BACKUP_RESTORE.md).

Known outstanding validation: no clean-room bootstrap test, no end-to-end gameplay test against a new Supabase instance, and no complete dictionary import runner. The bootstrap is a strong starting point, not a certified one-command deployment.
