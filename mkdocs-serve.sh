#!/usr/bin/env bash
# Serve MkDocs locally with feedback, kill option, and auto-open browser

set -euo pipefail

PORT=8000
URL="http://127.0.0.1:$PORT/docs/"

# Must be run from pages/
if [ ! -f mkdocs-src/mkdocs.yml ]; then
  echo "Error: mkdocs-src/mkdocs.yml not found."
  echo "Run this from the pages/ directory."
  exit 1
fi

echo "Checking port $PORT..."

PIDS=$(lsof -ti tcp:$PORT || true)

if [ -n "$PIDS" ]; then
  echo
  echo "Port $PORT is already in use by:"
  echo
  lsof -nP -iTCP:$PORT -sTCP:LISTEN
  echo

  read -r -p "Kill these process(es)? [y/N] " ans
  case "$ans" in
    y|Y)
      echo "Killing process(es): $PIDS"
      kill $PIDS
      sleep 1
      ;;
    *)
      echo "Aborting. Free the port and try again."
      exit 1
      ;;
  esac
fi

echo
echo "Starting MkDocs server on $URL"
echo

# Start server in background so we can open browser after it is ready
uv run mkdocs serve -f mkdocs-src/mkdocs.yml -a 127.0.0.1:$PORT &
PID=$!

# Wait until server is responding (max ~5 seconds)
for _ in {1..25}; do
  if curl -fsS "$URL" >/dev/null 2>&1; then
    break
  fi
  sleep 0.2
done

# Open browser (macOS). Use Safari by default; change to Chrome if you want.
open "$URL" >/dev/null 2>&1 || true

# Keep server running; Ctrl+C will stop the script and mkdocs
wait "$PID"
