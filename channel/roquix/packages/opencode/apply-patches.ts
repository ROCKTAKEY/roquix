import path from "node:path"

const root = process.cwd()
const { patchedDependencies } = await Bun.file("package.json").json()
const patches = Object.entries(patchedDependencies).map(([specifier, patch]) => {
  const separator = specifier.lastIndexOf("@")
  return {
    name: specifier.slice(0, separator),
    version: specifier.slice(separator + 1),
    file: path.resolve(root, patch as string),
  }
})

// The lock layout contains multiple versions and nested installations.  Match
// their manifests so upstream's patches affect precisely the pinned packages.
for (const file of new Bun.Glob("**/node_modules/**/package.json").scanSync({
  onlyFiles: true,
  followSymlinks: false,
})) {
  const manifest = await Bun.file(file).json()
  if (!path.dirname(file).endsWith(`node_modules/${manifest.name}`)) continue
  const patch = patches.find(({ name, version }) =>
    name === manifest.name && (version === manifest.version || version.startsWith("github:")))
  if (!patch) continue
  console.log(`applying ${patch.file} to ${path.dirname(file)}`)
  const result = Bun.spawnSync(["patch", "--batch", "-p1", "-i", patch.file], {
    cwd: path.dirname(file),
    stdout: "inherit",
    stderr: "inherit",
  })
  if (result.exitCode !== 0) throw new Error(`Failed to patch ${file}`)
}
