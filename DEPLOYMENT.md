# Deployment configuration

The frontend is **environment-specific at build time**, not hardwired to the original Supabase project.

- `SUPABASE_URL` (required): target Supabase HTTPS project URL.
- `SUPABASE_PUBLISHABLE_KEY` (required): target public browser key. Never use `sb_secret_...` or a service-role key.
- `npm run build` (Node.js 20+) creates `dist/config.js` with `window.MINI_CUVINTE_CONFIG`. The browser loads this before the application module.

```bash
SUPABASE_URL=https://YOUR_PROJECT.supabase.co SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_KEY npm run build
python3 -m http.server 8080 -d dist
```

On Vercel connect `mini-cuvinte/game`, use `npm run build` and `dist`, and set both environment variables in the Vercel project. For another static host upload the contents of `dist/`.

**Important:** the browser requires Supabase Auth + PostgREST RPC; an ordinary PostgreSQL database alone is insufficient. `@supabase/supabase-js@2.57.0` is loaded from esm.sh at runtime.

Full instructions: [Deploy from zero](docs/DEPLOY_FROM_ZERO.md). Database setup: [Supabase bootstrap](supabase/bootstrap/README.md). Dictionary maintenance: [DEXonline source adapter](https://github.com/mini-cuvinte/dexonline-API/blob/master/docs/DEXONLINE_SOURCE.md).

Current state: no fresh-project end-to-end restore test has been completed. Do not run the bootstrap against the live project.
