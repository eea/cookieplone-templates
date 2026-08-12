# Stage 1: Build
FROM plone/frontend-builder:{{ cookiecutter.__version_volto }} AS builder

COPY --chown=node packages/ /app/packages/
COPY --chown=node volto.config.js /app/
COPY --chown=node pnpm-workspace.yaml /app/
COPY --chown=node package.json /app/
COPY --chown=node mrs.developer.json /app/mrs.developer.json
COPY --chown=node pnpm-lock.yaml /app/pnpm-lock.yaml
COPY --chown=node razzle.config.js /app/
COPY --chown=node .bundlewatch.config.json /app/

RUN make develop && pnpm install && pnpm build
RUN CI=1 pnpm install --prod

# Stage 2: Runtime (slim)
FROM node:{{ cookiecutter.__version_node }}-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends gosu && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build /app/build
COPY --from=builder /app/node_modules /app/node_modules
COPY --chown=node entrypoint.sh /app/entrypoint.sh
COPY --chown=node .bundlewatch.config.json /app/

WORKDIR /app
EXPOSE 3000 3001

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["node", "build/server.js"]