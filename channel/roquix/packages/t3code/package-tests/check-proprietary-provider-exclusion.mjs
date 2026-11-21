import assert from "node:assert/strict";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

const excludedDependency = /(?:@anthropic-ai(?:\/|\+)claude-agent-sdk|@cursor(?:\/|\+)sdk)\b/;

function checkTree(directory) {
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const path = join(directory, entry.name);
    assert.doesNotMatch(path, excludedDependency, `Excluded provider dependency path: ${path}`);
    if (entry.isDirectory()) {
      checkTree(path);
    } else if (entry.isFile() && /\.(?:[cm]?js|json|map)$/.test(entry.name)) {
      const text = readFileSync(path, "utf8");
      // Source maps can retain erased type imports in upstream application code.
      const payload = entry.name.endsWith(".map")
        ? JSON.stringify(JSON.parse(text).sources)
        : text;
      assert.ok(!excludedDependency.test(payload), `Excluded provider dependency reference: ${path}`);
    }
  }
}

checkTree(process.argv[2]);
