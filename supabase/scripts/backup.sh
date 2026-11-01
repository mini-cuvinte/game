#!/usr/bin/env bash
set -euo pipefail

# Requires Supabase CLI, Docker, and a connection string stored locally.
# Never commit this output: it may contain private user data and credentials.
: "${SUPABASE_DB_URL:?Set SUPABASE_DB_URL in your local shell or secret manager}"
stamp="$(date -u +%Y%m%dT%H%M%SZ)"
dest="${1:-./private-backups}/$stamp"
mkdir -p "$dest"
chmod 700 "$dest"

supabase db dump --db-url "$SUPABASE_DB_URL" -f "$dest/roles.sql" --role-only
supabase db dump --db-url "$SUPABASE_DB_URL" -f "$dest/schema.sql"
supabase db dump --db-url "$SUPABASE_DB_URL" -f "$dest/data.sql" --use-copy --data-only -x "storage.buckets_vectors" -x "storage.vector_indexes"
supabase db dump --db-url "$SUPABASE_DB_URL" -f "$dest/migration-history-schema.sql" --schema supabase_migrations
supabase db dump --db-url "$SUPABASE_DB_URL" -f "$dest/migration-history-data.sql" --use-copy --data-only --schema supabase_migrations

(cd "$dest" && sha256sum *.sql > SHA256SUMS)
echo "Backup saved to $dest"
echo "Keep this directory encrypted and outside public GitHub. Verify restore in an isolated project."
