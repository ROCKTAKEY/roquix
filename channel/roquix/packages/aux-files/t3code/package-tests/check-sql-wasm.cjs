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
