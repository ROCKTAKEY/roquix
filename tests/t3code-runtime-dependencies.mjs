import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { mkdirSync, mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { createRequire } from "node:module";
import { tmpdir } from "node:os";
import path from "node:path";
import { test } from "node:test";
import { fileURLToPath } from "node:url";

const script = fileURLToPath(new URL(
  "../channel/roquix/packages/aux-files/t3code-runtime-dependencies.mjs", import.meta.url,
));

test("staged consumers resolve their own peers and tolerate absent optional peers", () => {
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
        name, main: "index.cjs", peerDependencies: { peer: version, optional: "1" },
        peerDependenciesMeta: { optional: { optional: true } },
      });
      write(`${consumer}/index.cjs`, 'module.exports = require("peer");');
      manifest(`${consumer}/node_modules/peer`, { name: "peer", version, main: "index.cjs" });
      write(`${consumer}/node_modules/peer/index.cjs`, `module.exports = ${JSON.stringify(version)};`);
    }
    const output = path.join(root, "output");
    execFileSync(process.execPath, [script, root, output, "cli"]);
    const load = createRequire(path.join(output, "apps/server/package.json"));
    assert.equal(load("first"), "1");
    assert.equal(load("second"), "2");
  } finally {
    rmSync(root, { recursive: true, force: true });
  }
});
