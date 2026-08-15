#!/bin/bash
# Install husky git hooks in all packages that have a .husky directory.
# This ensures linting, betterleaks, and other pre-commit hooks are active
# in each addon's git repository.
for repo in $(ls packages); do
    if [ -d "packages/$repo/.husky" ]; then
        cd "packages/$repo"
        printf "$repo - "
        pnpm exec husky install
        cd ../../
    fi
done
