#!/bin/bash

echo "Starting Git upload..."

# Check if there are changes
if [[ -z $(git status --porcelain) ]]; then
    echo "No changes detected. Nothing to push."
    exit 0
fi

# Add changes (ignored files will be skipped)
git add .

# Commit
git commit -m "Auto update the repo latest update as of $(date '+%Y-%m-%d %H:%M')"

# Push
git push origin main

echo "Upload completed!"