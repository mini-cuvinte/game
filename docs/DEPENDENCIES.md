# Dependency audit and portability

Checked against the `mini-cuvinte/game` and `mini-cuvinte/dexonline-API` GitHub repositories on 2026-11-01.

| Component | Runtime dependency | Configurable? | Notes |
|---|---|---|---|
| Frontend | Static HTML/CSS/JS | Yes | `index.html`, `manifest.webmanifest` |
| Supabase JavaScript SDK | `https://esm.sh/@supabase/supabase-js@2.57.0` | Version pinned, CDN not self-hosted | Internet required for SDK import. For offline/CDN-independent deployment, vendor/bundle SDK later |
| Supabase API | Project URL | Yes | Generated `dist/config.js` via `SUPABASE_URL` |
| Supabase browser key | Public publishable key | Yes | Generated via `SUPABASE_PUBLISHABLE_KEY`, not a secret |
| Authentication | Supabase anonymous Auth | Provider-level config | Must enable guest/anonymous sign-in |
| Game backend | PostgreSQL functions + PostgREST RPC | Bootstrap | 23 functions, 15 game/dictionary tables, RLS/grants |
| Dictionary at runtime | Local Supabase dictionary tables | Yes | No dexonline.ro call during gameplay |
| Dictionary ETL | DEXonline archive + Python scripts | Separate project | Bulk ETL lives on `modernize/python-fastapi` branch |
| Hosting | Vercel/other static server | Yes | Build command `bash scripts/build.sh`; output `dist` |
| Build tools | Bash + Python 3 | Yes | No Node/npm build required for current static frontend |
| Historical Vercel build | `sw.js` and `icon.svg` | Removed from new build | These assets are absent in the repository; do not copy them |

## Remaining portability risks

1. The Supabase bootstrap has **not** been validated by a clean-room install and RPC smoke test.
2. The frontend relies on the external esm.sh CDN for Supabase JS. This is an external runtime dependency, not yet bundled.
3. The game is coupled to Supabase Auth and PostgREST; plain PostgreSQL does not provide equivalent endpoints.
4. The official DEXonline archive format and licensing metadata can change. Use dry-run preflight before every import.
5. The `dexonline-API` workflow code lives on a non-default branch; synchronize branches before routine maintenance.
6. A new host must configure its own environment variables and Supabase Auth redirect URLs.

## Acceptance test for a clean deployment

- SQL scripts complete on a fresh Supabase project.
- Generated `dist/config.js` points only to the new project.
- Guest authentication succeeds.
- Room create/join, turn advance, scoring, game completion and leaderboard work.
- Word validation rejects missing dictionary entries before import, and accepts approved entries after a licensed dictionary release.
- No traffic or writes go to the old Supabase project.
- No service-role or database credentials appear in browser assets.
