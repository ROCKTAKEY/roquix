"""Check the installed CLI and the gateway contract used by Desktop offline."""

import json
import os
from pathlib import Path
import re
import signal
import subprocess
import sys
import tempfile
import time
import urllib.request


command, version = sys.argv[1:]
with tempfile.TemporaryDirectory(prefix="hermes-check-") as home:
    env = {"HOME": home, "HERMES_HOME": home + "/.hermes", "PATH": os.environ["PATH"]}
    result = subprocess.run([command, "--version"], env=env, check=True,
                            capture_output=True, text=True, timeout=20)
    assert f"v{version}" in result.stdout, result.stdout
    assert "Install directory: /gnu/store/" in result.stdout, result.stdout
    log_path = Path(home) / "gateway.log"
    with log_path.open("w") as log:
        process = subprocess.Popen([command, "serve", "--port", "0"], env=env,
                                   stdout=log, stderr=log, start_new_session=True)
        try:
            deadline = time.monotonic() + 30
            while time.monotonic() < deadline:
                output = log_path.read_text()
                assert process.poll() is None, output
                ready = re.search(r"HERMES_BACKEND_READY port=(\d+)", output)
                if ready:
                    opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
                    with opener.open(f"http://127.0.0.1:{ready[1]}/api/health", timeout=5) as response:
                        health = json.load(response)
                    assert health["ok"] is True and health["version"] == version, health
                    print(f"Hermes {version}: installed CLI and gateway ready")
                    break
                time.sleep(0.1)
            else:
                raise AssertionError(log_path.read_text())
        finally:
            if process.poll() is None:
                os.killpg(process.pid, signal.SIGTERM)
            try:
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                os.killpg(process.pid, signal.SIGKILL)
                process.wait()
