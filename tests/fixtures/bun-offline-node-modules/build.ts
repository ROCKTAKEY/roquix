import isNumber from "is-number"

if (!isNumber("42") || isNumber("forty-two")) {
  throw new Error("offline dependency was not resolved correctly")
}

await Bun.write("dist/result.txt", "offline-node-modules-ok\n")
