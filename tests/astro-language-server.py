"""Check an installed astro-ls without dependencies from the caller's profile.

Usage: python3 tests/astro-language-server.py ASTRO_LS TYPESCRIPT_LIB
"""

import json
import os
import select
import subprocess
import sys
import tempfile
import time


def send(process, message):
    body = json.dumps({"jsonrpc": "2.0", **message}).encode()
    process.stdin.write(f"Content-Length: {len(body)}\r\n\r\n".encode() + body)
    process.stdin.flush()


def response(process, request_id):
    pending = b""
    deadline = time.monotonic() + 30
    while time.monotonic() < deadline:
        if not select.select([process.stdout], [], [], 1)[0]:
            continue
        chunk = os.read(process.stdout.fileno(), 65536)
        if not chunk:
            raise AssertionError("astro-ls closed its output before responding")
        pending += chunk
        while b"\r\n\r\n" in pending:
            header, body = pending.split(b"\r\n\r\n", 1)
            headers = dict(line.split(b":", 1) for line in header.split(b"\r\n"))
            length = int(headers[b"Content-Length"])
            if len(body) < length:
                break
            message = json.loads(body[:length])
            pending = body[length:]
            if message.get("id") == request_id:
                assert "error" not in message, message
                return message["result"]
    raise AssertionError("astro-ls did not respond within 30 seconds")


with tempfile.TemporaryDirectory() as home:
    env = {"HOME": home, "PATH": os.defpath, "LANG": "C.UTF-8"}
    with subprocess.Popen(
        [os.path.abspath(sys.argv[1]), "--stdio"],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        env=env,
        cwd=home,
    ) as process:
        try:
            send(process, {"id": 1, "method": "initialize", "params": {
                "processId": None, "rootUri": None, "capabilities": {},
                "initializationOptions": {
                    "typescript": {"tsdk": os.path.abspath(sys.argv[2])},
                },
            }})
            result = response(process, 1)
            assert result["capabilities"], result
            send(process, {"method": "initialized", "params": {}})
            send(process, {"id": 2, "method": "shutdown", "params": None})
            assert response(process, 2) is None
            send(process, {"method": "exit"})
            assert process.wait(timeout=10) == 0
        finally:
            if process.poll() is None:
                process.kill()
                process.wait()
print("Astro LSP initialization and shutdown passed")
