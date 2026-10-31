"""Downloaded native code must be removed before the offline compilation."""
import importlib.util
from pathlib import Path
import tempfile
import tarfile
import io
import unittest

class SourceLock(unittest.TestCase):
    def test_rejects_source_not_matching_lock(self):
        location = Path(__file__).resolve().parents[1] / 'scripts/update-hermes-python-inputs.py'
        spec = importlib.util.spec_from_file_location('source_inputs', location)
        generator = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(generator)
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            archive = root / 'example-1.0.tar.gz'
            metadata = b'Name: example\nVersion: 1.0\nLicense-Expression: MIT\n'
            with tarfile.open(archive, 'w:gz') as tar:
                entry = tarfile.TarInfo('example-1.0/PKG-INFO')
                entry.size = len(metadata)
                tar.addfile(entry, io.BytesIO(metadata))
            lock = root / 'uv.lock'
            lock.write_text('[[package]]\nname = "example"\nversion = "1.0"\n'
                            'sdist = {url = "https://example.invalid/example-1.0.tar.gz", '
                            'hash = "sha256:' + '0' * 64 + '"}\n')
            with self.assertRaisesRegex(ValueError, 'source differs from upstream lock'):
                generator.generate(lock, root, '1.0')

if __name__ == '__main__':
    unittest.main()
