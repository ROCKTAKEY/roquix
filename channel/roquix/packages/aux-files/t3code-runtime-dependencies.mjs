import { cpSync, existsSync, mkdirSync, readFileSync, realpathSync, symlinkSync } from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const [root, destination] = process.argv.slice(2);
const manifest = (directory) =>
  JSON.parse(readFileSync(path.join(directory, "package.json"), "utf8"));
const { selectCliRuntimeExternalDependencies } = await import(
  pathToFileURL(path.join(root, "scripts/lib/cli-external-packages.ts"))
);
const { selectDesktopRuntimeExternalDependencies } = await import(
  pathToFileURL(path.join(root, "scripts/lib/desktop-external-packages.ts"))
);
const modules = path.join(destination, "node_modules");
const staged = new Map();

function findDependency(directory, name) {
  for (let parent = directory; ; parent = path.dirname(parent)) {
    const candidate = path.join(parent, "node_modules", name);
    if (existsSync(candidate)) return realpathSync(candidate);
    if (parent === path.dirname(parent)) return undefined;
  }
}

function linkDependency(directory, name, target) {
  const link = path.join(directory, "node_modules", name);
  mkdirSync(path.dirname(link), { recursive: true });
  symlinkSync(path.relative(path.dirname(link), target), link);
}

function stagePackage(source) {
  if (staged.has(source)) return staged.get(source);
  const metadata = manifest(source);
  // Keep separate dependency closures when pnpm selected different versions.
  // Flattening them into one node_modules silently changes native loaders.
  const target = path.join(modules, ".runtime", String(staged.size), metadata.name);
  staged.set(source, target);
  cpSync(source, target, {
    recursive: true,
    dereference: false,
    filter: (file) => path.basename(file) !== "node_modules",
  });
  const dependencies = { ...metadata.dependencies, ...metadata.optionalDependencies };
  for (const name of Object.keys(dependencies).sort()) {
    const dependency = findDependency(source, name);
    // Some npm packages incorrectly label their musl binding as glibc.
    // Guix uses glibc, so never install a musl fallback beside that binding.
    if (dependency && !name.endsWith("-musl"))
      linkDependency(target, name, stagePackage(dependency));
    else if (!(name in (metadata.optionalDependencies ?? {}))) {
      throw new Error(`Missing runtime dependency ${metadata.name} -> ${name}`);
    }
  }
  return target;
}

for (const [workspace, select] of [
  ["apps/server", selectCliRuntimeExternalDependencies],
  ["apps/desktop", selectDesktopRuntimeExternalDependencies],
]) {
  const source = path.join(root, workspace);
  const destinationWorkspace = path.join(destination, workspace);
  const dependencies = select(manifest(source).dependencies);
  for (const name of Object.keys(dependencies).sort()) {
    const dependency = findDependency(source, name);
    if (!dependency) throw new Error(`Missing runtime dependency ${name}`);
    linkDependency(destinationWorkspace, name, stagePackage(dependency));
  }
}
