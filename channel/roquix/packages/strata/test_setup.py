import importlib.util
import io
import json
import os
import sys
import shutil
import subprocess
import tempfile
import unittest
from contextlib import redirect_stderr
from pathlib import Path
from unittest.mock import patch

SOURCE = Path(os.environ['STRATA_SOURCE_DIR'])


class SetupTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.package = self.root / "store/strata"
        for name in ("engine", "serve", "tools", "data", "third_party/llama.cpp"):
            (self.package / name).mkdir(parents=True)
        (self.package / "engine/strata").touch()
        (self.package / "engine/BUILD.json").write_text(
            json.dumps({"backend": "hip", "archs": ["gfx1101"],
                        "lib_dirs": ["/store/rocm/lib"]})
        )
        (self.package / "CMakeLists.txt").touch()
        (self.package / "requirements.txt").touch()
        shutil.copy2(SOURCE / "setup.py", self.package / "setup.py")
        spec = importlib.util.spec_from_file_location("strata_setup", self.package / "setup.py")
        self.adapter = importlib.util.module_from_spec(spec)
        sys.modules[spec.name] = self.adapter
        spec.loader.exec_module(self.adapter)


    def upstream_setup(self):
        return self.adapter

    def test_setup_script_runs_directly_without_an_adapter(self):
        state = self.root / "cli-state"
        result = subprocess.run(
            [sys.executable, str(self.package / "setup.py"), "--help"],
            env={**os.environ, "STRATA_STATE_DIR": str(state),
                 "XDG_CONFIG_HOME": str(self.root / "config")},
            capture_output=True, text=True,
        )
        self.assertEqual(0, result.returncode, result.stderr)
        self.assertIn("--model", result.stdout)
        self.assertEqual(self.package / "engine", (state / "engine").resolve())

    def test_entrypoint_prepares_state_and_defaults_to_packaged_hip(self):
        state = self.root / "state"
        with patch.dict(os.environ, {"STRATA_STATE_DIR": str(state)}), \
                patch.object(self.adapter, "load_settings", return_value={}):
            arguments = self.adapter.prepare_guix_setup(["--check"])
        self.assertEqual(state, self.adapter.ROOT)
        self.assertEqual(self.package / "engine", (state / "engine").resolve())
        self.assertEqual(["--backend", "hip", "--data-dir", str(state / "models-data"),
                          "--vision", "none", "--check"], arguments)

    def test_engine_support_comes_from_the_packaged_build_metadata(self):
        manifest = self.package / "engine/BUILD.json"
        metadata = json.loads(manifest.read_text())
        metadata["archs"] = ["gfx1151"]
        manifest.write_text(json.dumps(metadata))
        installed = self.adapter.PackagedStrata.load(self.package)
        self.assertEqual(
            self.package / "engine", installed.engine_for({"arch": "gfx1151"}, "none")
        )

    def test_package_requires_runtime_libraries_without_cuda_fallback(self):
        manifest = self.package / "engine/BUILD.json"
        metadata = json.loads(manifest.read_text())
        for libraries in (None, [], [""]):
            with self.subTest(libraries=libraries):
                metadata["lib_dirs"] = libraries
                manifest.write_text(json.dumps(metadata))
                with self.assertRaises(ValueError):
                    self.adapter.PackagedStrata.load(self.package)

    def test_refresh_uses_upstream_model_selection_and_atomic_writer(self):
        prepared = self.adapter.PackagedStrata.load(self.package).prepare(
            self.root / "user-state"
        )
        config = prepared.state / "strata-iq2_xs.json"
        config.write_text('{"exe": "/old/strata", "args": [], "custom": true}')
        others = {
            "strata-iq2_xs.shared-settings.json": '{"exe": "user setting", "args": []}',
            "strata-broken.json": '{"exe":',
            "strata-notes.json": '{"exe": "note"}',
        }
        for name, content in others.items():
            (prepared.state / name).write_text(content)
        upstream = self.upstream_setup()
        upstream.ROOT = prepared.state
        with patch.object(upstream, "write_config", wraps=upstream.write_config) as write:
            upstream.update_installed_engine("https://example.invalid/engine")
        write.assert_called_once_with(config, {
            "exe": str(prepared.state / "engine/strata"), "args": [],
            "custom": True, "lib_dirs": ["/store/rocm/lib"],
        })
        for name, content in others.items():
            self.assertEqual(content, (prepared.state / name).read_text())

    def test_setup_uses_packaged_dependencies_and_a_writable_state_directory(self):
        installed = self.adapter.PackagedStrata.load(self.package)
        state = self.root / "user-state"
        state.mkdir()
        config = state / "strata-iq2_xs.json"
        config.write_text('{"user": "configuration"}')
        prepared = installed.prepare(state)
        events = []
        upstream = self.upstream_setup()
        upstream.ok = events.append
        upstream.ROOT = prepared.state
        upstream.pip_install(["numpy"], "Python packages")
        upstream.update_installed_engine("https://example.invalid/engine", toolkit=13)
        self.assertEqual(state, upstream.ROOT)
        self.assertEqual('{"user": "configuration"}', config.read_text())
        self.assertEqual(self.package / "tools", (state / "tools").resolve())
        engine = upstream.build_engine_hip({"arch": "gfx1101"}, None, "none")
        self.assertEqual(state / "engine", engine)
        self.assertEqual(self.package / "engine", engine.resolve())
        self.assertEqual(
            self.package / "third_party/llama.cpp", upstream.get_llama_cpp()
        )
        self.assertEqual(["Python packages supplied by Guix"], events)

    def test_package_updates_refresh_engine_paths_without_changing_model_data(self):
        installed = self.adapter.PackagedStrata.load(self.package)
        prepared = installed.prepare(self.root / "user-state")
        config = prepared.state / "strata-iq2_xs.json"
        config.write_text(
            json.dumps(
                {
                    "exe": "/old-store/strata",
                    "lib_dirs": ["/old-store/lib"],
                    "args": ["--pack", "/user/models/pack"],
                    "tokenizer": "/user/models/tokenizer",
                }
            )
        )
        upstream = self.upstream_setup()
        upstream.ROOT = prepared.state
        upstream.update_installed_engine("https://example.invalid/engine")
        updated = json.loads(config.read_text())
        self.assertEqual(str(prepared.state / "engine/strata"), updated["exe"])
        self.assertEqual(["/store/rocm/lib"], updated["lib_dirs"])
        self.assertEqual(["--pack", "/user/models/pack"], updated["args"])
        self.assertEqual("/user/models/tokenizer", updated["tokenizer"])

    def test_setup_rejects_unmanaged_engine_installation_options(self):
        for arguments in (["--build"], ["--backend", "cuda"], ["--prebuilt", "url"]):
            with self.subTest(arguments=arguments):
                self._assert_request_rejected(arguments)

    def test_setup_defaults_to_the_packaged_text_support(self):
        request = self.adapter.SetupRequest.parse(["--model", "IQ2_XS"])
        self.assertEqual(("--vision", "none", "--model", "IQ2_XS"), request.arguments)
        self._assert_request_rejected(["--vision", "gpu"])

    def _assert_request_rejected(self, arguments):
        output = io.StringIO()
        with redirect_stderr(output), self.assertRaises(SystemExit) as caught:
            self.adapter.SetupRequest.parse(arguments)
        self.assertEqual(2, caught.exception.code)
        self.assertIn("strata-setup: error:", output.getvalue())

    def test_engine_rejects_a_gpu_not_in_the_compiled_architectures(self):
        installed = self.adapter.PackagedStrata.load(self.package)
        with self.assertRaisesRegex(ValueError, "gfx1201"):
            installed.engine_for({"arch": "gfx1201"}, "none")

    def test_engine_rejects_missing_optional_vision_support(self):
        installed = self.adapter.PackagedStrata.load(self.package)
        with self.assertRaisesRegex(ValueError, "vision"):
            installed.engine_for({"arch": "gfx1101"}, "cpu")

    def test_preparation_preserves_conflicting_user_files(self):
        installed = self.adapter.PackagedStrata.load(self.package)
        state = self.root / "user-state"
        state.mkdir()
        (state / "tools").write_text("user file")
        with self.assertRaisesRegex(ValueError, "tools"):
            installed.prepare(state)
        self.assertEqual("user file", (state / "tools").read_text())

    def test_package_metadata_is_parsed_before_creating_user_state(self):
        (self.package / "engine/BUILD.json").write_text(
            json.dumps({"backend": "cuda", "archs": ["gfx1101"]})
        )
        with self.assertRaisesRegex(ValueError, "HIP"):
            self.adapter.PackagedStrata.load(self.package)


if __name__ == "__main__":
    unittest.main()
