#!/usr/bin/env python3
"""Build static Mini Cuvinte site with deployment-specific public configuration."""
import json
import os
import pathlib
import shutil

root = pathlib.Path(__file__).resolve().parents[1]
dist = root / "dist"
url = os.environ.get("SUPABASE_URL", "").strip()
key = os.environ.get("SUPABASE_PUBLISHABLE_KEY", "").strip()
if not url.startswith(("https://", "http://localhost:", "http://127.0.0.1:")):
    raise SystemExit("SUPABASE_URL must be a valid HTTPS URL (or localhost)")
if not key or key.startswith("YOUR_"):
    raise SystemExit("SUPABASE_PUBLISHABLE_KEY must be configured")
if key.startswith(("sb_secret_", "service_role")):
    raise SystemExit("Never embed a secret/service_role key in browser assets")
dist.mkdir(exist_ok=True)
for filename in ("index.html", "manifest.webmanifest", "sw.js", "icon.svg"):
    src = root / filename
    if src.exists():
        shutil.copy2(src, dist / filename)
(dist / "config.js").write_text(
    "window.MINI_CUVINTE_CONFIG = " +
    json.dumps({"supabaseUrl": url, "supabasePublishableKey": key}, ensure_ascii=False) +
    ";\n", encoding="utf-8")
print("Static build complete: dist/ (public config generated)")
