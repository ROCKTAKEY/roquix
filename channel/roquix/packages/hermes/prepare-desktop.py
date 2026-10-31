"""Prepare immutable package identity for the upstream Desktop compiler."""

import json
from pathlib import Path
import sys


def stamp(version, variant):
    if variant not in {"bootstrap", "light"}:
        raise ValueError(f"unsupported Guix desktop variant: {variant}")
    return {
        "schemaVersion": 2, "commit": "bf0203a794a07aac3ff764972ab9087baa4e4f4e",
        "baseVersion": version, "displayVersion": version, "distance": 0,
        "builtAt": None, "dirty": False, "source": "guix", "distribution": "guix",
        "updateMechanism": "external", "payload": variant, "tag": f"v{version}",
    }


if __name__ == "__main__":
    version, variant = sys.argv[1:]
    metadata = stamp(version, variant)
    Path("install-stamp.json").write_text(json.dumps(metadata))
    path = Path("apps/desktop/package.json")
    package = json.loads(path.read_text())
    package["version"] = version
    if variant == "light":
        package["name"] = "hermes-light"
        package["productName"] = "Hermes Light"
    path.write_text(json.dumps(package))
