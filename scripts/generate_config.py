#!/usr/bin/env python3
"""Generate public browser config from deployment environment variables."""
import json
import os
from pathlib import Path

url = os.environ.get("SUPABASE_URL", "").strip()
key = os.environ.get("SUPABASE_PUBLISHABLE_KEY", "").strip()
if not url.startswith(("https://", "http://localhost:", "http://127.0.0.1:")):
    raise SystemExit("SUPABASE_URL must be an HTTPS URL or localhost")
if not key:
    raise SystemExit("SUPABASE_PUBLISHABLE_KEY is required")
if "service_role" in key.lower() or key.startswith("sb_secret_"):
    raise SystemExit("Never put a Supabase secret/service role key in browser config")
target = Path(os.environ.get("PUBLIC_DIR", "dist"))
target.mkdir(parents=True, exist_ok=True)
(target / "config.js").write_text(
    "window.MINI_CUVINTE_CONFIG = " +
    json.dumps({"supabaseUrl": url, "supabasePublishableKey": key}, ensure_ascii=False) +
    ";\n", encoding="utf-8")
print("Generated public config.js in", target)
