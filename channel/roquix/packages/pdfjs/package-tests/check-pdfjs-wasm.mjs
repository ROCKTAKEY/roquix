import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const root = path.resolve(process.argv[2]);
const codecs = process.argv.slice(3);
const selected = (name) => codecs.length === 0 || codecs.includes(name);
function instantiate(file) {
  const module = new WebAssembly.Module(readFileSync(file));
  return {
    instantiateWasm(imports, ready) {
      const instance = new WebAssembly.Instance(module, imports);
      ready(instance, module);
      return instance.exports;
    },
  };
}
for (const name of ["openjpeg", "jbig2"].filter(selected)) {
  const { default: factory } = await import(
    pathToFileURL(path.join(root, name, `${name}.js`))
  );
  const module = await factory(
    instantiate(path.join(root, name, `${name}.wasm`)),
  );
  const memory = module._malloc(16);
  assert.ok(memory > 0, `${name} allocator`);
  module._free(memory);
}
if (selected("qcms")) {
  const qcms = await import(pathToFileURL(path.join(root, "qcms/qcms.js")));
  qcms.initSync({ module: readFileSync(path.join(root, "qcms/qcms_bg.wasm")) });
  assert.equal(qcms.qcms_transformer_from_memory(new Uint8Array(), 0, 0), 0);
}
if (selected("quickjs")) {
  const { default: quickjs } = await import(
    pathToFileURL(path.join(root, "quickjs/quickjs-eval.js"))
  );
  const sandbox = await quickjs(
    instantiate(path.join(root, "quickjs/quickjs-eval.wasm")),
  );
  globalThis.window = {
    console: {
      error(message) {
        throw new Error(message);
      },
    },
  };
  sandbox.ccall(
    "evalInSandbox",
    null,
    ["string", "number"],
    ['if (2 + 2 !== 4) throw new Error("arithmetic");', 0],
  );
  sandbox.ccall("nukeSandbox", null, [], []);
}
console.log("PDF.js WASM codecs and QuickJS bindings execute successfully");
