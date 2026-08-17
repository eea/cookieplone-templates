#!/bin/bash
# EEA pre_prompt hook: convert merged cookiecutter.json to cookieplone.json
# with EEA-specific fields hidden from prompts.
#
# The EEA Makefile, docker-compose.yml, Jenkinsfile and other EEA-specific
# files are provided as template files in the overlay (no runtime patching needed).
#
# Visible prompts (user can change these):
#   - title                 (Add-on Title)
#   - description           (Short description)
#   - frontend_addon_name   (Add-on name, auto-derived from title)
#   - use_prerelease_versions (Should we use prerelease versions?)
#   - volto_version         (Volto version)
#
# Hidden constants (EEA defaults, not prompted):
#   - author, email, github_organization, npm_package_name
#   - initialize_ci, initialize_documentation (removed entirely)
#
# Hidden computed (Jinja2 templates rendered during generation):
#   - all __ prefixed keys
set -e

# ── 1. Convert cookiecutter.json → cookieplone.json (v2) ──────────────────

python3 -c "
import json, os

path = 'cookiecutter.json'
if not os.path.exists(path):
    exit(0)

with open(path) as f:
    raw = json.load(f)

# Keys to completely remove (not needed by EEA)
for key in ('initialize_ci', 'initialize_documentation'):
    raw.pop(key, None)

# Build v2 cookieplone.json from v1 cookiecutter.json
prompts = raw.pop('__prompts__', {})
extensions = raw.pop('_extensions', [])
no_render = raw.pop('_copy_without_render', [])
template_id = raw.pop('__cookieplone_template', '')
subtemplates_raw = raw.pop('__cookieplone_subtemplates', [])

# Keys that are literal EEA constants (not prompted, not rendered)
CONSTANT_KEYS = {
    'author',
    'email',
    'github_organization',
}

properties = {}
for key, value in raw.items():
    if key.startswith('__'):
        fmt = 'computed'
    elif key.startswith('_'):
        fmt = 'constant'
    elif key in CONSTANT_KEYS:
        fmt = 'constant'
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

# Build subtemplates
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
