# syntax=docker/dockerfile:1
ARG VOLTO_VERSION
FROM plone/frontend-builder:${VOLTO_VERSION}

ARG ADDON_NAME
ARG ADDON_PATH
ARG CHROMIUM_VERSION=149.0.7827.196-1~deb12u1

ENV HOST="0.0.0.0"
ENV CHROME_BIN="/usr/bin/chromium"
ENV CHROMIUM_BIN="/usr/bin/chromium"
ENV CYPRESS_BROWSER_PATH="/usr/bin/chromium"

# Install Cypress dependencies + Chromium
USER root
RUN apt-get update -q \
    && apt-get install -qy --no-install-recommends \
        libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 \
        libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    mkdir -p /etc/apt/sources.list.d /etc/apt/preferences.d /etc/apt/apt.conf.d; \
    printf '%s\n' 'Acquire::Check-Valid-Until "false";' \
      > /etc/apt/apt.conf.d/99snapshot-no-check-valid-until; \
    printf '%s\n' \
      'deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/20260630T000000Z bookworm-security main' \
      'deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/20260630T000000Z bookworm main' \
      > /etc/apt/sources.list.d/bookworm-chromium149-snapshot.list; \
    apt-get update -q; \
    apt-get install -qy --no-install-recommends \
      "chromium=${CHROMIUM_VERSION}" "chromium-common=${CHROMIUM_VERSION}"; \
    apt-mark hold chromium chromium-common; \
    rm -rf /var/lib/apt/lists/*

USER node

# Copy the add-on into the image (.dockerignore keeps .git/core/node_modules/build
# out), then overlay it onto the base Volto project so the EEA Makefile targets
# (lint/test/start/cypress) run the add-on's own scripts (root package.json
# test/lint/...), not the base image's. `rm -rf /app/cypress` first so the add-on's
# cypress/ replaces the base's (which ships an upstream Volto e2e.js using
# reset-fixture -> /Plone/RobotRemote, not available on the EEA backend).
COPY --chown=node:node ./ /app/src/addons/${ADDON_PATH}/
RUN rm -rf /app/cypress \
    && cp -r /app/src/addons/${ADDON_PATH}/. /app/ \
    && pnpm install \
    && make build-deps

WORKDIR /app
ENTRYPOINT ["pnpm"]
CMD ["start"]