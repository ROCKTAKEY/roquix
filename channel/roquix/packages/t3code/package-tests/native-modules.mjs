import assert from "node:assert/strict";
import { writeFileSync, mkdirSync } from "node:fs";
import { createRequire } from "node:module";
import path from "node:path";

const [application, name, workspace = name === "fff" ? "server" : "desktop"] = process.argv.slice(2);
const load = createRequire(path.join(application, "apps", workspace, "package.json"));

// These calls cross the installed JS/native boundary using the packaged runtime.
// No desktop session or real credential store is needed.
switch (name) {
  case "fff": {
    const project = path.join(process.env.HOME, "project");
    mkdirSync(project);
    writeFileSync(path.join(project, "guix-native-contract.txt"), "fixture");
    const { FileFinder } = load("@ff-labs/fff-node");
    const result = FileFinder.create({ basePath: project });
    assert.ok(result.ok, JSON.stringify(result));
    const finder = result.value;
    try {
      const scan = await finder.waitForScan(5000);
      assert.ok(scan.ok && scan.value);
      const search = finder.fileSearch("guix-native-contract");
      assert.ok(search.ok);
      assert.ok(
        search.value.items.some((item) => item.relativePath === "guix-native-contract.txt"),
      );
    } finally {
      finder.destroy();
    }
    break;
  }
  case "ffi": {
    const ffiLoad = workspace === "server"
      ? createRequire(load.resolve("@ff-labs/fff-node"))
      : load;
    const { open, load: call, close, DataType } = ffiLoad("ffi-rs");
    open({ library: "libc", path: "libc.so.6" });
    try {
      assert.equal(
        call({
          library: "libc",
          funcName: "strlen",
          retType: DataType.U64,
          paramsType: [DataType.String],
          paramsValue: ["guix"],
        }),
        4,
      );
    } finally {
      close("libc");
    }
    break;
  }
  case "keyring": {
    const { Entry, AsyncEntry } = load("@napi-rs/keyring");
    assert.equal(typeof Entry.prototype.getPassword, "function");
    assert.equal(typeof AsyncEntry.prototype.getPassword, "function");
    break;
  }
  case "xa11y": {
    const { _makeTestLocator } = load("@crowecawcaw/xa11y");
    const element = await _makeTestLocator().descendant('button[name="Back"]').element();
    assert.equal(element.name, "Back");
    assert.equal(element.role, "button");
    break;
  }
  default:
    throw new Error(`Unknown native contract: ${name}`);
}
process.stdout.write("native-contract-ok");
