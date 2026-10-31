import { cpSync, existsSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const manifest = (directory) => JSON.parse(readFileSync(path.join(directory, 'package.json')));

export function installOfficeSources(target, source) {
  const metadata = manifest(target);
  const rebuilt = manifest(source);
  if (metadata.name !== rebuilt.name || metadata.version !== rebuilt.version)
    throw new Error(`Source identity does not match ${metadata.name}@${metadata.version}`);
  function sourceEntry(value) {
    if (typeof value !== 'string') {
      return Object.fromEntries(Object.entries(value).map(([key, entry]) => [key, sourceEntry(entry)]));
    }
    if (!value.startsWith('./dist/')) return value;
    const stem = value.replace('./dist/', './src/').replace(/(?:\.d)?\.(?:mjs|mts|js|ts)$/, '');
    const entry = [stem + '.ts', stem + '.tsx', stem].find(file => existsSync(path.join(source, file)));
    if (!entry) throw new Error(`No source entry for ${metadata.name}: ${value}`);
    return entry;
  }
  const updated = { ...metadata, exports: sourceEntry(metadata.exports) };
  for (const field of ['main', 'module', 'types']) {
    if (metadata[field]) updated[field] = sourceEntry(metadata[field]);
  }
  rmSync(path.join(target, 'dist'), { recursive: true, force: true });
  cpSync(path.join(source, 'src'), path.join(target, 'src'), { recursive: true });
  if (metadata.name === '@betteroffice/docx') {
    const client = path.join(target, 'src/yrs/residentEngineWorkerClient.ts');
    const contents = readFileSync(client, 'utf8');
    if (!contents.includes('./residentEngineWorker.mjs')) throw new Error('Unrecognized DOCX worker entry');
    rmSync(client);
    writeFileSync(client, contents.replaceAll('./residentEngineWorker.mjs', './residentEngineWorker.ts'));
  }
  writeFileSync(path.join(target, 'package.json'), JSON.stringify(updated, null, 2) + '\n');
}

function findPackages(directory) {
  const packages = new Map();
  function visit(directory) {
    for (const entry of readdirSync(directory, { withFileTypes: true })) {
      const file = path.join(directory, entry.name);
      if (entry.isDirectory()) visit(file);
      else if (entry.isFile() && entry.name === 'package.json') {
        const metadata = JSON.parse(readFileSync(file));
        if (metadata.name) {
          const targets = packages.get(metadata.name) ?? [];
          targets.push(directory);
          packages.set(metadata.name, targets);
        }
      }
    }
  }
  visit(directory);
  return packages;
}

export function installWasmDependencies(root, docx, sheets, sql, pdf) {
  const packages = findPackages(path.join(root, 'node_modules'));
  function replace(name, install) {
    const targets = packages.get(name);
    if (!targets?.length) throw new Error(`Missing locked WASM dependency: ${name}`);
    for (const target of targets) install(target);
  }
  for (const [name, source] of [['docx', docx], ['pptx', sheets], ['xlsx', sheets]]) {
    replace(`@betteroffice/${name}`, target => installOfficeSources(target, path.join(source, name)));
  }
  replace('sql.js', target => {
    rmSync(path.join(target, 'dist'), { recursive: true });
    cpSync(sql, path.join(target, 'dist'), { recursive: true });
  });
  replace('pdfjs-dist', target => {
    for (const name of ['build', 'legacy', 'wasm']) rmSync(path.join(target, name), { recursive: true, force: true });
    cpSync(pdf, target, { recursive: true });
  });
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href)
  installWasmDependencies(...process.argv.slice(2));
