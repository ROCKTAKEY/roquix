import { createHash } from "node:crypto";
import { readFileSync, readdirSync } from "node:fs";
import path from "node:path";

function* files(directory) {
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const file = path.join(directory, entry.name);
    if (entry.isDirectory()) yield* files(file);
    else if (entry.isFile()) yield file;
  }
}
const wasm = (bytes) =>
  bytes.subarray(0, 4).equals(Buffer.from([0, 97, 115, 109]));
const digest = (bytes) => createHash("sha256").update(bytes).digest("hex");
const [output, ...sources] = process.argv.slice(2);
const built = new Set();
for (const source of sources) {
  for (const file of files(source)) {
    const bytes = readFileSync(file);
    if (wasm(bytes)) built.add(digest(bytes));
  }
}
let count = 0;
for (const file of files(output)) {
  const bytes = readFileSync(file);
  const magic = bytes.subarray(0, 4).toString("hex");
  if (
    bytes.subarray(0, 2).toString() === "MZ" ||
    [
      "feedface",
      "feedfacf",
      "cefaedfe",
      "cffaedfe",
      "cafebabe",
      "bebafeca",
    ].includes(magic)
  ) {
    throw new Error(`Foreign executable in Linux output: ${file}`);
  }
  if (wasm(bytes)) {
    if (!built.has(digest(bytes)))
      throw new Error(`WASM is not from a declared source build: ${file}`);
    if (!WebAssembly.validate(bytes))
      throw new Error(`Invalid WebAssembly: ${file}`);
    count++;
  }
}
if (count !== 13)
  throw new Error(`Expected 13 runtime WASM modules, found ${count}`);
console.log(
  `Verified ${count} source-built WASM modules and absence of foreign executables`,
);
