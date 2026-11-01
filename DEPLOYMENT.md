# Deploy Mini Cuvinte on a new infrastructure

## Dependencies and requirements

- Static hosting (Vercel, Netlify, Cloudflare Pages, Nginx, etc.)
- Python 3 for the static build configuration generator
- Supabase-compatible backend: PostgreSQL + Supabase Auth + PostgREST RPC (plain PostgreSQL alone is not sufficient)
- `psql` and a database connection string for one-time bootstrap
- No DEXonline connection required at game runtime

## Fresh deployment

1. Create a new Supabase project. Enable anonymous sign-in in Authentication if guests are used. Configure Site URL and redirect allow-list for the new host.
2. Run [the bootstrap SQL](supabase/bootstrap/README.md) against the **new** database, not production.
3. Set the following environment variables in the hosting provider:

| Variable | Purpose | Secret? |
|---|---|---|
| `SUPABASE_URL` | Target Supabase project HTTPS URL | No |
| `SUPABASE_PUBLISHABLE_KEY` | Target project's publishable/anon key | Public browser key |
| `DATABASE_URL` | One-time database bootstrap/ETL connection | **Yes: never expose to frontend** |

4. Set build command `bash scripts/build.sh`, output directory `dist`. This creates `dist/index.html`, `dist/manifest.webmanifest`, `dist/config.js`. There is **no** dependency on nonexistent `sw.js` or `icon.svg`.
5. Deploy and test guest sign-in, room creation/join, turn transitions, score and leaderboard. Word validation requires a later imported/approved dictionary.
6. Set the Git integration to [mini-cuvinte/game](https://github.com/mini-cuvinte/game), branch `main`.

### Vercel

Framework preset: **Other**; Root Directory: repository root; Build Command: `bash scripts/build.sh`; Output Directory: `dist`. Add `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` to the project's environment variables. Do not put `DATABASE_URL` in a frontend build unless strictly needed by a protected separate job.

### Local

```bash
export SUPABASE_URL="https://YOUR_PROJECT.supabase.co"
export SUPABASE_PUBLISHABLE_KEY="YOUR_PUBLIC_KEY"
bash scripts/build.sh
python3 -m http.server 8080 --directory dist
```

Open `http://localhost:8080`. If using a local Supabase stack, set `SUPABASE_URL` to the browser-accessible local API URL.

## Runtime config and safety

`index.html` loads `/config.js` before the JS module. The build creates `window.MINI_CUVINTE_CONFIG = {supabaseUrl, supabasePublishableKey}`. There is no fallback to the previous production project: a missing config fails explicitly. `config.example.js` is a template, not a live config.

Do not publish the service-role key, database URL, import credentials, raw dictionary dumps, or player records. Regenerate the static build after changing environments. For deployment without a build step, create a `config.js` from the example with the new public URL/key and serve it next to `index.html`.

## Limitations

The bootstrap was reconstructed from the live catalogs and has not yet passed a full clean-room smoke test. Supabase Auth, Realtime subscriptions, database grants and API settings must be validated on the new target. Do not assume a standalone PostgreSQL server provides Supabase API behavior.
