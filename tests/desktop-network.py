"""Run with NETWORK_RUNNER and SLIRP4NETNS executable paths."""

import os
import contextlib
import http.server
from pathlib import Path
import socket
import subprocess
import sys
import tempfile
import threading
import unittest

RUNNER = str(Path(sys.argv.pop(1)).resolve())
SLIRP = str(Path(sys.argv.pop(1)).resolve())


class DesktopNetworkTests(unittest.TestCase):
    @unittest.skipUnless(Path("/dev/net/tun").exists(), "environment lacks a TUN device")
    def test_real_bridge_reaches_lan_and_internet_but_not_host_loopback(self):
        with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as route:
            route.connect(("192.0.2.1", 9))
            lan_address = route.getsockname()[0]

        class Server(http.server.BaseHTTPRequestHandler):
            def do_GET(self):
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"lan-ok")

            def log_message(self, *args):
                pass

        with tempfile.TemporaryDirectory(prefix="roquix-network-") as temporary, \
                http.server.ThreadingHTTPServer(("0.0.0.0", 0), Server) as server, \
                contextlib.ExitStack() as resources:
            threading.Thread(target=server.serve_forever, daemon=True).start()
            self.addCleanup(server.shutdown)
            port = str(server.server_address[1])
            with socket.create_connection((lan_address, int(port)), timeout=2):
                pass
            with socket.create_connection(("127.0.0.1", int(port)), timeout=2):
                pass
            ipv6_port = "0"
            try:
                ipv6 = resources.enter_context(socket.socket(socket.AF_INET6))
                ipv6.bind(("::1", 0))
                ipv6.listen()
                ipv6_port = str(ipv6.getsockname()[1])
                with socket.create_connection(("::1", int(ipv6_port)), timeout=2):
                    pass
            except OSError:
                pass
            internet_address = socket.getaddrinfo("www.gnu.org", 443, socket.AF_INET,
                                                  socket.SOCK_STREAM)[0][4][0]
            command = (
                "import socket,ssl,struct,sys,urllib.request\n"
                "opener=urllib.request.build_opener(urllib.request.ProxyHandler({}))\n"
                "assert opener.open('http://'+sys.argv[1]+':'+sys.argv[2],timeout=5).read()==b'lan-ok'\n"
                "for address in ['127.0.0.1','10.0.2.2']:\n"
                " try: socket.create_connection((address,int(sys.argv[2])),timeout=2)\n"
                " except OSError: pass\n"
                " else: raise AssertionError('host loopback is reachable')\n"
                "if int(sys.argv[3]):\n"
                " for address in ['::1','fd00::2']:\n"
                "  try: socket.create_connection((address,int(sys.argv[3])),timeout=2)\n"
                "  except OSError: pass\n"
                "  else: raise AssertionError('host IPv6 loopback is reachable')\n"
                # The runner does not mount resolv.conf; probe slirp's DNS
                # directly instead of relying on the host's resolver address.
                "query=struct.pack('!6H',1234,0x100,1,0,0,0)+b'\\x03www\\x03gnu\\x03org\\0\\0\\1\\0\\1'\n"
                "dns=socket.socket(socket.AF_INET,socket.SOCK_DGRAM);dns.settimeout(5)\n"
                "dns.sendto(query,('10.0.2.3',53))\n"
                "header=struct.unpack('!6H',dns.recv(4096)[:12])\n"
                "assert header[0]==1234 and header[1]&15==0 and header[3]>0\n"
                "with socket.create_connection((sys.argv[4],443),timeout=15) as connection:\n"
                " with ssl.create_default_context().wrap_socket(connection,server_hostname='www.gnu.org') as tls:\n"
                "  tls.sendall(b'HEAD / HTTP/1.1\\r\\nHost: www.gnu.org\\r\\nConnection: close\\r\\n\\r\\n')\n"
                "  assert tls.recv(4096).startswith(b'HTTP/')\n"
                "print('lan-internet=ok')\n"
            )
            result = subprocess.run(
                [RUNNER, temporary, SLIRP, sys.executable, "-c", command, lan_address, port,
                 ipv6_port, internet_address],
                capture_output=True, text=True, timeout=40,
            )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn("lan-internet=ok", result.stdout)

    def test_private_namespace_blocks_host_loopback_and_abstract_sockets(self):
        with tempfile.TemporaryDirectory(prefix="roquix-network-") as temporary:
            root = Path(temporary)
            bridge = root / "bridge"
            bridge.write_text(
                "#!" + sys.executable + "\n"
                "import os,sys,time\n"
                "expected={'--configure','--disable-host-loopback','--enable-ipv6',"
                "'--enable-sandbox','--enable-seccomp','--ready-fd=3'}\n"
                "assert set(sys.argv[1:-2]) == expected\n"
                "assert sys.argv[-1] == 'tap0'\n"
                "time.sleep(.2)\n"
                "os.write(3,b'1')\n"
                "os.close(3)\n"
                "time.sleep(60)\n"
            )
            bridge.chmod(0o755)
            abstract = "roquix-test-" + str(os.getpid())
            with socket.socket(socket.AF_UNIX) as unix, socket.socket() as tcp:
                unix.bind("\0" + abstract)
                unix.listen()
                tcp.bind(("127.0.0.1", 0))
                tcp.listen()
                # Controls prove that these exact endpoints accept connections.
                with socket.socket(socket.AF_UNIX) as client:
                    client.connect("\0" + abstract)
                with socket.create_connection(tcp.getsockname(), timeout=1):
                    pass
                command = (
                    "import os,socket,sys\n"
                    "assert os.readlink('/proc/self/ns/net') != sys.argv[1]\n"
                    "for family,endpoint in [(socket.AF_UNIX,'\\0'+sys.argv[2]),"
                    "(socket.AF_INET,('127.0.0.1',int(sys.argv[3])))]:\n"
                    " s=socket.socket(family);s.settimeout(1)\n"
                    " try: s.connect(endpoint)\n"
                    " except OSError: pass\n"
                    " else: raise AssertionError('host endpoint is reachable')\n"
                    "print('network-isolation=ok')\n"
                )
                result = subprocess.run(
                    [RUNNER, str(root), str(bridge), sys.executable, "-c", command,
                     os.readlink("/proc/self/ns/net"), abstract, str(tcp.getsockname()[1])],
                    capture_output=True, text=True, timeout=15,
                )
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertIn("network-isolation=ok", result.stdout)
            self.assertEqual((root / "resolv.conf").read_text(), "nameserver 10.0.2.3\n")
            self.assertFalse(Path("/proc/" + (root / "network-pid").read_text()).exists())

    def test_failed_bridge_never_launches_the_payload(self):
        with tempfile.TemporaryDirectory(prefix="roquix-network-") as temporary:
            root = Path(temporary)
            bridge = root / "failed-bridge"
            bridge.write_text("#!" + sys.executable + "\nraise SystemExit(1)\n")
            bridge.chmod(0o755)
            marker = root / "payload-started"
            result = subprocess.run(
                [RUNNER, str(root), str(bridge), sys.executable, "-c",
                 "from pathlib import Path;Path(" + repr(str(marker)) + ").touch()"],
                capture_output=True, text=True, timeout=15,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("network bridge", result.stderr)
            self.assertFalse(marker.exists())
            self.assertFalse(Path("/proc/" + (root / "network-pid").read_text()).exists())

    @unittest.skipIf(Path("/dev/net/tun").exists(), "environment has a TUN device")
    def test_missing_tun_fails_closed_with_the_real_bridge(self):
        with tempfile.TemporaryDirectory(prefix="roquix-network-") as temporary:
            root = Path(temporary)
            marker = root / "payload-started"
            result = subprocess.run(
                [RUNNER, str(root), SLIRP, sys.executable, "-c",
                 "from pathlib import Path;Path(" + repr(str(marker)) + ").touch()"],
                capture_output=True, text=True, timeout=15,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(marker.exists())
            self.assertIn("network bridge", result.stderr)
            self.assertIn("/dev/net/tun", result.stderr)


if __name__ == "__main__":
    unittest.main()
