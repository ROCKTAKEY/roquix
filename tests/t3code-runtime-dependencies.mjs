import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { existsSync, mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { createRequire } from "node:module";
import { tmpdir } from "node:os";
import path from "node:path";
import { test } from "node:test";
import { fileURLToPath } from "node:url";

const channel = fileURLToPath(new URL("../channel", import.meta.url));
const driver = fileURLToPath(new URL("./t3code-dependencies-driver.scm", import.meta.url));
const selector = fileURLToPath(new URL(
  "../channel/roquix/packages/aux-files/t3code-select-runtime-dependencies.mjs", import.meta.url,
));
const stage = (root, output) => execFileSync("guix", [
  "repl", "-L", channel, "--", driver, "runtime", root, output, selector, "cli",
], { timeout: 30000 });

test("Linux runtime retains node-pty's Unix addon without its Windows console binaries", () => {
  const root = mkdtempSync(path.join(tmpdir(), "t3code-platform-"));
  const write = (name, contents) => {
    const file = path.join(root, name);
    mkdirSync(path.dirname(file), { recursive: true });
    writeFileSync(file, contents);
  };
  try {
    write("scripts/lib/cli-external-packages.ts",
      "export const selectCliRuntimeExternalDependencies = (dependencies) => dependencies;");
    write("apps/server/package.json", JSON.stringify({ dependencies: { "node-pty": "1" } }));
    const dependency = "apps/server/node_modules/node-pty";
    write(`${dependency}/package.json`, JSON.stringify({ name: "node-pty" }));
    write(`${dependency}/build/Release/pty.node`, "Unix addon");
    for (const arch of ["win10-x64", "win10-arm64"]) {
      for (const file of ["OpenConsole.exe", "conpty.dll"]) {
        write(`${dependency}/third_party/conpty/1.25.260303002/${arch}/${file}`, "MZ");
      }
    }
    const output = path.join(root, "output");
    stage(root, output);
    const installed = path.join(output, "apps/server/node_modules/node-pty");
    assert.ok(existsSync(path.join(installed, "build/Release/pty.node")));
    assert.ok(!existsSync(path.join(installed, "third_party/conpty")));
  } finally {
    rmSync(root, { recursive: true, force: true });
  }
});

test("cyclic consumers resolve their own peers and tolerate absent optional peers", () => {
  const root = mkdtempSync(path.join(tmpdir(), "t3code-peers-"));
  const write = (name, contents) => {
    const file = path.join(root, name);
    mkdirSync(path.dirname(file), { recursive: true });
    writeFileSync(file, contents);
  };
  const manifest = (name, value) => write(`${name}/package.json`, JSON.stringify(value));
  try {
    write("scripts/lib/cli-external-packages.ts",
      "export const selectCliRuntimeExternalDependencies = (dependencies) => dependencies;");
    manifest("apps/server", { dependencies: { first: "1", second: "1" } });
    for (const [name, version] of [["first", "1"], ["second", "2"]]) {
      const consumer = `apps/server/node_modules/${name}`;
      manifest(consumer, {
        name, main: "index.cjs",
        dependencies: { [name === "first" ? "second" : "first"]: "1" },
        peerDependencies: { peer: version, optional: "1" },
        peerDependenciesMeta: { optional: { optional: true } },
      });
      write(`${consumer}/index.cjs`, 'module.exports = require("peer");');
      manifest(`${consumer}/node_modules/peer`, { name: "peer", version, main: "index.cjs" });
      write(`${consumer}/node_modules/peer/index.cjs`, `module.exports = ${JSON.stringify(version)};`);
    }
    const output = path.join(root, "output");
    stage(root, output);
    const load = createRequire(path.join(output, "apps/server/package.json"));
    assert.equal(load("first"), "1");
    assert.equal(load("second"), "2");
  } finally {
    rmSync(root, { recursive: true, force: true });
  }
});
