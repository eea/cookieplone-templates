"""Post generation hook for EEA frontend_addon template.

Patches the generated addon's package.json to add:
- lint-staged configuration (used by .husky/pre-commit)
- husky and lint-staged devDependencies
- "prepare": "husky install" script
"""

import json
from collections import OrderedDict
from pathlib import Path

context: OrderedDict = {{cookiecutter}}


def main():
    """Patch the generated addon package.json with EEA lint-staged + husky config."""
    addon_name = context.get("frontend_addon_name", "")
    if not addon_name:
        return

    output_dir = Path().cwd()
    pkg_path = output_dir / "packages" / addon_name / "package.json"

    if not pkg_path.is_file():
        return

    data = json.loads(pkg_path.read_text())

    # Add lint-staged configuration
    data["lint-staged"] = {
        "src/**/*.{js,jsx,ts,tsx,json}": [
            "make lint-fix",
            "make prettier-fix",
        ],
        "src/**/*.{jsx}": [
            "make i18n",
        ],
        "theme/**/*.{css,less}": [
            "make stylelint-fix",
        ],
        "src/**/*.{css,less}": [
            "make stylelint-fix",
        ],
        "theme/**/*.overrides": [
            "make stylelint-fix",
        ],
        "src/**/*.overrides": [
            "make stylelint-fix",
        ],
    }

    # Add "prepare" script for husky
    scripts = data.setdefault("scripts", {})
    scripts["prepare"] = "husky install"

    # Add husky and lint-staged to devDependencies
    dev_deps = data.setdefault("devDependencies", {})
    dev_deps["husky"] = "^8.0.3"
    dev_deps["lint-staged"] = "^14.0.1"

    pkg_path.write_text(json.dumps(data, indent=2) + "\n")


if __name__ == "__main__":
    main()
