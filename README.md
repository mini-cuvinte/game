# Mini Cuvinte

Romanian multiplayer word game. Source-of-truth repositories in the [mini-cuvinte organization](https://github.com/mini-cuvinte):

- **[game](https://github.com/mini-cuvinte/game)** — browser frontend, PostgreSQL/Supabase schema, RPC logic, board seed, deployment configuration.
- **[dexonline-API](https://github.com/mini-cuvinte/dexonline-API)** — independent Python client for DEXonline; future dictionary import and versioning work belongs here.

## Deploy from zero

1. Provision a **new Supabase project** (or a Supabase-compatible self-hosted stack with Auth, PostgREST and PostgreSQL). A bare PostgreSQL database is insufficient.
2. Apply `supabase/bootstrap/01-tables.sql` through `07-board-seed.sql` **in numeric order**, using `psql`; step 05 uses `psql` include directives. See [bootstrap instructions](supabase/bootstrap/README.md).
3. In Supabase Auth, enable the sign-in methods used by the frontend (anonymous and email/password), configure allowed redirect URLs and verify API schema exposure. Review SQL permissions and RLS before opening the service.
4. In Vercel or another CI/static host, configure `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` (public browser key, **not** service role). Run `npm run build` (Node.js 20+) and publish `dist/`. `vercel.json` provides these settings for Vercel.
5. Test registration/anonymous login, room creation, joining, turns, scoring, leaderboard and game completion in an isolated environment. The reconstructed SQL bootstrap **has not yet passed a clean-install integration test**.

The game requires no dictionary download at build time. A fresh database intentionally starts without DEXonline entries; word acceptance remains limited until a licensed word set is imported.

## Runtime configuration

`index.html` loads `/config.js`, which defines `window.MINI_CUVINTE_CONFIG`. The build script generates it from environment variables; it is excluded from Git. There is **no hardcoded production Supabase fallback**. The Supabase JavaScript client is currently pinned to `@supabase/supabase-js@2.57.0` via esm.sh. The frontend has no third-party npm runtime dependencies; `package.json` supplies the build script.

## Database layout

- `public`: rooms, members, events, word requests, profiles, results and public dictionary interface.
- `private`: board state, player racks, bonus squares and word validation.
- `dictionary_private`: dictionary versions, entries, overrides and active version.
- `supabase/bootstrap/`: application-only installation SQL.
- `supabase/snapshots/`: catalog exports for audit/reference, **not** a substitute for the ordered bootstrap.
- `supabase/scripts/`: private full-data backup/restore helpers, separate from application source deployment.

## DEXonline flow

`dexonline-API` is a separate Python scraping client, **not** an official DEXonline API or a production-ready bulk importer. Later, a controlled ETL job will read permitted source data, normalize and validate entries, populate `dictionary_private` staging/version tables and publish an approved active version. The game checks its **local database**, not DEXonline on every move. See [DEXonline integration and update guide](docs/DEXONLINE.md).

**Licensing:** Do not redistribute or bulk-import dictionary datasets without verifying the license and terms of the selected source. Do not commit personal player data, DB credentials, secret keys or unlicensed dictionary exports.

## Deployment and operations

See [deployment details](DEPLOYMENT.md), [database bootstrap](supabase/bootstrap/README.md), and [dictionary maintenance](docs/DEXONLINE.md).
