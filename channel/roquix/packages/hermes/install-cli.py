"""Assemble the store-owned CLI using upstream's source-layout launchers."""

import json
from pathlib import Path
import shutil
import sys

sys.dont_write_bytecode = True


def install(out, python, version):
    source = Path.cwd()
    repo = out / "lib/hermes/source"
    site = out / "lib/hermes/site-packages"
    site.mkdir(parents=True)
    excluded = {".git", "apps", "web", "ui-tui", "website", "docs", "tests", "tests-js", "node_modules"}
    repo.mkdir()
    for item in source.iterdir():
        if item.name in excluded or item.name.startswith("."):
            continue
        if item.is_dir():
            shutil.copytree(item, repo / item.name, ignore=shutil.ignore_patterns("__pycache__"))
        else:
            shutil.copy2(item, repo / item.name)
    sys.path.insert(0, str(repo))
    from scripts.build.agent import write_metadata
    from scripts.build.inputs import project_entries
    from scripts.build.launchers import write_launchers

    project = repo / "pyproject.toml"
    write_metadata(project, repo)
    stamp = {
        "schemaVersion": 2, "commit": "bf0203a794a07aac3ff764972ab9087baa4e4f4e",
        "baseVersion": version, "displayVersion": version, "distance": 0,
        "source": "guix", "distribution": "guix", "updateMechanism": "external",
        "payload": "bootstrap", "builtAt": None, "dirty": False,
        "pmRuntime": str(out / "lib/hermes"),
    }
    (repo / "install-stamp.json").write_text(json.dumps(stamp))
    (out / "lib/hermes/pm-runtime.json").write_text(json.dumps({
        "python": str(python), "sitePackages": "site-packages",
    }))
    # Guix, like Nix, supplies the independent PM imports in the immutable closure.
    # https://github.com/NousResearch/hermes-agent/blob/v0.22.5/pm/runtime.py
    runtime = repo / "pm/runtime.py"
    text = runtime.read_text()
    old = 'stamp.get("distribution") not in ("nix", "docker")'
    if text.count(old) != 1:
        raise ValueError("upstream PM distribution contract changed")
    runtime.write_text(text.replace(old, 'stamp.get("distribution") not in ("nix", "docker", "guix")'))
    write_launchers(out, project_entries(project), python=str(python), repo=str(repo),
                    site=str(site), target="linux-x64")


if __name__ == "__main__":
    install(Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3])
