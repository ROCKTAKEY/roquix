"""The lock bridge selects the exact Linux/CPython requirements for the importer."""
from pathlib import Path
import json
import subprocess
import sys
import tempfile
import unittest

BRIDGE = Path(__file__).resolve().parents[1] / 'channel/roquix/packages/hermes/python-lock.py'

class SourceLock(unittest.TestCase):
    def test_selects_locked_target_versions_and_source_hashes(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            lock = root / 'uv.lock'
            lock.write_text('[[package]]\nname = "example"\nversion = "1.0"\n'
                            'sdist = {hash = "sha256:' + '0' * 64 + '"}\n')
            requirements = root / 'requirements.txt'
            requirements.write_text('example==1.0; python_version >= "3.14" \\\n'
                                    '    --hash=sha256:ignored-wheel-hash\n'
                                    'windows-only==2.0; sys_platform == "win32"\n')
            result = subprocess.check_output([sys.executable, str(BRIDGE), str(lock), str(requirements)], text=True)
            self.assertEqual(json.loads(result), [dict(name='example', version='1.0', sha256='0' * 64)])

if __name__ == '__main__':
    unittest.main()
