# Mini Cuvinte

Romanian multiplayer word game. Source is organized in two GitHub repositories:

- [mini-cuvinte/game](https://github.com/mini-cuvinte/game): frontend, game database, RPCs and deployment.
- [mini-cuvinte/dexonline-API](https://github.com/mini-cuvinte/dexonline-API): offline DEXonline extraction, license checks and dictionary releases.

## Deploy from zero

1. Create a fresh Supabase project with PostgreSQL, Auth and PostgREST. Enable anonymous authentication for guest players.
2. Clone this repository and apply the ordered SQL scripts documented in [supabase/bootstrap/README.md](supabase/bootstrap/README.md). This creates 15 application tables, 23 functions, access rules and board bonuses. DEXonline staging tables and dictionary words are intentionally excluded.
3. Configure `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` in your hosting environment. Run `bash scripts/build.sh`; deploy the generated `dist/` directory.
4. Configure Auth Site URL and allowed redirects for the new domain. Test login, room creation/join, turns, score and leaderboard.
5. Populate the dictionary separately from [dexonline-API](https://github.com/mini-cuvinte/dexonline-API), after source/license validation and approval. The game reads local database tables and never fetches DEXonline during a turn.

The frontend is static and can run on Vercel, Netlify, Cloudflare Pages or any static server. The backend requires Supabase-compatible Auth and RPC infrastructure; PostgreSQL by itself is insufficient.

**Deployment status:** The reconstructed SQL bootstrap is committed but has **not** been validated by a clean-room restore. Treat it as a deployment candidate, not yet proven production-ready. With an empty dictionary, word validation may reject moves.

## Documentation

- [Deployment](DEPLOYMENT.md)
- [Backend bootstrap](supabase/bootstrap/README.md)
- [Backup and restore](supabase/BACKUP_RESTORE.md)
- [DEXonline integration and updates](docs/DEXONLINE.md)
- [Dependency audit](docs/DEPENDENCIES.md)

## Security

Never commit private DB URLs, service-role keys, player data, raw dumps, or dictionary material without redistribution rights. Browser configuration uses only a public Supabase key.
