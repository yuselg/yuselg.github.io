#!/usr/bin/env bash
# Usage: ./git-publish.sh Commit message (quotes optional)

set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: $0 commit message"
  exit 1
fi

# Ensure we are inside a git repo
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "Error: not inside a git repository."
  exit 1
}

# Ensure we're on a branch (not detached HEAD)
branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" = "HEAD" ]; then
  echo "Error: detached HEAD. Check out a branch first."
  exit 1
fi

echo "On branch: $branch"

# Remove macOS junk files everywhere
find . -name '.DS_Store' -type f -delete

# Update from remote safely
git pull --ff-only

# Stage everything (new / modified / deleted)
git add -A

# Stop if nothing is staged
if git diff --cached --quiet; then
  echo "Nothing to commit."
  exit 0
fi

# Show summary
echo
echo "Files to be committed:"
git diff --cached --stat
echo

# Commit and push
git commit -m "$*"
git push

echo "Done."
