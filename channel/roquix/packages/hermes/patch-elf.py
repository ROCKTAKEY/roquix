"""Attach Guix loaders to the pinned Linux runtime and dependency artifacts."""

import os
from pathlib import Path
import subprocess
import sys


def patch_tree(root, interpreter, libraries):
    for path in Path(root).rglob("*"):
        if not path.is_file() or path.is_symlink():
            continue
        with path.open("rb") as stream:
            header = stream.read(20)
        if header[:4] != b"\x7fELF" or header[18:20] != b"\x3e\x00":
            continue
        result = subprocess.run(["patchelf", "--print-rpath", path], capture_output=True, text=True)
        if result.returncode:
            continue  # Static helpers have no dynamic loader or search path.
        os.chmod(path, path.stat().st_mode | 0o200)
        existing = [entry for entry in result.stdout.strip().split(":")
                    if entry and not entry.startswith("/tools/")]
        needed = subprocess.check_output(["patchelf", "--print-needed", path], text=True)
        for dependency in needed.splitlines():
            if dependency.startswith("$ORIGIN/"):
                resolved = path.parent / dependency.removeprefix("$ORIGIN/")
                if not resolved.is_file():
                    raise FileNotFoundError(resolved)
                subprocess.run(["patchelf", "--replace-needed", dependency, resolved.name, path], check=True)
                existing.append(str(Path(dependency).parent))
        rpath = ":".join([*existing, *libraries])
        subprocess.run(["patchelf", "--set-rpath", rpath, path], check=True)
        loader = subprocess.run(["patchelf", "--print-interpreter", path], capture_output=True)
        if loader.returncode == 0:
            subprocess.run(["patchelf", "--set-interpreter", interpreter, path], check=True)


if __name__ == "__main__":
    patch_tree(sys.argv[1], sys.argv[2], sys.argv[3:])
