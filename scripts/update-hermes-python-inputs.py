"""Generate source inputs from sdists verified against the upstream uv.lock."""
import argparse
import email
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tarfile
import tomllib
import urllib.request

LICENSE_ALIASES = {
    'MIT License': 'MIT', 'MIT license': 'MIT',
    'Apache License, Version 2.0': 'Apache-2.0', 'Apache 2.0': 'Apache-2.0',
    'License :: OSI Approved :: BSD License': 'BSD-3-Clause',
    'License :: OSI Approved :: MIT License': 'MIT',
    'License :: OSI Approved :: Mozilla Public License 2.0 (MPL 2.0)': 'MPL-2.0',
    'Dual License': 'Apache-2.0 OR BSD-3-Clause',
}


def fetch_sources(lock_path, requirements, destination):
    from packaging.markers import default_environment
    from packaging.requirements import Requirement

    environment = default_environment()
    environment.update(python_version='3.14', python_full_version='3.14.9',
                       implementation_name='cpython', platform_python_implementation='CPython',
                       sys_platform='linux', platform_system='Linux', platform_machine='x86_64')
    locked = {(p['name'], p['version']): p for p in tomllib.loads(lock_path.read_text())['package']}
    destination.mkdir(parents=True, exist_ok=True)
    for line in requirements.read_text().splitlines():
        if not line or line[0].isspace() or line.startswith('#'):
            continue
        requirement = Requirement(line.rstrip(' \\'))
        if requirement.marker and not requirement.marker.evaluate(environment):
            continue
        pins = list(requirement.specifier)
        if len(pins) != 1 or pins[0].operator != '==':
            raise ValueError(f'expected an exact upstream pin: {line}')
        name = re.sub(r'[-_.]+', '-', requirement.name).lower()
        artifact = locked[name, pins[0].version]['sdist']
        target = destination / artifact['url'].rsplit('/', 1)[1]
        if not target.exists():
            urllib.request.urlretrieve(artifact['url'], target)
        if 'sha256:' + hashlib.sha256(target.read_bytes()).hexdigest() != artifact['hash']:
            raise ValueError(f'source differs from upstream lock: {target.name}')


def generate(lock_path, sources, version):
    locked = {(p['name'], p['version']): p for p in tomllib.loads(lock_path.read_text())['package']}
    rows = []
    for path in sorted(sources.glob('*.tar.gz')):
        with tarfile.open(path) as archive:
            metadata = next(m for m in archive if m.name.count('/') == 1 and m.name.endswith('/PKG-INFO'))
            message = email.message_from_bytes(archive.extractfile(metadata).read())
            name = re.sub(r'[-_.]+', '-', message['Name']).lower()
            release = message['Version']
            artifact = locked[name, release]['sdist']
            if 'sha256:' + hashlib.sha256(path.read_bytes()).hexdigest() != artifact['hash']:
                raise ValueError(f'source differs from upstream lock: {path.name}')
            cargo = next((m for m in archive.getmembers() if m.name.endswith('/Cargo.lock')), None)
            group = 'hermes-' + path.name.removesuffix('.tar.gz') if cargo else None
            license_id = message.get('License-Expression') or message.get('License') or ';'.join(
                x for x in message.get_all('Classifier', []) if x.startswith('License ::'))
            license_id = LICENSE_ALIASES.get(license_id, license_id)
            if not license_id:
                license_id = {'ptyprocess': 'ISC', 'resvg-py': 'MIT', 'socksio': 'MIT'}[name]
        base32 = subprocess.check_output(['guix', 'hash', str(path)], text=True).strip()
        values = (name, release, artifact['url'], base32, group, license_id)
        rows.append('    (' + ' '.join('#f' if x is None else json.dumps(x) for x in values) + ')')
    if not rows:
        raise ValueError('source directory is empty')
    return f''';; Generated from Hermes v{version} uv.lock; source distributions only.
(define-module (roquix packages hermes python-inputs)
  #:export (hermes-python-sources))

(define hermes-python-sources
  '(\n''' + '\n'.join(rows) + '\n  ))\n'


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('lock', type=Path)
    parser.add_argument('sources', type=Path)
    parser.add_argument('version')
    parser.add_argument('output', type=Path)
    parser.add_argument('--requirements', type=Path, help='fetch sdists selected by a uv requirements export')
    args = parser.parse_args()
    if args.requirements:
        fetch_sources(args.lock, args.requirements, args.sources)
    args.output.write_text(generate(args.lock, args.sources, args.version))
