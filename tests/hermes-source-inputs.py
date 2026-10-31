"""Downloaded native code must be removed before the offline compilation."""
import base64
import importlib.util
from pathlib import Path
import tempfile
import tarfile
import io
import unittest

spec = importlib.util.spec_from_file_location('sanitize', Path(__file__).resolve().parents[1] /
    'channel/roquix/packages/hermes/sanitize-node-sources.py')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

class SourceInputs(unittest.TestCase):
    def test_removes_platform_code_and_preserves_sources(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name, content in {'linux.node': b'\x7fELFtest', 'win.exe': b'MZtest',
                                  'mac.node': b'\xcf\xfa\xed\xfetest',
                                  'codec.wasm': b'\0asmtest',
                                  'source.js': b'export const value = 1;'}.items():
                (root / name).write_bytes(content)
            module.sanitize(root)
            self.assertEqual([p.name for p in root.iterdir()], ['source.js'])

    def test_rejects_unclassified_embedded_wasm(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            payload = base64.b64encode(b'\0asm' + bytes(32)).decode()
            (root / 'unknown.js').write_text(f'const wasm = "{payload}";')
            with self.assertRaisesRegex(ValueError, 'unclassified embedded WASM'):
                module.sanitize(root)

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
