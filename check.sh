#!/bin/bash

echo "Running Repo Health Checks..."

# CHECK 1 — README exists
if [ ! -f README.md ]; then
  echo "README.md file missing"
  exit 1
fi

# CHECK 2 — README has more than 5 lines
README_LINES=$(wc -l < README.md)

if [ "$README_LINES" -le 5 ]; then
  echo "README.md must contain more than 5 lines"
  exit 1
fi

# CHECK 3 — .gitignore exists
if [ ! -f .gitignore ]; then
  echo ".gitignore file missing"
  exit 1
fi

# CHECK 4 — No .env files committed
if find . -name ".env" | grep -q .; then
  echo ".env file detected"
  exit 1
fi

# CHECK 5 — Commit messages > 5 words
COMMIT_MSG=$(git log -1 --pretty=%s)
WORD_COUNT=$(echo "$COMMIT_MSG" | wc -w)

if [ "$WORD_COUNT" -le 5 ]; then
  echo "Commit message too short: $COMMIT_MSG"
  exit 1
fi

# CHECK 6 — No TODO comments
if grep -r "TODO" . --exclude-dir=.git; then
  echo "TODO comments found"
  exit 1
fi

echo "All checks passed!"
exit 0
