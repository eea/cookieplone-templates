# {{ cookiecutter.title }}

[![Releases](https://img.shields.io/github/v/release/eea/{{ cookiecutter.__project_slug }})](https://github.com/eea/{{ cookiecutter.__project_slug }}/releases)

[![Pipeline](https://ci.eionet.europa.eu/buildStatus/icon?job=volto-addons%2F{{ cookiecutter.__project_slug }}%2Fmaster&subject=master)](https://ci.eionet.europa.eu/view/Github/job/volto-addons/job/{{ cookiecutter.__project_slug }}/job/master/display/redirect)
[![Lines of Code](https://sonarqube.eea.europa.eu/api/project_badges/measure?project={{ cookiecutter.__project_slug }}&metric=ncloc)](https://sonarqube.eea.europa.eu/dashboard?id={{ cookiecutter.__project_slug }})
[![Coverage](https://sonarqube.eea.europa.eu/api/project_badges/measure?project={{ cookiecutter.__project_slug }}&metric=coverage)](https://sonarqube.eea.europa.eu/dashboard?id={{ cookiecutter.__project_slug }})
[![Bugs](https://sonarqube.eea.europa.eu/api/project_badges/measure?project={{ cookiecutter.__project_slug }}&metric=bugs)](https://sonarqube.eea.europa.eu/dashboard?id={{ cookiecutter.__project_slug }})
[![Duplicated Lines (%)](https://sonarqube.eea.europa.eu/api/project_badges/measure?project={{ cookiecutter.__project_slug }}&metric=duplicated_lines_density)](https://sonarqube.eea.europa.eu/dashboard?id={{ cookiecutter.__project_slug }})

[![Pipeline](https://ci.eionet.europa.eu/buildStatus/icon?job=volto-addons%2F{{ cookiecutter.__project_slug }}%2Fdevelop&subject=develop)](https://ci.eionet.europa.eu/view/Github/job/volto-addons/job/{{ cookiecutter.__project_slug }}/job/develop/display/redirect)
[![Lines of Code](https://sonarqube.eea.europa.eu/api/project_badges/measure?project={{ cookiecutter.__project_slug }}&branch=develop&metric=ncloc)](https://sonarqube.eea.europa.eu/dashboard?id={{ cookiecutter.__project_slug }}&branch=develop)
[![Coverage](https://sonarqube.eea.europa.eu/api/project_badges/measure?project={{ cookiecutter.__project_slug }}&branch=develop&metric=coverage)](https://sonarqube.eea.europa.eu/dashboard?id={{ cookiecutter.__project_slug }}&branch=develop)
[![Bugs](https://sonarqube.eea.europa.eu/api/project_badges/measure?project={{ cookiecutter.__project_slug }}&branch=develop&metric=bugs)](https://sonarqube.eea.europa.eu/dashboard?id={{ cookiecutter.__project_slug }}&branch=develop)
[![Duplicated Lines (%)](https://sonarqube.eea.europa.eu/api/project_badges/measure?project={{ cookiecutter.__project_slug }}&branch=develop&metric=duplicated_lines_density)](https://sonarqube.eea.europa.eu/dashboard?id={{ cookiecutter.__project_slug }}&branch=develop)


{{ cookiecutter.description }}

## Features

Demo GIF

## Getting started

### Try {{ cookiecutter.__npm_package_name }} with Docker

      git clone https://github.com/eea/{{ cookiecutter.__project_slug }}.git
      cd {{ cookiecutter.__project_slug }}
      make
      make start

Go to http://localhost:3000

`make start` now defaults to Volto 19. To run the same setup against Volto 18, use:

      VOLTO_VERSION=18-yarn make
      VOLTO_VERSION=18-yarn make start

### Add {{ cookiecutter.__npm_package_name }} to your Volto project

Before starting make sure your development environment is properly set. See the official Plone documentation for [creating a project with Cookieplone](https://6.docs.plone.org/install/create-project-cookieplone.html) and [installing an add-on in development mode in Volto 18 and 19](https://6.docs.plone.org/volto/development/add-ons/install-an-add-on-dev-18.html).

For new Volto 18+ projects, use Cookieplone. It includes `mrs-developer` by default.

1.  Create a new Volto project with Cookieplone

        uvx cookieplone project
        cd project-title

1.  Add the following to `mrs.developer.json`:

        {
            "{{ cookiecutter.__project_slug }}": {
                "output": "packages",
                "url": "https://github.com/eea/{{ cookiecutter.__project_slug }}.git",
                "package": "{{ cookiecutter.__npm_package_name }}",
                "branch": "develop",
                "path": "src"
            }
        }

1.  Add `{{ cookiecutter.__npm_package_name }}` to the `addons` key in your project `volto.config.js`

1.  Install or refresh the project setup

        make install

1.  Start backend in one terminal

        make backend-start

    ...wait for backend to setup and start, ending with `Ready to handle requests`

    ...you can also check http://localhost:8080/Plone

1.  Start frontend in a second terminal

        make frontend-start

1.  Go to http://localhost:3000

1.  Happy hacking!

        cd packages/{{ cookiecutter.__project_slug }}

For legacy Volto 18 projects, keep using the yarn-based workflow from the Volto 18 documentation.

## Cypress

To run cypress locally, first make sure you don't have any Volto/Plone running on ports `8080` and `3000`.

You don't have to be in a `clean-volto-project`, you can be in any Volto Frontend project where you added `{{ cookiecutter.__npm_package_name }}` to `mrs.developer.json`

Go to:

  ```BASH
  cd packages/{{ cookiecutter.__project_slug }}/
  ```

Start:

  ```Bash
  make
  make start
  ```

This will build and start with Docker a clean `Plone backend` and `Volto Frontend` with `{{ cookiecutter.__npm_package_name }}` block installed.

Use `make VOLTO_VERSION=18-yarn start` if you need to reproduce the Volto 18 setup locally.

Open Cypress Interface:

  ```Bash
  make cypress-open
  ```

Or run it:

  ```Bash
  make cypress-run
  ```


## Internationalization (i18n) and localization (l10n)

See [Internationalization](https://6.docs.plone.org/volto/development/i18n.html) and [Translate Volto](https://6.docs.plone.org/i18n-l10n/contributing-translations.html#translate-volto).