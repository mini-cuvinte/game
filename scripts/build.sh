#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p dist
cp index.html manifest.webmanifest dist/
python3 scripts/generate_config.py
echo "Static site generated in dist/"
