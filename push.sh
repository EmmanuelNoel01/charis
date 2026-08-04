#!/bin/bash

# Check if there are changes
if [[ -z $(git status --porcelain) ]]; then
    exit 0
fi

echo "Starting Git upload..."

git add .

git commit -m "Auto update the repo latest update as of $(date '+%Y-%m-%d %H:%M')"

git push origin main

echo "Upload completed!"