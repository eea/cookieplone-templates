"""Post generation hook for EEA frontend_addon template.

Patches the generated addon's package.json to add:
- lint-staged configuration (used by .husky/pre-commit)
- husky and lint-staged devDependencies
- "prepare": "cd ../.. && husky install || true" script

The .husky/pre-commit hook lives at the repo root (not inside the addon
package), so husky install must run from there.

Also removes the unused test-runner config so a Volto 19 addon does not
ship a dead `jest-addon.config.js` (and a Volto 18 addon does not ship a
dead `vitest.config.mjs`), mirroring the upstream post-generation cleanup.
"""

import json
from collections import OrderedDict
from pathlib import Path

context: OrderedDict = {{cookiecutter}}


def remove_conditional_files(context, output_dir):
    """Drop the test-runner config that does not match the chosen framework.

    Volto 19 (Vitest) should not keep `jest-addon.config.js`; Volto 18 (Jest)
    should not keep `packages/<addon>/vitest.config.mjs`. `.pnpmfile.cjs` is only
    needed on Volto 19+, so it is removed for older versions.
    """
    addon_name = context.get("frontend_addon_name", "")
    test_framework = context.get("__test_framework", "vitest")

    if test_framework == "jest":
        vitest_path = output_dir / "packages" / addon_name / "vitest.config.mjs"
        if vitest_path.is_file():
            vitest_path.unlink()
    else:  # vitest (Volto 19+)
        jest_path = output_dir / "jest-addon.config.js"
        if jest_path.is_file():
            jest_path.unlink()

    if context.get("volto_version", "99") < "19":
        pnpmfile_path = output_dir / ".pnpmfile.cjs"
        if pnpmfile_path.is_file():
            pnpmfile_path.unlink()


def main():
    """Patch the generated addon package.json with EEA lint-staged + husky config."""
    addon_name = context.get("frontend_addon_name", "")
    if not addon_name:
        return

    output_dir = Path().cwd()
    remove_conditional_files(context, output_dir)

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

    # Add "prepare" script for husky.
    # The addon package is at packages/<addon>/, but .git is at the repo root
    # (2 levels up).  In a monorepo, .git may be further up — fail silently then.
    scripts = data.setdefault("scripts", {})
    scripts["prepare"] = "cd ../.. && husky install || true"

    # Add EEA devDependencies
    dev_deps = data.setdefault("devDependencies", {})
    dev_deps["husky"] = "^8.0.3"
    dev_deps["lint-staged"] = "^14.0.1"
    dev_deps["@cypress/code-coverage"] = "^3.10.0"
    dev_deps["@vitest/coverage-v8"] = data.get("devDependencies", {}).get("vitest", "^3.1.2")

    pkg_path.write_text(json.dumps(data, indent=2) + "\n")


if __name__ == "__main__":
    main()
