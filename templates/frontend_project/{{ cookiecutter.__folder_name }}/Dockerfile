# syntax=docker/dockerfile:1
ARG VOLTO_VERSION={{ cookiecutter.__version_plone_volto }}
FROM plone/frontend-builder:${VOLTO_VERSION} AS builder
ARG MAX_OLD_SPACE_SIZE=7168

COPY --chown=node packages/{{ cookiecutter.frontend_addon_name }} /app/packages/{{ cookiecutter.frontend_addon_name }}
COPY --chown=node volto.config.js /app/
COPY --chown=node package.json /app/
COPY --chown=node mrs.developer.json /app/
COPY --chown=node pnpm-workspace.yaml /app/
COPY --chown=node pnpm-lock.yaml /app/
COPY --chown=node .npmrc .pnpmfile.cjs /app/
COPY --chown=node entrypoint.sh /app/entrypoint.sh

RUN --mount=type=cache,id=pnpm,target=/app/.pnpm-store,uid=1000 <<EOT
    set -e
    export CI=1
    export NODE_OPTIONS=--max-old-space-size=${MAX_OLD_SPACE_SIZE}
    pnpm dlx mrs-developer@2.2.0 missdev --no-config --output=packages --fetch-https
    pnpm install --frozen-lockfile
    pnpm build:deps
    pnpm build
    pnpm install --prod --frozen-lockfile --ignore-scripts
    pnpm rebuild @sentry/cli
    node packages/{{ cookiecutter.frontend_addon_name }}/scripts/check-server-dependencies.cjs
    test -x node_modules/.bin/sentry-cli
EOT

FROM plone/frontend-prod-config:${VOLTO_VERSION}

LABEL maintainer="{{ cookiecutter.author }} <{{ cookiecutter.email }}>" \
      org.label-schema.name="{{ cookiecutter.project_slug }}" \
      org.label-schema.description="{{ cookiecutter.description }}" \
      org.label-schema.vendor="{{ cookiecutter.author }}"

COPY --from=builder /app/ /app/

USER root

RUN <<EOT
    set -e
    CI=1 npm i -g corepack@latest
    corepack enable pnpm
    corepack prepare pnpm@{{ cookiecutter.__version_pnpm }} --activate
    chmod +x /app/entrypoint.sh
EOT

USER node

EXPOSE 3000 3001

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["pnpm", "start:prod"]
