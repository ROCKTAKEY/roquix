import { message } from "fixture-dependency"
import { workspaceMessage } from "fixture-workspace"

await Bun.write("dist/result.txt", `${message}:${workspaceMessage}\n`)
