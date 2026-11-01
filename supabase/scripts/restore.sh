#!/usr/bin/env bash
set -euo pipefail
: "${RESTORE_DB_URL:?Set RESTORE_DB_URL to a NEW, isolated Supabase database}"
dir="${1:?Usage: restore.sh /path/to/private-backup}"
(cd "$dir" && sha256sum -c SHA256SUMS)

# WARNING: Run only against a disposable, isolated target.
# Review role ownership, extensions, Auth/Storage changes, encryption keys,
# and any application-specific configuration before restoring.
psql --single-transaction --set ON_ERROR_STOP=1 \
  --file "$dir/roles.sql" \
  --file "$dir/schema.sql" \
  --command 'SET session_replication_role = replica' \
  --file "$dir/data.sql" \
  --dbname "$RESTORE_DB_URL"

echo "Core database restore completed. Verify Auth, Storage objects, migrations and Realtime separately."
