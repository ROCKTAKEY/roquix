import { expect, test } from "bun:test"
import { mkdtemp, rm } from "node:fs/promises"
import os from "node:os"
import path from "node:path"

test("upstream patches follow the pinned version across nested installations", async () => {
  const root = await mkdtemp(path.join(os.tmpdir(), "opencode-patches-"))
  const helper = path.resolve(import.meta.dir, "../channel/roquix/packages/opencode/apply-patches.ts")
  try {
    await Bun.write(path.join(root, "package.json"), JSON.stringify({
      patchedDependencies: { "fixture@1.0.0": "fixture.patch" },
    }))
    await Bun.write(path.join(root, "fixture.patch"),
      "--- a/value.txt\n+++ b/value.txt\n@@ -1 +1 @@\n-original\n+patched\n")
    const installations = [
      ["node_modules/fixture", "2.0.0"],
      ["node_modules/consumer/node_modules/fixture", "1.0.0"],
      ["node_modules/unrelated/test", "1.0.0"],
    ]
    for (const [directory, version] of installations) {
      await Bun.write(path.join(root, directory, "package.json"),
        JSON.stringify({ name: "fixture", version }))
      await Bun.write(path.join(root, directory, "value.txt"), "original\n")
    }
    const child = Bun.spawn([process.execPath, helper], { cwd: root, stdout: "pipe", stderr: "pipe" })
    const error = await new Response(child.stderr).text()
    expect(await child.exited, error).toBe(0)
    expect(await Bun.file(path.join(root, installations[0][0], "value.txt")).text()).toBe("original\n")
    expect(await Bun.file(path.join(root, installations[1][0], "value.txt")).text()).toBe("patched\n")
    expect(await Bun.file(path.join(root, installations[2][0], "value.txt")).text()).toBe("original\n")
  } finally {
    await rm(root, { recursive: true, force: true })
  }
})
