# Supabase backend

Mini Cuvinte uses Supabase Auth, PostgreSQL application schemas, and RPC functions.

- [Clean application bootstrap](bootstrap/README.md)
- [Complete new-infrastructure deployment guide](../docs/DEPLOY_FROM_ZERO.md)
- [Private backup and restore](BACKUP_RESTORE.md)
- [SQL function snapshots](snapshots/)
- [Independent DEXonline adapter](https://github.com/mini-cuvinte/dexonline-API)

## Application bootstrap

The `bootstrap/` folder contains 15 application tables across `public`, `private` and `dictionary_private`, 47 constraints, indexes, RLS, 23 functions, grants and 49 board bonus cells. This excludes the 24-table `dexonline` staging schema, which belongs to the future import workflow.

A new project has **no imported dictionary**. The separate DEXonline importer will later publish versioned, licensed words to the local database. The browser must not query DEXonline during gameplay.

## Important caveat

The SQL is reconstructed from the live database catalog. It is not a verified full migration replay; a clean-room Supabase install and gameplay tests are still required. The snapshot directory is not a substitute for a data backup. Do not commit user records, secrets or dictionary datasets to this public repository.
