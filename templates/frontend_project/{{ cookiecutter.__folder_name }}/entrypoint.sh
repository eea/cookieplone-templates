#!/usr/bin/env bash
set -Ex

# Upload source maps to Sentry (only when SENTRY_* env vars are set)
gosu node ./node_modules/@plone-collective/volto-sentry/scripts/create-sentry-release.sh

exec "$@"