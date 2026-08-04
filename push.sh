#!/bin/bash

echo "Starting Git upload..."

# Add all changes
git add .

# Commit with current date/time
git commit -m "Auto update the repo latest update as of $(date '+%Y-%m-%d %H:%M')"

# Push to GitHub
git push origin main

echo "Upload completed!"