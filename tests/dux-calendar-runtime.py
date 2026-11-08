"""Exercise the installed calendar without tools from a user's profile.

Usage: python3 tests/dux-calendar-runtime.py /path/to/bin/dcal
"""

import os
from pathlib import Path
import signal
import subprocess
import sys
import tempfile


def check_calendar(binary):
    with tempfile.TemporaryDirectory(prefix="dcal-runtime-") as directory:
        root = Path(directory)
        runtime = root / "run"
        runtime.mkdir(mode=0o700)
        env = {
            "HOME": directory,
            "XDG_CONFIG_HOME": str(root / "config"),
            "XDG_DATA_HOME": str(root / "data"),
            "XDG_CACHE_HOME": str(root / "cache"),
            "XDG_RUNTIME_DIR": str(runtime),
            "PATH": str(root / "empty-path"),
            "LANG": "C.UTF-8",
            "QT_QPA_PLATFORM": "offscreen",
            "QT_QUICK_BACKEND": "software",
            # shellapp defaults to GTK, which requires a real display.
            "QT_QPA_PLATFORMTHEME": "none",
            "QT_QPA_PLATFORMTHEME_QT6": "none",
        }
        with tempfile.TemporaryFile(mode="w+") as log:
            process = subprocess.Popen(
                [binary, "run", "--log-level", "debug"],
                env=env,
                stdout=log,
                stderr=log,
                start_new_session=True,
            )
            try:
                process.wait(timeout=8)
            except subprocess.TimeoutExpired:
                pass
            finally:
                if process.poll() is None:
                    os.killpg(process.pid, signal.SIGTERM)
                    process.wait(timeout=10)
            log.seek(0)
            output = log.read()
        assert "backend ready" in output, output
        assert "Configuration Loaded" in output, output
        assert "Process failed to start" not in output, output
        assert "UI exited: exit status" not in output, output
        print("PASS: embedded UI loads with no profile commands on PATH")


if __name__ == "__main__":
    check_calendar(str(Path(sys.argv[1]).resolve()))
