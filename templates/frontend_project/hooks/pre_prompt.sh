#!/bin/bash
# EEA pre_prompt hook for frontend_project: convert cookiecutter.json to
# cookieplone.json v2 with EEA-specific fields hidden from prompts.
#
# Visible prompts (user can change these):
#   - title           (Project Title)
#   - description     (Short project description)
#   - volto_version   (Volto version)
#
# Hidden constants (EEA defaults, not prompted):
#   - author, email, github_organization, docker_registry
#
# Hidden computed (Jinja2 templates rendered during generation):
#   - project_slug, frontend_addon_name, npm_package_name
#   - node_version, pnpm_version, sonarqube_tag
#   - rancher_stackid, rancher_envid (empty, filled per-project)
#   - all __ prefixed keys
set -e

python3 -c "
import json, os

path = 'cookiecutter.json'
if not os.path.exists(path):
    exit(0)

with open(path) as f:
    raw = json.load(f)

# Keys that are literal EEA constants (not prompted, not rendered)
CONSTANT_KEYS = {
    'author',
    'email',
    'github_organization',
    'docker_registry',
}

# Keys that are computed from other fields (not prompted, rendered during generation)
COMPUTED_KEYS = {
    'project_slug',
    'frontend_addon_name',
    'npm_package_name',
    'node_version',
    'pnpm_version',
    'sonarqube_tag',
    'rancher_stackid',
    'rancher_envid',
}

# Build v2 cookieplone.json from v1 cookiecutter.json
prompts = raw.pop('__prompts__', {})
extensions = raw.pop('_extensions', [])
no_render = raw.pop('_copy_without_render', [])
template_id = raw.pop('__cookieplone_template', '')
subtemplates_raw = raw.pop('__cookieplone_subtemplates', [])

properties = {}
for key, value in raw.items():
    if key.startswith('__'):
        fmt = 'computed'
    elif key.startswith('_'):
        fmt = 'constant'
    elif key in CONSTANT_KEYS:
        fmt = 'constant'
    elif key in COMPUTED_KEYS:
        fmt = 'computed'
    else:
        fmt = None  # visible prompt

    prop = {
        'type': 'string',
        'title': prompts.get(key, key) if isinstance(prompts.get(key), str) else key,
        'default': value,
    }
    if fmt:
        prop['format'] = fmt
    properties[key] = prop

# Build subtemplates (if any)
subtemplates = []
for entry in subtemplates_raw:
    if isinstance(entry, (list, tuple)) and len(entry) >= 3:
        subtemplates.append({
            'id': entry[0],
            'title': entry[1],
            'enabled': entry[2],
        })

result = {
    'id': template_id,
    'schema': {
        'title': 'Cookieplone',
        'description': '',
        'version': '2.0',
        'properties': properties,
    },
}

config = {}
if extensions:
    config['extensions'] = extensions
if no_render:
    config['no_render'] = no_render
if subtemplates:
    config['subtemplates'] = subtemplates
if config:
    result['config'] = config

with open('cookieplone.json', 'w') as f:
    json.dump(result, f, indent=2)

os.unlink('cookiecutter.json')
" 2>/dev/null || true
