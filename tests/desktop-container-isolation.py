"""Run with the built probe executable and a Guix dbus package's bin directory."""

import os
from pathlib import Path
import selectors
import signal
import socket
import subprocess
import sys
import tempfile
import unittest

PROBE = str(Path(sys.argv.pop(1)).resolve())
DBUS = Path(sys.argv.pop(1)).resolve()


class DesktopIsolationTests(unittest.TestCase):
    @staticmethod
    def stop(process):
        if process.poll() is None:
            os.killpg(process.pid, signal.SIGTERM)
        process.wait(timeout=5)
        if process.stdout is not None:
            process.stdout.close()

    def test_only_private_state_and_display_are_accessible(self):
        with tempfile.TemporaryDirectory(prefix="roquix-isolation-") as temporary:
            root = Path(temporary)
            runtime = root / "runtime"
            runtime.mkdir(mode=0o700)
            state = root / "state"
            state.mkdir(mode=0o700)
            cwd = root / "cwd"
            cwd.mkdir()
            secret = root / "host-secret"
            secret.write_text("host-only")
            cwd_secret = cwd / "host-working-directory-secret"
            cwd_secret.write_text("host-only")
            with socket.socket(socket.AF_UNIX) as wayland, \
                    socket.socket(socket.AF_UNIX) as host_service, \
                    socket.socket(socket.AF_INET) as host_listener:
                wayland.bind(str(runtime / "wayland-test"))
                host_service.bind(str(runtime / "host-service"))
                host_listener.bind(("127.0.0.1", 0))
                host_listener.listen()
                port = host_listener.getsockname()[1]
                with socket.create_connection(("127.0.0.1", port), timeout=1):
                    pass
                environment = dict(
                    os.environ,
                    XDG_RUNTIME_DIR=str(runtime),
                    XDG_STATE_HOME=str(state),
                    WAYLAND_DISPLAY="wayland-test",
                    DISPLAY=":123",
                    XAUTHORITY=str(secret),
                    PULSE_SERVER="unix:" + str(runtime / "host-service"),
                    XDG_CONFIG_HOME=str(root / "host-config"),
                    XDG_DATA_HOME=str(root / "host-data"),
                    XDG_CACHE_HOME=str(root / "host-cache"),
                    SSH_AUTH_SOCK=str(runtime / "host-service"),
                )
                bus = subprocess.Popen(
                    [str(DBUS / "dbus-daemon"), "--session", "--nofork",
                     "--print-address=1", "--address=unix:path=" + str(runtime / "bus")],
                    stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
                    text=True, start_new_session=True,
                )
                self.addCleanup(self.stop, bus)
                with selectors.DefaultSelector() as selector:
                    selector.register(bus.stdout, selectors.EVENT_READ)
                    self.assertTrue(selector.select(5), "temporary D-Bus did not start")
                environment["DBUS_SESSION_BUS_ADDRESS"] = bus.stdout.readline().strip()
                service = subprocess.Popen(
                    [str(DBUS / "dbus-test-tool"), "echo", "--name=org.freedesktop.secrets"],
                    env=environment, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                    start_new_session=True,
                )
                self.addCleanup(self.stop, service)
                for _ in range(100):
                    control = subprocess.run(
                        [str(DBUS / "dbus-send"), "--session", "--print-reply",
                         "--dest=org.freedesktop.secrets", "/org/freedesktop/secrets",
                         "org.freedesktop.DBus.Peer.Ping"],
                        env=environment, capture_output=True, timeout=2,
                    )
                    if control.returncode == 0:
                        break
                self.assertEqual(control.returncode, 0, control.stderr.decode())
                with secret.open("rb") as inherited:
                    result = subprocess.run(
                        [PROBE, "--host-port=" + str(port), str(secret),
                         str(runtime / "host-service"), str(cwd_secret),
                         str(Path.home() / ".ssh")],
                        cwd=cwd, env=environment, pass_fds=(inherited.fileno(),),
                        capture_output=True, text=True, timeout=30,
                    )
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assertIn("isolation=ok", result.stdout)
                token = state / "roquix/containers/isolation-probe/state-token"
                self.assertEqual(token.read_text(), "state=private\n")


if __name__ == "__main__":
    unittest.main()
