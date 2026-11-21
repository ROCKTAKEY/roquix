"""Build the plugin registry to test discovery and collision handling."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class DockerPluginsTest(unittest.TestCase):
    def build(self, scenario):
        with tempfile.TemporaryFile(mode="w+") as log:
            result = subprocess.run(
                ["guix", "build", "-L", "channel", "-f",
                 "tests/docker-cli-plugins-test.scm"],
                cwd=ROOT, env={**os.environ, "PLUGIN_TEST": scenario},
                stdout=log, stderr=subprocess.STDOUT,
            )
            log.seek(0)
            return result.returncode, log.read()

    def test_collects_plugins_from_multiple_packages(self):
        status, output = self.build("multiple")
        self.assertEqual(status, 0, output[-4000:])
        directory = Path(output.strip().splitlines()[-1])
        self.assertEqual(sorted(p.name for p in directory.iterdir()),
                         ["docker-one", "docker-two"])
        for name in ("docker-one", "docker-two"):
            self.assertTrue((directory / name).is_symlink())
            self.assertEqual((directory / name).read_text(), "fixture")

    def test_duplicate_names_fail(self):
        status, output = self.build("duplicate")
        self.assertNotEqual(status, 0)
        self.assertIn("Duplicate Docker CLI plugin", output)

    def test_missing_plugin_directory_fails(self):
        status, output = self.build("missing")
        self.assertNotEqual(status, 0)
        self.assertIn("Package provides no Docker CLI plugins", output)

    def test_empty_list_builds_empty_directory(self):
        status, output = self.build("empty")
        self.assertEqual(status, 0, output[-4000:])
        self.assertEqual(list(Path(output.strip().splitlines()[-1]).iterdir()), [])


if __name__ == "__main__":
    unittest.main()
