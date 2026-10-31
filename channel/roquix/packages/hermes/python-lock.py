"""Read uv's lock and requirement markers using Python's standard ecosystem APIs."""
import json
from pathlib import Path
import sys
import tomllib
from packaging.markers import default_environment
from packaging.requirements import Requirement
from packaging.utils import canonicalize_name

lock = tomllib.loads(Path(sys.argv[1]).read_text())
locked = {(p['name'], p['version']): p for p in lock['package']}
environment = default_environment()
environment.update(python_version='3.14', python_full_version='3.14.9',
                   implementation_name='cpython', platform_python_implementation='CPython',
                   sys_platform='linux', platform_system='Linux', platform_machine='x86_64',
                   extra='')
pins = []
for line in Path(sys.argv[2]).read_text().splitlines():
    if not line or line[0].isspace() or line.startswith('#'):
        continue
    requirement = Requirement(line.rstrip(' \\'))
    if requirement.marker and not requirement.marker.evaluate(environment):
        continue
    specs = list(requirement.specifier)
    if len(specs) != 1 or specs[0].operator != '==':
        raise ValueError(f'expected an exact upstream pin: {line}')
    name, version = canonicalize_name(requirement.name), specs[0].version
    sdist = locked[name, version]['sdist']
    algorithm, digest = sdist['hash'].split(':', 1)
    if algorithm != 'sha256':
        raise ValueError(f'unsupported source hash: {sdist["hash"]}')
    pins.append(dict(name=name, version=version, sha256=digest))
print(json.dumps(pins))
