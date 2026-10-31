"""Expose Python build-backend metadata and invoke its Python API."""
import importlib
import json
from pathlib import Path
import sys
import tomllib

project = tomllib.loads(Path("pyproject.toml").read_text()) if Path("pyproject.toml").exists() else {}
build = project.get("build-system", {"build-backend": "setuptools.build_meta:__legacy__"})
if sys.argv[1] == "describe":
    print(json.dumps(build))
elif sys.argv[1] == "build":
    for path in reversed(build.get("backend-path", [])):
        sys.path.insert(0, str(Path(path).resolve()))
    backend = build.get("build-backend", "setuptools.build_meta:__legacy__")
    module, _, attribute = backend.partition(":")
    api = importlib.import_module(module)
    if attribute:
        api = getattr(api, attribute)
    api.build_wheel(sys.argv[2])
else:
    raise ValueError(f"unsupported backend operation: {sys.argv[1]}")
