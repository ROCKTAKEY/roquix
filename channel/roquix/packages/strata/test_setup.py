import argparse
import importlib.util
import io
import json
import os
import sys
import shutil
import subprocess
import tempfile
import unittest
from contextlib import ExitStack, redirect_stderr, redirect_stdout
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
        (self.package / "engine/strata-dsv41").touch()
        (self.package / "engine/BUILD.json").write_text(
            json.dumps({"backend": "hip", "archs": ["gfx1101"],
                        "lib_dirs": ["/store/rocm/lib"]})
        )
        (self.package / "CMakeLists.txt").touch()
        (self.package / "requirements.txt").touch()
        shutil.copy2(SOURCE / "setup.py", self.package / "setup.py")
        shutil.copytree(SOURCE / "strata_control", self.package / "strata_control")
        self.addCleanup(setattr, sys, "path", sys.path[:])
        sys.path.insert(0, str(self.package))
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
        for arguments in (["--build"], ["--backend", "cuda"], ["--prebuilt", "url"],
                          ["--dsv41-package", "engine.tar.gz"]):
            with self.subTest(arguments=arguments):
                self._assert_request_rejected(arguments)

    def test_package_requires_the_deepseek_engine_before_preparing_state(self):
        (self.package / "engine/strata-dsv41").unlink()
        with self.assertRaisesRegex(ValueError, "strata-dsv41"):
            self.adapter.PackagedStrata.load(self.package)

    def test_refresh_keeps_deepseek_on_its_own_engine(self):
        prepared = self.adapter.PackagedStrata.load(self.package).prepare(self.root / "state")
        self.adapter.ROOT = prepared.state
        path = prepared.state / "strata-deepseek-v4.1-flash-ist-das-2.00bpw.json"
        config = {"exe": "/old/strata-dsv41", "arch": "deepseek41",
                  "args": ["--pack", "/models/deepseek"], "tokenizer": "/models/tokenizer"}
        path.write_text(json.dumps(config))
        self.adapter.update_installed_engine("https://example.invalid/engine")
        self.assertEqual({**config, "exe": str(prepared.state / "engine/strata-dsv41"),
                          "lib_dirs": ["/store/rocm/lib"]}, json.loads(path.read_text()))

    def test_deepseek_setup_uses_packaged_engine_and_libraries(self):
        prepared = self.adapter.PackagedStrata.load(self.package).prepare(self.root / "state")
        upstream = self.adapter
        upstream.ROOT = prepared.state
        arguments = argparse.Namespace(
            model="IST-DAS-2.00bpw", models_dir=str(self.root / "models"),
            gguf_dir=None, context=8192, gpu=None, gpus=None, yes=True,
            vision="none", rope_scaling=None, rope_scale=None, kv=None,
            resident_budget_gib=None, low_ram="auto", data_dir=str(self.root / "models"),
            host=None, api_key=None, browser=None, no_start=True,
        )
        gpu = {"index": 0, "name": "RX 7800 XT", "arch": "gfx1101",
               "vram_gb": 16.0, "vendor": "amd"}
        with ExitStack() as stack:
            stack.enter_context(redirect_stdout(io.StringIO()))
            stack.enter_context(patch.dict(os.environ, {"STRATA_DSV41_EXE": "/unmanaged/engine"}))
            mocks = {}
            for name, result in {
                "free_gb": 900.0, "download": None, "verify_sha256": None,
                "run": None, "dsv41_pack_info": (True, "all present"),
                "dsv41_smoke": (True, "Paris"), "write_setup_config": None,
                "write_run_script": prepared.state / "run.sh",
            }.items():
                mocks[name] = stack.enter_context(patch.object(upstream, name, return_value=result))
            for name in ("get_dsv41_engine", "upgrade_dsv41_engine", "github_reachable"):
                stack.enter_context(patch.object(upstream, name, side_effect=AssertionError(name)))
            result = upstream.install_dsv41(arguments, "deepseek41", gpu, True, [], 13,
                                            [], 18098, 64.0, None, [gpu])
        self.assertEqual(0, result)
        config = mocks["write_setup_config"].call_args.args[1]
        self.assertEqual(str(prepared.state / "engine/strata-dsv41"), config["exe"])
        self.assertEqual(["/store/rocm/lib"], config["lib_dirs"])
        self.assertEqual("deepseek41", config["arch"])
        self.assertEqual(["/store/rocm/lib"], mocks["dsv41_smoke"].call_args.args[2])

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
