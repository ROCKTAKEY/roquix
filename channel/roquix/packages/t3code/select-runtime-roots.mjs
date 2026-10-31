// Bridge from staging.scm to the pinned T3 Code source's dependency selectors.
// The upstream selectors determine which packages remain external to the bundles;
// calling them keeps packaging aligned with that release's bundling policy.
// Arguments are the source root and cli/desktop variant. Stdout is the JSON list
// of workspace names and dependency roots used by Scheme to stage their closures.

import { readFileSync } from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const [root, variant] = process.argv.slice(2);
if (!["cli", "desktop"].includes(variant))
  throw new Error(`Unknown variant: ${variant}`);
const workspaces = [["server", "cli", "selectCliRuntimeExternalDependencies"]];
if (variant === "desktop")
  workspaces.push([
    "desktop",
    "desktop",
    "selectDesktopRuntimeExternalDependencies",
  ]);
const selected = [];
for (const [workspace, module, name] of workspaces) {
  const { [name]: select } = await import(
    pathToFileURL(path.join(root, `scripts/lib/${module}-external-packages.ts`))
  );
  const { dependencies } = JSON.parse(
    readFileSync(path.join(root, `apps/${workspace}/package.json`), "utf8"),
  );
  selected.push({
    workspace: `apps/${workspace}`,
    dependencies: Object.keys(select(dependencies)).sort(),
  });
}
process.stdout.write(JSON.stringify(selected));
