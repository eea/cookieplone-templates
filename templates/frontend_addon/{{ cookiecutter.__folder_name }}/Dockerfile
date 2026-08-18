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

# Copy entire addon project into the container
COPY --chown=node:node ./ /app/src/addons/${ADDON_PATH}/

# Install addon: Volto 18 has /setupAddon, Volto 19 does not
RUN if [ -f /setupAddon ]; then \
      # --- Legacy Volto 18 yarn-based builder ---
      /setupAddon && yarn install; \
    else \
      # --- Volto 18 (pnpm) / Volto 19 (pnpm) workspace builder ---
      # Overlay the add-on's workspace + config onto the base Volto project so
      # the EEA Makefile targets (lint/test/start/cypress) run the add-on's own
      # scripts (root package.json "test"/"lint"/...) instead of the base image's
      # (which would otherwise run Volto's own test suite and fail).
      cp -r /app/src/addons/${ADDON_PATH}/packages/${ADDON_PATH} /app/packages/${ADDON_PATH} && \
      cp /app/src/addons/${ADDON_PATH}/volto.config.js  /app/volto.config.js && \
      cp /app/src/addons/${ADDON_PATH}/cypress.config.js /app/cypress.config.js && \
      cp -r /app/src/addons/${ADDON_PATH}/cypress /app/cypress && \
      cp /app/src/addons/${ADDON_PATH}/Makefile /app/Makefile && \
      cp /app/src/addons/${ADDON_PATH}/package.json /app/package.json && \
      cp /app/src/addons/${ADDON_PATH}/pnpm-workspace.yaml /app/pnpm-workspace.yaml && \
      cp /app/src/addons/${ADDON_PATH}/.npmrc /app/.npmrc && \
      cp /app/src/addons/${ADDON_PATH}/.pnpmfile.cjs /app/.pnpmfile.cjs && \
      cp /app/src/addons/${ADDON_PATH}/.eslintrc.js /app/.eslintrc.js && \
      cp /app/src/addons/${ADDON_PATH}/.prettierrc /app/.prettierrc && \
      cp /app/src/addons/${ADDON_PATH}/.prettierignore /app/.prettierignore && \
      cp /app/src/addons/${ADDON_PATH}/.stylelintrc /app/.stylelintrc && \
      cp -r /app/src/addons/${ADDON_PATH}/.storybook /app/.storybook && \
      pnpm install && make build-deps; \
    fi

WORKDIR /app
ENTRYPOINT ["pnpm"]
CMD ["start"]
