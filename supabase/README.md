# Supabase backend

Project ref: `ajrfqwscwejunzmfhwvw`.

The frontend calls 14 PostgreSQL RPC functions. Game state and room rules live in Supabase, not just in index.html.

The database currently has migration history for multiplayer rooms, server-side turns, validation, scoring, moderation, profiles, leaderboards, and DEXonline staging.

The schema-only SQL export is PENDING. Never treat this inventory as a restorable database backup.

Export the `public`, `private`, `dictionary_private`, and `dexonline` schemas, including RPC functions, RLS policies, grants and triggers. Review the resulting SQL before committing. Never commit player data, auth users, service-role keys or database credentials.

Dictionary ETL and release workflows remain in the separate `gabrielstanica/dexonline-API` repository.
