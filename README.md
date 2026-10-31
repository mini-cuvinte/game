# Mini Cuvinte

Romanian multiplayer word game. Frontend recovered from the production Vercel deployment on 2026-10-31.

## Architecture
- `index.html`: browser game, rooms, turns, bot play, authentication, leaderboard; calls Supabase RPC.
- `manifest.webmanifest`: PWA manifest.
- `supabase/schema/`: schema-only PostgreSQL snapshots, **never player data or credentials**.
- `supabase/README.md`: backend inventory and recovery procedure.

Supabase project ref: `ajrfqwscwejunzmfhwvw`.

**Important:** Frontend files alone do not restore multiplayer. Supabase database objects, RLS, RPC grants and Auth configuration are required. Dictionary import scripts and workflows are currently in [dexonline-API](https://github.com/gabrielstanica/dexonline-API); do not copy copyrighted dictionary datasets into this public repository without license clearance.

## Repository grouping proposal

Keep two repositories and one deployment:
1. `mini-cuvinte` — game + Supabase backend schema and migrations + tests.
2. `dexonline-API` — independent dictionary ETL, licensing audits, versioning workflows.
3. Vercel — deployment of the game from `mini-cuvinte`.

Later, optionally create a GitHub organization or monorepo, but avoid merging histories while the ETL is evolving.

## Safety
Never commit `.env`, `DATABASE_URL`, Supabase secret/service-role keys, auth users, player records, room contents or private dictionaries.
