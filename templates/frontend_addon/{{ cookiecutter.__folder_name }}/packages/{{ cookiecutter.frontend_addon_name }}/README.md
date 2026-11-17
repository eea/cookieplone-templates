# {{ cookiecutter.__npm_package_name }}

[![Releases](https://img.shields.io/github/v/release/{{ cookiecutter.github_organization }}/{{ cookiecutter.frontend_addon_name }})]({{ cookiecutter.__repository_url }}/releases)
[![Pipeline](https://ci.eionet.europa.eu/buildStatus/icon?job=volto-addons%2F{{ cookiecutter.frontend_addon_name }}%2Fmaster&subject=master)](https://ci.eionet.europa.eu/view/Github/job/volto-addons/job/{{ cookiecutter.frontend_addon_name }}/job/master/display/redirect)
[![Coverage](https://sonarqube.eea.europa.eu/api/project_badges/measure?project={{ cookiecutter.frontend_addon_name }}&metric=coverage)](https://sonarqube.eea.europa.eu/dashboard?id={{ cookiecutter.frontend_addon_name }})

{{ cookiecutter.description }}

## Features

Describe here what the add-on does and where the editor finds it.

## Requirements

### Backend

- [Plone](https://plone.org/download)
- [plone.restapi](https://pypi.org/project/plone.restapi/)

### Frontend

- Volto {{ cookiecutter.volto_version }}

## Installation

Add the add-on to your project and register it:

```bash
pnpm add {{ cookiecutter.__npm_package_name }}
```

```js
// volto.config.js
const addons = ['{{ cookiecutter.__npm_package_name }}'];
```

Then install the backend dependencies and restart the stack.

## Source code and development

The add-on is developed in [{{ cookiecutter.github_organization }}/{{ cookiecutter.frontend_addon_name }}]({{ cookiecutter.__repository_url }}),
where `DEVELOP.md` explains how to run it locally and `RELEASE.md` how it is released.
The package of a Volto 19 add-on lives in `packages/{{ cookiecutter.frontend_addon_name }}` of that repository.

## License

MIT, {{ cookiecutter.author }}.
