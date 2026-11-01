# Mini Cuvinte

Romanian multiplayer word game with a static browser frontend and a Supabase backend. The project is organized under the [mini-cuvinte GitHub organization](https://github.com/mini-cuvinte).

## Start here

- **[Deploy from zero on a new infrastructure](docs/DEPLOY_FROM_ZERO.md)** — database bootstrap, environment variables, static build, Vercel or another host, and smoke tests.
- [Deployment configuration](DEPLOYMENT.md) — frontend configuration and prerequisites.
- [Supabase bootstrap](supabase/bootstrap/README.md) — schema, constraints, indexes, RLS, 23 RPC functions, permissions, board seed.
- [Supabase backup/restore](supabase/BACKUP_RESTORE.md) — private data backup, separate from clean install.
- [DEXonline source adapter](https://github.com/mini-cuvinte/dexonline-API) — independent project, with [source-change maintenance](https://github.com/mini-cuvinte/dexonline-API/blob/master/docs/DEXONLINE_SOURCE.md) and [dictionary import plan](https://github.com/mini-cuvinte/dexonline-API/blob/master/docs/IMPORT_PIPELINE.md).

## Repository layout

| Path | Purpose |
|---|---|
| `index.html` | Browser game and Supabase RPC client |
| `manifest.webmanifest` | PWA metadata |
| `config.example.js` | Example target Supabase public configuration |
| `scripts/build.mjs` | Builds static `dist/` and target-specific `config.js` |
| `vercel.json` | Vercel static build settings |
| `supabase/bootstrap/` | Application schema bootstrap without dictionary contents |
| `supabase/snapshots/` | SQL function exports and live database metadata |
| `supabase/scripts/` | Private backup and restore helpers |
| `docs/` | Deployment architecture and operational documentation |

## Quick frontend build

```bash
export SUPABASE_URL="https://YOUR_PROJECT.supabase.co"
export SUPABASE_PUBLISHABLE_KEY="YOUR_PUBLIC_PUBLISHABLE_KEY"
npm run build
```

The frontend now **requires** a deployment-generated `config.js` instead of silently connecting to the old production Supabase project. It loads `@supabase/supabase-js@2.57.0` from esm.sh.

## Dictionary strategy

Install the game schema with an empty dictionary. Later, import a licensed and validated dataset through the separate `dexonline-API` project, publish a version in Supabase, and query it locally during gameplay. No per-game remote DEXonline requests. The import pipeline is not yet implemented.

## Deployment status

The bootstrap is reconstructed from the live database catalog and has **not** yet been validated by a fresh-project restore and multiplayer smoke tests. Do not assume the project is production-ready on an arbitrary new Supabase instance. The current Vercel Git integration may still refer to the repository's old owner.

## Security

Never commit `.env`, database URLs containing credentials, service-role/secret keys, player data, or unlicensed dictionary content. Public browser configuration may contain only the Supabase publishable key.

## Verified DEXonline ETL branch

The legacy `dexonlineBK` scraper is not the complete integration. Bulk import, license checks, dictionary build and release scripts exist on `mini-cuvinte/dexonline-API` branch `modernize/python-fastapi`; the GitHub Actions workflows on `master` explicitly check out that branch. The current bulk source is `https://dexonline.ro/static/download/dex-database.sql.gz`. See [the full source-change and update playbook](docs/DEXONLINE.md).

See also [dependency audit](docs/DEPENDENCIES.md) and [deployment guide](DEPLOYMENT.md). No clean-room deployment has yet been verified.
