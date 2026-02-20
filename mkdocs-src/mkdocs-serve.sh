#!/usr/bin/env bash
set -euo pipefail

PORT=8000
URL="http://127.0.0.1:$PORT/"

echo "Checking port $PORT..."

PIDS=$(lsof -ti tcp:$PORT || true)

if [ -n "$PIDS" ]; then
  echo
  echo "Port $PORT is already in use:"
  lsof -nP -iTCP:$PORT -sTCP:LISTEN
  echo
  read -r -p "Kill these process(es)? [y/N] " ans
  case "$ans" in
    y|Y) kill $PIDS ;;
    *) exit 1 ;;
  esac
fi

echo
echo "Starting MkDocs server on $URL"
echo

mkdocs serve -a 127.0.0.1:$PORT
