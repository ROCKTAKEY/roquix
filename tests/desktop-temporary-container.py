"""Run with the temporary fixture's PROBE, WESTON, and configured disk BASE.

Build tests/fixtures/desktop-temporary-package.scm with
ROQUIX_TEST_TEMPORARY_DIRECTORY set to an existing local disk directory.
"""

import os
from pathlib import Path
import selectors
import signal
import subprocess
import sys
import tempfile
import time
import unittest

PROBE, WESTON, BASE = (str(Path(sys.argv.pop(1)).resolve()) for _ in range(3))


class TemporaryContainerTests(unittest.TestCase):
    @staticmethod
    def stop(process):
        if process.poll() is None:
            os.killpg(process.pid, signal.SIGTERM)
        process.wait(timeout=10)
        if process.stdout is not None:
            process.stdout.close()

    def test_disk_mount_is_private_and_cleaned_on_exit_and_interrupt(self):
        with tempfile.TemporaryDirectory(dir=BASE) as temporary:
            root = Path(temporary)
            environment = dict(os.environ, XDG_RUNTIME_DIR=str(root),
                               XDG_STATE_HOME=str(root / "state"),
                               WAYLAND_DISPLAY="wayland-test")
            environment.pop("PULSE_SERVER", None)
            compositor = subprocess.Popen(
                [WESTON, "--backend=headless", "--renderer=pixman", "--shell=desktop",
                 "--socket=wayland-test", "--no-config", "--idle-time=0"],
                env=environment, stdout=subprocess.DEVNULL, start_new_session=True,
            )
            self.addCleanup(self.stop, compositor)
            deadline = time.monotonic() + 15
            while not (root / "wayland-test").exists():
                self.assertIsNone(compositor.poll())
                self.assertLess(time.monotonic(), deadline)
                time.sleep(.05)

            boot = Path("/proc/sys/kernel/random/boot_id").read_text().strip()
            storage = Path(BASE) / f"roquix-tmp-{os.getuid()}" / boot
            before = set(storage.glob("run-*"))

            def launch():
                process = subprocess.Popen(
                    [PROBE, "--temporary-probe"], env=environment,
                    stdout=subprocess.PIPE, text=True, start_new_session=True,
                )
                self.addCleanup(self.stop, process)
                with selectors.DefaultSelector() as selector:
                    selector.register(process.stdout, selectors.EVENT_READ)
                    self.assertTrue(selector.select(20), "temporary probe did not start")
                self.assertEqual(process.stdout.readline(), "temporary-ready\n")
                return process

            first = launch()
            first_directories = set(storage.glob("run-*")) - before
            self.assertEqual(len(first_directories), 1)
            first_directory = first_directories.pop()
            self.assertTrue((first_directory / "temporary-token").is_file())
            second = launch()
            second_directories = set(storage.glob("run-*")) - before - {first_directory}
            self.assertEqual(len(second_directories), 1)
            second_directory = second_directories.pop()
            self.stop(first)
            self.assertEqual(first.returncode, 128 + signal.SIGTERM)
            self.assertFalse(first_directory.exists())
            self.assertTrue((second_directory / "temporary-token").is_file())
            self.stop(second)
            self.assertEqual(set(storage.glob("run-*")), before)

            result = subprocess.run([PROBE, "--temporary-probe-once"], env=environment,
                                    capture_output=True, text=True, timeout=20)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn("temporary-ready", result.stdout)
            self.assertEqual(set(storage.glob("run-*")), before)

            environment.pop("WAYLAND_DISPLAY")
            failed = subprocess.run([PROBE, "--temporary-probe-once"], env=environment,
                                    capture_output=True, text=True, timeout=20)
            self.assertNotEqual(failed.returncode, 0)
            self.assertIn("Wayland display is required", failed.stderr)
            self.assertEqual(set(storage.glob("run-*")), before)


if __name__ == "__main__":
    unittest.main()
