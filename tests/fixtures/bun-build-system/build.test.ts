import { expect, test } from "bun:test"

test("runs with Bun", () => {
  expect(process.versions.bun).toBe("1.3.14")
})
