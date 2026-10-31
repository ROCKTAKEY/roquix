// SQL.js build check run by t3code-wasm.scm from the SQL.js source directory.
// T3 Code uses both the default and browser entry points with an explicit WASM
// binary. A database round trip through each entry verifies that both generated
// JavaScript loaders work with the source-built module in dist/.

const assert = require("node:assert/strict");
const { readFileSync } = require("node:fs");
const path = require("node:path");

// T3 supplies the same explicit WASM URL to the browser and worker entry points.
const wasmBinary = readFileSync("dist/sql-wasm.wasm");
Promise.all(
  ["sql-wasm", "sql-wasm-browser"].map(async (entry) => {
    const init = require(path.resolve(`dist/${entry}.js`));
    const SQL = await init({ wasmBinary });
    const db = new SQL.Database();
    db.run("create table t(v); insert into t values (42)");
    assert.equal(db.exec("select v from t")[0].values[0][0], 42);
    db.close();
  }),
).catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
