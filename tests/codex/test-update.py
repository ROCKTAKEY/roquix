import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[2]


class UpdateReleaseTest(unittest.TestCase):
    def test_updates_formatted_release_without_replacing_package_version(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "scripts").mkdir()
            shutil.copy(ROOT / "scripts/update-codex.sh", root / "scripts")
            package = root / "channel/roquix/packages/codex.scm"
            package.parent.mkdir(parents=True)
            package.write_text(
                '(define %codex-release-version\n  "0.160.0")\n'
                '(define-public codex\n  (package\n'
                '    (version (string-append %codex-release-version "-roquix"))\n'
                '    (source (origin (sha256 (base32 "old-hash"))))))\n'
            )
            # Network and store access are outside this updater contract.
            commands = root / "bin"
            commands.mkdir()
            for name, body in {
                "git": 'for target do :; done\nmkdir -p "$target/codex-rs"\ntouch "$target/codex-rs/Cargo.lock"',
                "guix": 'if [ "$1" = hash ]; then echo new-hash; fi',
            }.items():
                command = commands / name
                command.write_text("#!/bin/sh\nset -eu\n" + body + "\n")
                command.chmod(0o755)
            result = subprocess.run(
                ["bash", str(root / "scripts/update-codex.sh"), "rust-v0.163.0"],
                env={**os.environ, "PATH": str(commands) + os.pathsep + os.environ["PATH"]},
                capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            updated = package.read_text()
            self.assertIn('"0.163.0"', updated)
            self.assertNotIn('"0.160.0"', updated)
            self.assertIn('(base32 "new-hash")', updated)
            self.assertIn('(version (string-append %codex-release-version "-roquix"))', updated)


if __name__ == "__main__":
    unittest.main()
