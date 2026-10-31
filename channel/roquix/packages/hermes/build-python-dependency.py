"""Build an upstream source distribution with Guix-provided build tools."""

import importlib
import os
from pathlib import Path
import subprocess
import sys
import tomllib
import zipfile

out = Path(sys.argv[1])
project = tomllib.loads(Path('pyproject.toml').read_text()) if Path('pyproject.toml').exists() else {}
build = project.get('build-system', {'build-backend': 'setuptools.build_meta:__legacy__'})
backend = build.get('build-backend', 'setuptools.build_meta:__legacy__')
dist = Path.cwd() / 'dist'
dist.mkdir(exist_ok=True)
if backend == 'maturin':
    subprocess.run(['maturin', 'build', '--offline', '--release', '--compatibility', 'linux', '--interpreter',
                    sys.executable, '--out', str(dist)], check=True)
else:
    for path in reversed(build.get('backend-path', [])):
        sys.path.insert(0, str(Path(path).resolve()))
    module, _, attribute = backend.partition(':')
    api = importlib.import_module(module)
    if attribute:
        api = getattr(api, attribute)
    api.build_wheel(str(dist))
wheels = list(dist.glob('*.whl'))
if len(wheels) != 1:
    raise RuntimeError(f'expected one source-built wheel, found {wheels}')
site = out / 'lib/python3.14/site-packages'
site.mkdir(parents=True)
with zipfile.ZipFile(wheels[0]) as archive:
    for entry in archive.infolist():
        path = Path(entry.filename)
        if path.is_absolute() or '..' in path.parts:
            raise ValueError(f'unsafe wheel entry: {path}')
        if path.parts[0].endswith('.data'):
            if path.parts[1] not in ('purelib', 'platlib'):
                continue
            entry.filename = str(Path(*path.parts[2:]))
        archive.extract(entry, site)
