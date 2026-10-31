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
