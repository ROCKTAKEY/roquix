import path from "node:path"

const root = process.cwd()
const { patchedDependencies } = await Bun.file("package.json").json()
const patches = new Map<string, Map<string, string>>()

for (const [specifier, patch] of Object.entries(patchedDependencies)) {
  const separator = specifier.lastIndexOf("@")
  const name = specifier.slice(0, separator)
  const version = specifier.slice(separator + 1)
  const versions = patches.get(name) ?? new Map<string, string>()
  versions.set(version, path.resolve(root, patch as string))
  patches.set(name, versions)
}

// The lock layout contains multiple versions and nested installations.  Match
// their manifests so upstream's patches affect precisely the pinned packages.
for (const file of new Bun.Glob("**/node_modules/**/package.json").scanSync({
  onlyFiles: true,
  followSymlinks: false,
})) {
  const manifest = await Bun.file(file).json()
  if (!path.dirname(file).endsWith(`node_modules/${manifest.name}`)) continue
  const versions = patches.get(manifest.name)
  if (!versions) continue
  const patch = versions.get(manifest.version) ??
    [...versions].find(([version]) => version.startsWith("github:"))?.[1]
  if (!patch) continue
  console.log(`applying ${patch} to ${path.dirname(file)}`)
  const result = Bun.spawnSync(["patch", "--batch", "-p1", "-i", patch], {
    cwd: path.dirname(file),
    stdout: "inherit",
    stderr: "inherit",
  })
  if (result.exitCode !== 0) throw new Error(`Failed to patch ${file}`)
}
