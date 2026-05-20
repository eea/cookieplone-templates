# EEA Cookieplone Templates

EEA template repository extending [Plone's cookieplone-templates](https://github.com/plone/cookieplone-templates) with EEA-specific conventions: Jenkins CI, EEA organization defaults (`@eeacms/` npm scope, `eea` GitHub org), and standardized add-on setup.

## Templates

| Template ID | Title | Description |
|---|---|---|
| `frontend_addon` | EEA Frontend Add-on for Plone | Volto add-on with EEA conventions (Jenkins CI, Docker, `@eeacms/` scope) |

All upstream templates from `plone/cookieplone-templates` are also available (Projects, Backend Add-on, etc.).

## Quick start

```bash
# Install cookieplone (requires the extends feature from PR #186)
uvx cookieplone --version

# Generate an EEA Volto add-on
cookieplone gh:eea/cookieplone-templates frontend_addon

# Or with no prompts (uses all EEA defaults):
cookieplone gh:eea/cookieplone-templates frontend_addon --no-input
```

## What's different from the Plone upstream?

The `frontend_addon` template overrides the Plone upstream with EEA-specific additions:

- **Jenkins CI** — `Jenkinsfile` with EEA CI pipeline (SonarQube, Docker-based testing, gitflow)
- **EEA organization defaults** — `@eeacms/` npm scope, `eea` GitHub org, EEA author/email
- **Documentation always included** — no opt-in prompt
- **VSCode config always included** — no opt-in prompt
- **No GitHub Actions** — EEA uses Jenkins, not GitHub CI

All other files (Makefile, cypress, storybook, pnpm workspace, hooks, locales, etc.) are inherited from the Plone upstream via the `extends` overlay mechanism.

## Local development / testing

To test changes locally before pushing:

```bash
# Clone this repo and cookieplone (PR #186 branch)
git clone https://github.com/eea/cookieplone-templates.git
git clone -b issue-175 https://github.com/plone/cookieplone.git

# Install cookieplone from the PR branch
cd cookieplone
uv venv .venv
uv pip install -e .

# Clear the upstream cache if needed
rm -rf ~/.cookiecutters/cookieplone-templates

# Generate a test project
COOKIEPLONE_REPOSITORY=../eea-cookieplone-templates \
  .venv/bin/cookieplone frontend_addon \
  --no-input \
  --output-dir /tmp/test-eea
```

## Repository structure

```
eea/cookieplone-templates/
├── cookieplone-config.json           ← extends gh:plone/cookieplone-templates
├── README.md
└── templates/
    └── frontend_addon/
        ├── cookiecutter.json         ← upstream copy with EEA defaults
        └── {{ cookiecutter.__folder_name }}/
            ├── Jenkinsfile            ← EEA CI
            └── DEVELOP.md            ← EEA dev docs
```

Only the files that differ from the Plone upstream are stored here. Everything else is inherited automatically via the `extends` mechanism.

## Adding more EEA templates

To add EEA overrides for other templates (backend add-on, projects, etc.), add entries to `cookieplone-config.json` and create the corresponding template directories. See the [cookieplone extends documentation](https://github.com/plone/cookieplone/pull/186) for details.