import assert from "node:assert/strict";
import { spawn } from "node:child_process";
import { mkdtempSync, readFileSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
const root = mkdtempSync(tmpdir() + "/hermes-gui-");
const log = [];
const children = [];
const pause = (ms) => new Promise((r) => setTimeout(r, ms));
try {
  const xvfb = spawn(
    "Xvfb",
    ["-displayfd", "3", "-screen", "0", "1280x900x24", "-nolisten", "tcp"],
    { stdio: ["ignore", "ignore", "pipe", "pipe"] },
  );
  children.push(xvfb);
  const display = await new Promise((r, j) => {
    xvfb.stdio[3].once("data", (x) => r(":" + x.toString().trim()));
    xvfb.once("error", j);
  });
  const env = {
    ...process.env,
    HOME: root,
    HERMES_HOME: root + "/hermes",
    XDG_CONFIG_HOME: root + "/config",
    XDG_CACHE_HOME: root + "/cache",
    XDG_DATA_HOME: root + "/data",
    DISPLAY: display,
  };
  delete env.WAYLAND_DISPLAY;
  delete env.ELECTRON_RUN_AS_NODE;
  const app = spawn(
    "dbus-run-session",
    [
      "--",
      process.argv[2],
      "--remote-debugging-port=0",
      "--user-data-dir=" + root + "/electron",
      "--disable-gpu",
      "--disable-dev-shm-usage",
    ],
    { env, stdio: ["ignore", "pipe", "pipe"], detached: true },
  );
  children.push(app);
  for (const stream of [app.stdout, app.stderr])
    stream.on("data", (x) => log.push(x.toString()));
  let address;
  for (let i = 0; i < 200; i++) {
    address = log.join("").match(/DevTools listening on (ws:\/\/[^\s]+)/)?.[1];
    if (address) break;
    if (app.exitCode !== null) throw Error("app exited " + app.exitCode);
    await pause(100);
  }
  if (!address) throw Error("no devtools endpoint");
  const ws = new WebSocket(address);
  await new Promise((r, j) => {
    ws.onopen = r;
    ws.onerror = j;
  });
  let seq = 0;
  const pending = new Map();
  ws.onmessage = (event) => {
    const d = JSON.parse(event.data);
    if (d.id) {
      const p = pending.get(d.id);
      pending.delete(d.id);
      d.error ? p.reject(Error(JSON.stringify(d.error))) : p.resolve(d.result);
    }
  };
  const call = (method, params = {}, sessionId) =>
    new Promise((resolve, reject) => {
      const id = ++seq;
      pending.set(id, { resolve, reject });
      ws.send(JSON.stringify({ id, method, params, sessionId }));
    });
  let target;
  for (let i = 0; i < 200; i++) {
    target = (await call("Target.getTargets")).targetInfos.find(
      (t) => t.type === "page",
    );
    if (target) break;
    await pause(100);
  }
  if (!target) throw Error("no page");
  const { sessionId } = await call("Target.attachToTarget", {
    targetId: target.targetId,
    flatten: true,
  });
  const readPage = async () => {
    const { result } = await call(
      "Runtime.evaluate",
      {
        expression:
          "({title:document.title,text:document.body.innerText,url:location.href})",
        returnByValue: true,
      },
      sessionId,
    );
    return result.value;
  };
  let state;
  for (let i = 0; i < 150; i++) {
    state = await readPage();
    if (state?.text.length > 150) {
      console.log(JSON.stringify(state));
      break;
    }
    await pause(200);
  }
  assert(state?.text.length > 150, "renderer has no interface");
  await pause(3000);
  state = await readPage();
  if (process.argv[3] === "light") {
    assert(
      !state.text.includes("Install Hermes locally"),
      "Light must not offer a local install",
    );
    assert(state.text.includes("Gateway URL"));
    const refusal = await call(
      "Runtime.evaluate",
      {
        expression:
          "window.hermesDesktop.continueBootstrapLocal().then(() => false, () => true)",
        awaitPromise: true,
        returnByValue: true,
      },
      sessionId,
    );
    assert.equal(
      refusal.result.value,
      true,
      "Light must reject local installation IPC",
    );
  } else {
    const connection = await call(
      "Runtime.evaluate",
      {
        expression:
          "Promise.race([window.hermesDesktop.getConnection().then(c => ({keys: Object.keys(c), baseUrl: c.baseUrl})), new Promise((_, reject) => setTimeout(() => reject(new Error('backend startup timed out')), 45000))])",
        awaitPromise: true,
        returnByValue: true,
      },
      sessionId,
    );
    assert(
      !connection.exceptionDetails,
      JSON.stringify(connection.exceptionDetails),
    );
    console.log("Backend connection:", connection.result.value);
    let ready = false;
    for (let attempt = 0; attempt < 450; attempt++) {
      const page = await readPage();
      if (page?.text.includes("What should I call you?")) {
        ready = true;
        break;
      }
      await pause(100);
    }
    assert(ready, "Desktop must reach onboarding through the packaged gateway");
  }
  const shot = await call(
    "Page.captureScreenshot",
    { format: "png" },
    sessionId,
  );
  writeFileSync(root + "/screenshot.png", Buffer.from(shot.data, "base64"));
  console.log(root + "/screenshot.png");
  ws.close();
} finally {
  writeFileSync(root + "/launch.log", log.join(""));
  console.log("LOG=" + root + "/launch.log");
  // The gateway detaches from Electron; only terminate the disposable home's PID.
  try {
    const { pid } = JSON.parse(readFileSync(root + "/hermes/gateway.pid", "utf8"));
    const environment = readFileSync(`/proc/${pid}/environ`, "utf8").split("\0");
    if (
      Number.isSafeInteger(pid) &&
      pid > 1 &&
      environment.includes("HERMES_HOME=" + root + "/hermes")
    ) {
      process.kill(pid, "SIGTERM");
    }
  } catch (error) {
    if (!["ENOENT", "ESRCH"].includes(error.code)) throw error;
  }
  for (const child of children.reverse()) {
    try {
      if (child.spawnargs[0] === "dbus-run-session")
        process.kill(-child.pid, "SIGTERM");
      else child.kill("SIGTERM");
    } catch {}
  }
}
