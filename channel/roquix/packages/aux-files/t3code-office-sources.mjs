import {
  cpSync,
  chmodSync,
  existsSync,
  readFileSync,
  readdirSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const manifest = (directory) =>
  JSON.parse(readFileSync(path.join(directory, "package.json")));

function* files(directory) {
  for (const entry of readdirSync(directory, { withFileTypes: true })) {
    const file = path.join(directory, entry.name);
    if (entry.isDirectory()) yield* files(file);
    else if (entry.isFile()) yield file;
  }
}

export function installOfficeSources(target, source) {
  const metadata = manifest(target);
  const rebuilt = manifest(source);
  if (metadata.name !== rebuilt.name || metadata.version !== rebuilt.version)
    throw new Error(
      `Source identity does not match ${metadata.name}@${metadata.version}`,
    );
  function sourceEntry(value) {
    if (typeof value !== "string") {
      return Object.fromEntries(
        Object.entries(value).map(([key, entry]) => [key, sourceEntry(entry)]),
      );
    }
    if (!value.startsWith("./dist/")) return value;
    const stem = value
      .replace("./dist/", "./src/")
      .replace(/(?:\.d)?\.(?:mjs|mts|js|ts)$/, "");
    const entry = [stem + ".ts", stem + ".tsx", stem].find((file) =>
      existsSync(path.join(source, file)),
    );
    if (!entry)
      throw new Error(`No source entry for ${metadata.name}: ${value}`);
    return entry;
  }
  const updated = { ...metadata, exports: sourceEntry(metadata.exports) };
  for (const field of ["main", "module", "types"]) {
    if (metadata[field]) updated[field] = sourceEntry(metadata[field]);
  }
  rmSync(path.join(target, "dist"), { recursive: true, force: true });
  cpSync(path.join(source, "src"), path.join(target, "src"), {
    recursive: true,
  });
  cpSync(path.join(source, "shared"), path.join(target, "shared"), {
    recursive: true,
  });
  for (const file of files(path.join(target, "src"))) {
    if (!/\.tsx?$/.test(file)) continue;
    const contents = readFileSync(file, "utf8");
    const updated = contents.replace(
      /(['"])(?:\.\.\/)+shared\//g,
      (_, quote) =>
        quote +
        path.relative(path.dirname(file), path.join(target, "shared")) +
        "/",
    );
    if (contents !== updated) {
      chmodSync(file, 0o644);
      writeFileSync(file, updated);
    }
  }
  if (metadata.name === "@betteroffice/docx") {
    const client = path.join(target, "src/yrs/residentEngineWorkerClient.ts");
    const contents = readFileSync(client, "utf8");
    if (!contents.includes("./residentEngineWorker.mjs"))
      throw new Error("Unrecognized DOCX worker entry");
    chmodSync(client, 0o644);
    writeFileSync(
      client,
      contents.replaceAll(
        "./residentEngineWorker.mjs",
        "./residentEngineWorker.ts",
      ),
    );
  }
  writeFileSync(
    path.join(target, "package.json"),
    JSON.stringify(updated, null, 2) + "\n",
  );
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href)
  installOfficeSources(...process.argv.slice(2));
