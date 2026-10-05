import assert from "node:assert/strict";
import { execFileSync, spawn } from "node:child_process";
import { once } from "node:events";
import { existsSync, mkdtempSync, readFileSync, rmSync } from "node:fs";
import { createRequire } from "node:module";
import { createServer } from "node:net";
import { tmpdir } from "node:os";
import path from "node:path";
import { setTimeout as delay } from "node:timers/promises";

const [output, nativeContracts, version] = process.argv.slice(2);
const executable = path.join(output, "bin/t3");
const application = path.join(output, "lib/t3code-cli");
const home = mkdtempSync(path.join(tmpdir(), "t3code-cli-test-"));
const environment = {
  HOME: home,
  PATH: "/nonexistent",
  T3CODE_TELEMETRY_ENABLED: "false",
};
const run = (...args) => execFileSync(executable, args, {
  env: environment, encoding: "utf8", timeout: 30_000,
});

let server;
try {
  assert.ok(existsSync(executable), "the package must provide the public t3 command");
  assert.match(run("--help"), /serve/);
  assert.match(run("pair", "--help"), /pairing/i);
  assert.match(run("auth", "--help"), /session/);
  assert.equal(run("--version").trim(), `t3 v${version}`);
  assert.match(readFileSync(path.join(output, "share/licenses/t3code-cli/LICENSE"), "utf8"),
    /MIT License/);

  for (const name of ["fff", "ffi", "keyring"]) {
    const result = execFileSync(process.execPath,
      [nativeContracts, application, name, "server"],
      { env: environment, encoding: "utf8", timeout: 30_000 });
    assert.equal(result, "native-contract-ok");
  }
  const load = createRequire(path.join(application, "apps/server/package.json"));
  const terminal = load("node-pty").spawn(process.execPath,
    ["-e", "process.stdout.write('guix-cli-pty-contract')"],
    { cwd: home, env: environment });
  const terminalResult = await new Promise((resolve, reject) => {
    let text = "";
    const timeout = setTimeout(() => {
      terminal.kill();
      reject(new Error("the installed terminal addon timed out"));
    }, 10_000);
    terminal.onData((data) => { text += data; });
    terminal.onExit(({ exitCode }) => {
      clearTimeout(timeout);
      resolve({ text, exitCode });
    });
  });
  assert.deepEqual(terminalResult, { text: "guix-cli-pty-contract", exitCode: 0 });

  const reservation = createServer();
  reservation.listen(0, "127.0.0.1");
  await once(reservation, "listening");
  const port = reservation.address().port;
  await new Promise((resolve) => reservation.close(resolve));
  const base = `http://127.0.0.1:${port}`;
  server = spawn(executable,
    ["serve", "--host", "127.0.0.1", "--port", String(port), "--base-dir", home],
    { env: environment, cwd: home, stdio: ["ignore", "pipe", "pipe"] });
  let startup = "";
  // Startup output includes the credential. Keep it out of build logs and errors.
  server.stdout.on("data", (data) => { startup += data; });
  server.stderr.resume();
  const deadline = Date.now() + 30_000;
  while (!/Pairing URL:/.test(startup)) {
    assert.equal(server.exitCode, null, "the packaged server exited during startup");
    assert.ok(Date.now() < deadline, "the packaged server did not become ready");
    await delay(100);
  }
  const page = await fetch(base);
  assert.equal(page.status, 200);
  assert.match(await page.text(), /<html/i);
  const rejected = await fetch(`${base}/api/auth/clients`);
  assert.equal(rejected.status, 401, "unauthenticated clients must be rejected");
  const credential = startup.match(/^Token: (.+)$/m)[1].trim();
  const session = await fetch(`${base}/api/auth/browser-session`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ credential }),
  });
  assert.equal(session.status, 200, "the startup credential must authorize a browser");
  const cookie = session.headers.get("set-cookie").split(";")[0];
  const clients = await fetch(`${base}/api/auth/clients`, { headers: { Cookie: cookie } });
  assert.equal(clients.status, 200);
  const replay = await fetch(`${base}/api/auth/browser-session`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ credential }),
  });
  assert.equal(replay.status, 401, "a consumed startup token cannot pair another client");
  assert.ok(existsSync(path.join(home, "userdata/state.sqlite")));
  assert.match(run("pair", "--base-dir", home), /Pairing URL:/);
  assert.match(run("auth", "session", "list", "--base-dir", home, "--json"), /browser-session-cookie/);
  console.log("CLI, native modules, terminal, Web UI, and pairing contracts passed.");
} finally {
  if (server && server.exitCode === null) {
    const exited = once(server, "exit");
    server.kill("SIGTERM");
    const timeout = setTimeout(() => server.kill("SIGKILL"), 10_000);
    await exited;
    clearTimeout(timeout);
  }
  rmSync(home, { recursive: true, force: true });
}
