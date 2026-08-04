#!/bin/bash

PROJECT="/Applications/XAMPP/xamppfiles/htdocs/charis"

cd "$PROJECT"

echo "Git watcher started..."

fswatch -o "$PROJECT" | while read change
do
    # Check if there are actual Git changes
    if [[ -n $(git status --porcelain) ]]; then
        ./push.sh
    else
        echo "No changes detected"
    fi
done