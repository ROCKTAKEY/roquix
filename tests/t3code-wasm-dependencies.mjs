import assert from 'node:assert/strict';
import { test } from 'node:test';
import { mkdtempSync, mkdirSync, writeFileSync, readFileSync, existsSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { installOfficeSources } from '../channel/roquix/packages/aux-files/t3code-wasm-dependencies.mjs';

test('Office consumers resolve source code with its newly generated WASM bindings', () => {
  const root = mkdtempSync(path.join(tmpdir(), 't3code-wasm-'));
  const write = (file, data) => {
    mkdirSync(path.dirname(path.join(root, file)), { recursive: true });
    writeFileSync(path.join(root, file), data);
  };
  try {
    const manifest = { name: '@betteroffice/docx', version: '0.4.3',
      exports: { '.': { import: './dist/core.mjs', types: './dist/core.d.mts' } },
      main: './dist/core.mjs', dependencies: { peer: '1' } };
    write('target/package.json', JSON.stringify(manifest));
    write('source/package.json', JSON.stringify(manifest));
    write('target/dist/core.mjs', 'old bundled bindings');
    write('target/dist/generated/module.wasm', 'prebuilt');
    write('source/src/core.ts', "export { initSync } from './wasm/generated/module.js';");
    write('source/src/wasm/generated/module.js', 'new bindings');
    write('source/src/yrs/residentEngineWorker.ts', 'export {};');
    write('source/src/yrs/residentEngineWorkerClient.ts',
      "new Worker(new URL('./residentEngineWorker.mjs', import.meta.url));");
    write('source/shared/media.ts', 'export const limit = 42;');
    write('source/src/docx/media.ts', "export { limit } from '../../../../shared/media';");
    write('source/src/wasm/generated/module_bg.wasm', Buffer.from([0,97,115,109,1,0,0,0]));
    installOfficeSources(path.join(root, 'target'), path.join(root, 'source'));
    const installed = JSON.parse(readFileSync(path.join(root, 'target/package.json')));
    assert.equal(installed.exports['.'].import, './src/core.ts');
    assert.equal(installed.exports['.'].types, './src/core.ts');
    assert.deepEqual(installed.dependencies, { peer: '1' });
    assert.equal(readFileSync(path.join(root, 'target/src/wasm/generated/module.js'), 'utf8'), 'new bindings');
    assert.ok(!existsSync(path.join(root, 'target/dist')));
    assert.match(readFileSync(path.join(root, 'target/src/yrs/residentEngineWorkerClient.ts'), 'utf8'),
      /residentEngineWorker\.ts/);
    assert.equal(readFileSync(path.join(root, 'target/src/docx/media.ts'), 'utf8'),
      "export { limit } from '../../shared/media';");
    assert.ok(existsSync(path.join(root, 'target/shared/media.ts')));
  } finally { rmSync(root, { recursive: true, force: true }); }
});
