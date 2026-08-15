# {{ cookiecutter.title }}

{{ cookiecutter.description }}

## Development

```bash
# Fetch Volto core + addons (via mrs.developer.json) and install dependencies
make develop

# Start the frontend (requires a Plone backend running on port 8080)
make start
```

The frontend will be available at http://localhost:3000.

## Build

```bash
make build
```

## Testing

```bash
# Run Cypress acceptance tests
make cypress

# Open Cypress interactive runner
make cypress-open
```

## Docker

```bash
# Build the Docker image
docker build -t {{ cookiecutter.__docker_image }} .
```

## Project structure

This project uses the Volto 19 add-on driven development pattern with pnpm workspaces:

- `packages/{{ cookiecutter.frontend_addon_name }}/` — Project-specific add-on (routes, config, components)
- `packages/` — Fetched add-on sources (via `mrs.developer.json`)
- `core/` — Volto core source (fetched by `mrs.developer.json`)
- `volto.config.js` — Add-on registration
- `pnpm-workspace.yaml` — Workspace definition

## CI

The Jenkinsfile defines the CI pipeline:
- Bundlewatch (bundle size monitoring)
- Gitflow release automation
- Docker image build & push
- Rancher catalog update & demo upgrade
- SonarQube tag updates

{{ cookiecutter.__generator_signature }}
