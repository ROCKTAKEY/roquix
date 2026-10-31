"""Generate Guix origins from a wheel download verified against upstream uv.lock."""

import argparse
import hashlib
from pathlib import Path
import subprocess
import tomllib


def generate(lock_path, wheels, version):
    lock = tomllib.loads(lock_path.read_text())
    artifacts = {}
    for package in lock["package"]:
        for wheel in package.get("wheels", []):
            name = wheel["url"].rsplit("/", 1)[1]
            if name in artifacts and artifacts[name] != wheel:
                raise ValueError(f"ambiguous locked wheel: {name}")
            artifacts[name] = wheel
    origins = []
    for path in sorted(wheels.glob("*.whl")):
        artifact = artifacts[path.name]
        digest = "sha256:" + hashlib.sha256(path.read_bytes()).hexdigest()
        if artifact["hash"] != digest:
            raise ValueError(f"wheel differs from upstream lock: {path.name}")
        base32 = subprocess.check_output(["guix", "hash", str(path)], text=True).strip()
        origins.append(f'''   (list "{path.name}"
         (origin
           (method url-fetch)
           (uri "{artifact['url']}")
           (sha256 (base32 "{base32}"))))''')
    if not origins:
        raise ValueError("wheel directory is empty")
    return f""";; Generated from Hermes v{version} uv.lock for CPython 3.14 on x86_64-linux.
(define-module (roquix packages hermes-wheel-inputs)
  #:use-module (guix packages)
  #:use-module (guix download))

(define-public hermes-wheel-inputs
  (list
""" + "\n".join(origins) + "\n   ))\n"


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("lock", type=Path)
    parser.add_argument("wheels", type=Path)
    parser.add_argument("version")
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    args.output.write_text(generate(args.lock, args.wheels, args.version))
