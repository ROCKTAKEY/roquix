const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");

const directory = process.argv[2];
const moduleOptions = {
  wasmBinary: fs.readFileSync(path.join(directory, "webp_codec.wasm")),
};
require(path.resolve(directory, "webp_codec.js"))(moduleOptions);
const m = moduleOptions;
const rgba = Buffer.from([255, 0, 0, 255]);
const input = m._malloc(4);
m.HEAPU8.set(rgba, input);
const sizePointer = m._malloc(4);
const encoded = m._webp_encode_rgba(input, 1, 1, 100, 1, sizePointer);
assert.ok(encoded);
const width = m._malloc(4);
const height = m._malloc(4);
const decoded = m._webp_decode_rgba(encoded, m.HEAPU32[sizePointer >> 2], width, height);
assert.equal(m.HEAPU32[width >> 2], 1);
assert.equal(m.HEAPU32[height >> 2], 1);
assert.deepEqual(Buffer.from(m.HEAPU8.subarray(decoded, decoded + 4)), rgba);
m._webp_free(decoded);
m._webp_free(encoded);
for (const pointer of [input, sizePointer, width, height]) m._free(pointer);
console.log("WebP lossless RGBA round-trip passed");
