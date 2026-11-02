#!/usr/bin/env python3
"""Exercise Bun 1.0.30 code generation against its bootstrap runtime.

Usage: python3 tests/bun-bootstrap-codegen.py BUN PREPARED_SOURCE
PREPARED_SOURCE is the bun-bootstrap-native-deps-1.0.30 output, with any
codegen patch applied. The check models a bundler retaining its directory
listing across consecutive requests, as Bun 1.0.7 can do.
"""

import pathlib
import subprocess
import sys
import tempfile

bun, source = map(pathlib.Path, sys.argv[1:])
with tempfile.TemporaryDirectory(prefix="bun-codegen-test-") as directory:
    root = pathlib.Path(directory)
    build = root / "build"
    (build / "codegen").mkdir(parents=True)
    preload = root / "check-entrypoints.ts"
    preload.write_text("""
import { readdirSync } from "fs";
import { dirname, basename } from "path";
const build = Bun.build;
let entries: Set<string> | undefined;
Bun.build = async function (options) {
  const entry = options.entrypoints[0];
  entries ??= new Set(readdirSync(dirname(entry)));
  if (!entries.has(basename(entry))) {
    throw new Error("Entry point created after bundling started: " + entry);
  }
  return build(options);
};
""")
    subprocess.run([
        str(bun.resolve()), "--preload", str(preload),
        str(source.resolve() / "src/codegen/bundle-functions.ts"),
        "--debug=OFF", str(build),
    ], check=True)
    for name in ("WebCoreJSBuiltins.h", "WebCoreJSBuiltins.cpp", "WebCoreJSBuiltins.d.ts"):
        output = build / "codegen" / name
        assert output.stat().st_size > 0, f"Empty generated output: {name}"
