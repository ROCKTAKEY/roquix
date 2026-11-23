"""Select the public Linux build dependencies from Proton's pnpm lockfile."""

import json
import sys
from pathlib import Path

import yaml


def desktop_dependencies(importers):
    desktop = importers["applications/inbox-desktop"]
    dependencies = {
        name: pin for name, pin in desktop["dependencies"].items()
        if not pin["version"].startswith("link:")
    }
    # Forge and webpack run against the desktop app and the shared TypeScript
    # modules it imports. Other workspace tools include private test clients.
    tools = (
        "@electron-forge/cli", "@electron-forge/maker-deb", "@electron/fuses",
        "@sentry/electron", "@vercel/webpack-asset-relocator-loader",
        "css-loader", "dotenv", "electron", "fork-ts-checker-webpack-plugin",
        "node-loader", "style-loader", "ts-loader", "typescript", "webpack",
    )
    for name, pin in desktop["devDependencies"].items():
        if name.startswith("@electron-forge/plugin-") or name in tools:
            dependencies[name] = pin
    for name in ("minimist", "ua-parser-js", "@protontech/crypto"):
        dependencies[name] = importers["packages/shared"]["dependencies"][name]
    dependencies["ts-node"] = importers["packages/colors"]["devDependencies"]["ts-node"]
    return dependencies


def desktop_lock(lock, dependencies):
    snapshots = {}
    packages = {}
    pending = [(name, pin["version"]) for name, pin in dependencies.items()]
    while pending:
        name, version = pending.pop()
        key = f"{name}@{version}"
        if key not in lock["snapshots"]:
            key = version  # npm aliases record the full target package ID.
        if key in snapshots:
            continue
        snapshot = lock["snapshots"][key]
        snapshots[key] = snapshot
        package = key.partition("(")[0]
        packages[package] = lock["packages"][package]
        for field in ("dependencies", "optionalDependencies"):
            pending.extend(snapshot.get(field, {}).items())
    return {
        "lockfileVersion": lock["lockfileVersion"],
        "settings": lock["settings"],
        "importers": {".": {"dependencies": dependencies}},
        "packages": packages,
        "snapshots": snapshots,
    }


with Path(sys.argv[1]).open() as source:
    # pnpm 12 also writes a YAML document for the package manager itself.
    lock = next(doc for doc in yaml.load_all(source, Loader=yaml.CSafeLoader)
                if "applications/inbox-desktop" in doc["importers"])

dependencies = desktop_dependencies(lock["importers"])
manifest = {}
for name, pin in dependencies.items():
    version = pin["version"].partition("(")[0]
    manifest[name] = "npm:" + version if version.startswith("@") else version
    dependencies[name] = {"specifier": manifest[name], "version": pin["version"]}

Path("package.json").write_text(json.dumps({"private": True, "dependencies": manifest}))
Path("pnpm-lock.yaml").write_text(yaml.dump(desktop_lock(lock, dependencies),
                                           Dumper=yaml.CSafeDumper))
Path("pnpm-workspace.yaml").write_text(yaml.safe_dump({
    "autoInstallPeers": False, "blockExoticSubdeps": False, "nodeLinker": "hoisted",
    "minimumReleaseAge": 0,
}))
