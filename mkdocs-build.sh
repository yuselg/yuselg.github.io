#!/usr/bin/env bash
# Build MkDocs site into /docs using uv

set -euo pipefail

# Must be run from pages/
if [ ! -f mkdocs-src/mkdocs.yml ]; then
  echo "Error: mkdocs-src/mkdocs.yml not found."
  echo "Run this from the pages/ directory."
  exit 1
fi

echo "Building MkDocs site..."
uv run mkdocs build -f mkdocs-src/mkdocs.yml
echo "MkDocs build complete."
