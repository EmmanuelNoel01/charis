#!/bin/bash

PROJECT="/Applications/XAMPP/xamppfiles/htdocs/charis"

cd "$PROJECT"

fswatch -o \
--exclude "\.git" \
--exclude "gitwatch.sh" \
--exclude "gitwatch.log" \
--exclude "push.sh" \
"$PROJECT" | while read change
do
    if [[ -n $(git status --porcelain) ]]; then
        ./push.sh >> gitwatch.log 2>&1
    fi
done