# Backup and restore

The files under `supabase/snapshots/` contain extracted database logic and metadata. They are **not** a full, replayable dump.

## Full logical backup

Run `supabase/scripts/backup.sh` from a trusted machine or protected CI runner with `SUPABASE_DB_URL` supplied via a secret manager. The script exports roles, schema, data, and migration history and records checksums. It requires Supabase CLI and Docker. The connection string must never be printed, committed, or pasted into a chat.

**Keep full dumps encrypted outside the Git repository**: data may include user accounts, profile records, room histories, and dictionary content subject to licensing. The `private-backups/` directory is intentionally excluded from version control.

## Restore verification

Create a fresh isolated Supabase project, set `RESTORE_DB_URL` through a secret manager, and run `supabase/scripts/restore.sh <backup-directory>`. This restores the core database. Follow the official Supabase restore guidance for migration-history records, auth/storage customizations, encryption root keys, Realtime publications, and Storage objects. Reconfigure project secrets manually.

A backup is **not verified as restorable** until a complete test restore succeeds and application smoke tests pass. Never test restore against production.

## Dictionary policy

Keep dictionary import/ETL and license provenance in `mini-cuvinte/dexonline-API`. Import into Supabase staging, validate, publish a versioned local dictionary, and query it locally during games. Do **not** fetch or reimport from DEXonline per game/session. Preserve the published version and approved overrides in the private backup; reimport only on explicit dictionary releases. Check redistribution and source licensing before copying dictionary data into any public repository.
