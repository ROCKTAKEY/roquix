"""Run with PROBE, DBUS_BIN_DIRECTORY, WESTON, WAYLAND_INFO, and PULSE_BIN_DIRECTORY."""

import os
import http.server
from pathlib import Path
import selectors
import signal
import socket
import subprocess
import sys
import tempfile
import time
import threading
import unittest

PROBE = str(Path(sys.argv.pop(1)).resolve())
DBUS = Path(sys.argv.pop(1)).resolve()
WESTON = str(Path(sys.argv.pop(1)).resolve())
WAYLAND_INFO = str(Path(sys.argv.pop(1)).resolve())
PULSE = Path(sys.argv.pop(1)).resolve()


class Server(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"server-ok")

    def log_message(self, *args):
        pass


class DesktopIsolationTests(unittest.TestCase):
    def wait_for_path(self, process, path):
        deadline = time.monotonic() + 15
        while not path.exists():
            self.assertIsNone(process.poll(), "process exited before creating " + str(path))
            self.assertLess(time.monotonic(), deadline, "path did not become ready: " + str(path))
            time.sleep(.05)

    @staticmethod
    def stop(process):
        if process.poll() is None:
            os.killpg(process.pid, signal.SIGTERM)
        process.wait(timeout=5)
        if process.stdout is not None:
            process.stdout.close()

    def test_connections_and_playback_preserve_host_resource_isolation(self):
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
            with socket.socket(socket.AF_UNIX) as host_service, \
                    http.server.ThreadingHTTPServer(("127.0.0.1", 0), Server) as host_listener:
                host_service.bind(str(runtime / "host-service"))
                threading.Thread(target=host_listener.serve_forever, daemon=True).start()
                self.addCleanup(host_listener.shutdown)
                port = host_listener.server_address[1]
                with socket.create_connection(("127.0.0.1", port), timeout=1):
                    pass
                environment = dict(
                    os.environ,
                    XDG_RUNTIME_DIR=str(runtime),
                    XDG_STATE_HOME=str(state),
                    WAYLAND_DISPLAY="wayland-test",
                    DISPLAY=":123",
                    XAUTHORITY=str(secret),
                    PULSE_SERVER="unix:" + str(runtime / "host-audio"),
                    XDG_CONFIG_HOME=str(root / "host-config"),
                    XDG_DATA_HOME=str(root / "host-data"),
                    XDG_CACHE_HOME=str(root / "host-cache"),
                    SSH_AUTH_SOCK=str(runtime / "host-service"),
                )
                compositor = subprocess.Popen(
                    [WESTON, "--backend=headless", "--renderer=pixman", "--shell=desktop",
                     "--socket=wayland-test", "--no-config", "--idle-time=0", "--debug"],
                    env=environment, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                    start_new_session=True,
                )
                self.addCleanup(self.stop, compositor)
                self.wait_for_path(compositor, runtime / "wayland-test")
                control = subprocess.run(
                    [WAYLAND_INFO], env=environment, capture_output=True, text=True, timeout=5,
                )
                self.assertEqual(control.returncode, 0, control.stderr)
                self.assertIn("weston_debug_v1", control.stdout)
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
                configuration = root / "host-audio.pa"
                configuration.write_text(
                    "load-module module-native-protocol-unix socket=" + str(runtime / "host-audio")
                    + " auth-anonymous=1\n"
                    + "load-module module-null-sink sink_name=host-playback\n"
                    + "load-module module-null-source source_name=host-microphone\n"
                    + "set-default-sink host-playback\n"
                )
                audio = subprocess.Popen(
                    [str(PULSE / "pulseaudio"), "--daemonize=no", "--use-pid-file=no",
                     "--exit-idle-time=-1", "--high-priority=no", "--realtime=no", "-n",
                     "--file=" + str(configuration)],
                    env=dict(environment, HOME=str(root), PULSE_CONFIG_PATH=str(root)),
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True,
                )
                self.addCleanup(self.stop, audio)
                self.wait_for_path(audio, runtime / "host-audio")
                control = subprocess.run(
                    [str(PULSE / "pactl"), "list", "short", "sources"],
                    env=environment, capture_output=True, text=True, timeout=5,
                )
                self.assertEqual(control.returncode, 0, control.stderr)
                self.assertIn("host-microphone", control.stdout)
                recording = root / "host-recording.pcm"
                with recording.open("wb") as output:
                    recorder = subprocess.Popen(
                        [str(PULSE / "parec"), "--device=host-playback.monitor", "--raw",
                         "--format=s16le", "--rate=48000", "--channels=2"],
                        env=environment, stdout=output, stderr=subprocess.DEVNULL,
                        start_new_session=True,
                    )
                self.addCleanup(self.stop, recorder)
                displays = set(Path("/tmp").glob("roquix-private-display-*"))
                with secret.open("rb") as inherited:
                    result = subprocess.run(
                        [PROBE, "--require-playback", "--require-private-display", "--host-port=" + str(port), str(secret),
                         str(runtime / "host-service"), str(cwd_secret),
                         str(Path.home() / ".ssh")],
                        cwd=cwd, env=environment, pass_fds=(inherited.fileno(),),
                        capture_output=True, text=True, timeout=30,
                    )
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.stop(recorder)
                self.assertGreater(sum(byte != 0 for byte in recording.read_bytes()), 48000,
                                   "application audio did not reach the host playback sink")
                self.assertIn("isolation=ok", result.stdout)
                token = state / "roquix/containers/isolation-probe/state-token"
                self.assertEqual(token.read_text(), "state=private\n")
                self.assertEqual(set(Path("/tmp").glob("roquix-private-display-*")), displays)
                interrupted = subprocess.Popen(
                    [PROBE, "--wait-for-interrupt"], cwd=cwd, env=environment,
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, start_new_session=True,
                )
                self.addCleanup(self.stop, interrupted)
                ready = token.parent / "interrupt-ready"
                self.wait_for_path(interrupted, ready)
                os.killpg(interrupted.pid, signal.SIGTERM)
                interrupted.wait(timeout=5)
                self.assertEqual(interrupted.returncode, 128 + signal.SIGTERM)
                self.assertEqual(set(Path("/tmp").glob("roquix-private-display-*")), displays)


if __name__ == "__main__":
    unittest.main()
