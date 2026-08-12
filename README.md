# EEA Cookieplone Templates

EEA template repository extending [Plone's cookieplone-templates](https://github.com/plone/cookieplone-templates) with EEA-specific conventions: Jenkins CI, EEA organization defaults (`@eeacms/` npm scope, `eea` GitHub org), and standardized add-on/project setup.

## Templates

| Template ID | Title | Description |
|---|---|---|
| `frontend_addon` | EEA Frontend Add-on for Plone | Volto add-on with EEA conventions (Jenkins CI, Docker, `@eeacms/` scope) |
| `frontend_project` | EEA Frontend Project for Plone | Volto frontend project with EEA conventions (Jenkins CI, Docker, Makefile) |

Upstream templates (backend add-on, monorepo add-on, classic project, documentation, CI, IDE, DevOps, agents) are inherited but **hidden from the menu** — only EEA-relevant templates are shown.

## Quick start

```bash
# Interactive — only 2 prompts: Title and Description
COOKIEPLONE_REPOSITORY=gh:eea/cookieplone-templates uvx cookieplone@2.0.0b3

# Generate a specific template
COOKIEPLONE_REPOSITORY=gh:eea/cookieplone-templates uvx cookieplone@2.0.0b3 frontend_addon
COOKIEPLONE_REPOSITORY=gh:eea/cookieplone-templates uvx cookieplone@2.0.0b3 frontend_project

# No prompts (uses all EEA defaults)
COOKIEPLONE_REPOSITORY=gh:eea/cookieplone-templates uvx cookieplone@2.0.0b3 frontend_addon --no-input
```

## What's different from the Plone upstream?

### Menu

Only two categories are shown:
- **Add-ons** → `EEA Frontend Add-on for Plone`
- **Projects** → `EEA Frontend Project for Plone`

All other upstream categories (Documentation, CI, IDE, DevOps, Agents, Sub-templates) are hidden.

### Prompts

The `frontend_addon` template reduces prompts to just **two**:
1. **Add-on Title** — the name of your addon
2. **Description** — a short description

All other options (author, email, GitHub org, npm scope, Volto version, prerelease versions, CI initialization, documentation) are pre-configured with EEA defaults via a `pre_prompt` hook that converts the merged `cookiecutter.json` to a `cookieplone.json` (v2 format) with non-essential fields marked as `format: "constant"` or `format: "computed"`.

### `frontend_addon` overrides

| File | Source | Purpose |
|------|--------|---------|
| `Jenkinsfile` | EEA | Dual Volto 19 (current) + Volto 18-yarn (previous) CI pipeline using upstream Makefile targets |
| `Dockerfile` | EEA | CI test image with Chromium — handles both Volto 18 (`/setupAddon`) and Volto 19 (copy to `packages/` + `pnpm install`) |
| `DEVELOP.md` | EEA | EEA development instructions |
| `LICENSE.md` | EEA | EEA MIT license |
| `RELEASE.md` | EEA | EEA release instructions (pnpm-based) |
| `.gitleaks.toml` | EEA | Security scanning config |
| `hooks/pre_prompt.sh` | EEA | Strips upstream prompts, converts to cookieplone.json v2 |
| `Makefile` | Upstream | Not overridden — upstream pnpm-based Makefile works for local dev |
| `package.json`, `.eslintrc.js`, etc. | Upstream | Inherited via `extends` overlay |

### `frontend_project` overrides

| File | Source | Purpose |
|------|--------|---------|
| `Jenkinsfile` | EEA | EEA CI pipeline (Bundlewatch, Docker build, gitflow, SonarQube) |
| `Dockerfile` | EEA | Multi-stage build with `plone/frontend-builder` |
| `Makefile` | EEA | EEA targets (develop, relstorage, staging, demo, cypress) using pnpm |
| `entrypoint.sh` | EEA | Sentry source map upload (no REBUILD) |
| `.bundlewatch.config.json` | EEA | Bundle size monitoring pattern |
| `cookiecutter.json` | EEA | EEA defaults (`@eeacms/` scope, `eea` org, Volto 19.3.0) |

## Local development / testing

```bash
git clone https://github.com/eea/cookieplone-templates.git
cd cookieplone-templates

# Generate a test add-on from local templates
COOKIEPLONE_REPOSITORY=$(pwd) uvx cookieplone@2.0.0b3 frontend_addon --no-input -o /tmp/test

# Interactive (only 2 prompts)
COOKIEPLONE_REPOSITORY=$(pwd) uvx cookieplone@2.0.0b3

# Clear the cookieplone cache if templates don't update
rm -rf ~/.cookiecutters/eea/cookieplone-templates
```

## Repository structure

```
eea/cookieplone-templates/
├── cookieplone-config.json           ← extends gh:plone/cookieplone-templates, hides non-EEA groups
├── README.md
└── templates/
    ├── frontend_addon/
    │   ├── cookiecutter.json         ← EEA defaults, no docs subtemplate
    │   ├── hooks/
    │   │   └── pre_prompt.sh        ← strips upstream prompts, converts to cookieplone.json v2
    │   └── {{ cookiecutter.__folder_name }}/
    │       ├── Jenkinsfile           ← EEA dual Volto 19/18 CI
    │       ├── Dockerfile            ← EEA CI image with Chromium
    │       ├── DEVELOP.md            ← EEA dev docs
    │       ├── LICENSE.md            ← EEA MIT license
    │       ├── RELEASE.md            ← EEA release instructions
    │       └── .gitleaks.toml        ← EEA security config
    └── frontend_project/
        ├── cookiecutter.json         ← EEA project defaults
        └── {{ cookiecutter.__folder_name }}/
            ├── Jenkinsfile           ← EEA CI (Bundlewatch, Docker, gitflow)
            ├── Dockerfile            ← multi-stage with plone/frontend-builder
            ├── Makefile              ← EEA targets (pnpm)
            ├── entrypoint.sh         ← Sentry upload, no REBUILD
            └── .bundlewatch.config.json
```

Only files that differ from the Plone upstream are stored here. Everything else (Makefile for addons, package.json, cypress config, storybook, pnpm workspace, TypeScript config, Vitest config, etc.) is inherited automatically via the `extends` overlay mechanism.
