"""Assemble source-built Guix dependencies for the upstream source launcher."""
from pathlib import Path
import sys

site = Path(sys.argv[1])
site.mkdir(parents=True, exist_ok=True)
for package in sys.argv[2:]:
    roots = list(Path(package).glob('lib/python*/site-packages'))
    if not roots:
        raise ValueError(f'no installed Python modules in {package}')
    for root in roots:
        for source in root.rglob('*'):
            relative = source.relative_to(root)
            if '__pycache__' in relative.parts:
                continue
            target = site / relative
            if source.is_dir():
                target.mkdir(exist_ok=True)
            elif target.exists():
                if target.read_bytes() != source.read_bytes():
                    raise ValueError(f'conflicting Python dependency: {relative}')
            else:
                target.symlink_to(source)
