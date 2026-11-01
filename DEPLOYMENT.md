# Mini Cuvinte infrastructure configuration

The frontend reads `window.MINI_CUVINTE_CONFIG` if present, and otherwise falls back to the existing production Supabase project for backward compatibility.

For an alternative infrastructure, inject this configuration before the game's module script:

```html
<script>
window.MINI_CUVINTE_CONFIG = {
  supabaseUrl: "https://YOUR_PROJECT.supabase.co",
  supabasePublishableKey: "YOUR_PUBLIC_PUBLISHABLE_KEY"
};
</script>
```

Use only a public/publishable key in the browser, never a service-role or secret key. Set the new project's Supabase Auth URL configuration, redirect URLs and anonymous authentication options as appropriate. The backend requires Supabase Auth, PostgREST RPC and PostgreSQL; a standalone Postgres server is not a drop-in replacement.

The production fallback should be removed before a truly isolated deployment to avoid connecting a new frontend to the old project accidentally. The bootstrap is not yet verified on a fresh instance.
