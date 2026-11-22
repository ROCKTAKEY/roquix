// xterm distributes the image addon's decoders inline in both JS entry points.
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { execFileSync } = require('node:child_process');
const { createHash } = require('node:crypto');
const ts = require(path.resolve('node_modules/typescript'));
const [parts, sixel, clang, linker] = process.argv.slice(2);

function compile(source, options, exports) {
  execFileSync(clang, ['--target=wasm32', '-B' + path.dirname(linker), '-nostdlib',
    '-O3', '-Wl,--no-entry', '-Wl,--strip-all', ...options,
    ...exports.map(name => '-Wl,--export=' + name), source, '-o', 'decoder.wasm']);
  return fs.readFileSync('decoder.wasm').toString('base64');
}

function compilePart(file) {
  // InWasm receives C after TypeScript expands the decoder's enum constants.
  const source = fs.readFileSync(path.join(parts, 'src', file), 'utf8');
  const js = ts.transpileModule(source, {
    compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022 }
  }).outputText;
  let moduleBytes;
  const runtime = {
    OutputType: {}, OutputMode: {},
    InWasm(config) {
      fs.writeFileSync('decoder.c', config.code);
      moduleBytes = compile('decoder.c', ['-Wl,--import-memory', ...config.compile.switches],
        Object.keys(config.exports));
    }
  };
  vm.runInNewContext(js, { exports: {}, require: () => runtime });
  return moduleBytes;
}

const replacements = new Map([
  ['9d51f9d779f0befd15c725ebc106440a47f92d9491d6167c5313f16f1989b000',
    compilePart('base64/Base64Decoder.wasm.ts')],
  ['70d9854636966d7461d214043f9d4d7a0fed22bdc7299793cea8bb28a6f992b1',
    compilePart('qoi/QoiDecoder.wasm.ts')],
  ['e7d165ec4489a102f0a3d50fe9d97d2061565516a3741a52421ce3474e82969c',
    compile(path.join(sixel, 'wasm/decoder.cpp'), ['-mbulk-memory',
      '-DCHUNK_SIZE=16384', '-DPALETTE_SIZE=4096', '-DMAX_WIDTH=16384',
      '-Wl,--allow-undefined', '-Wl,-z,stack-size=0', '-Wl,--initial-memory=458752',
      '-Wl,--max-memory=458752'], ['init', 'decode', 'current_width', 'current_height',
      'get_state_address', 'get_chunk_address', 'get_p0_address', 'get_palette_address'])]
]);

for (const ext of ['mjs', 'js']) {
  const file = 'node_modules/@xterm/addon-image/lib/addon-image.' + ext;
  const seen = new Set();
  const js = fs.readFileSync(file, 'utf8').replace(/AGFzbQ[A-Za-z0-9+/=]+/g, bytes => {
    const hash = createHash('sha256').update(Buffer.from(bytes, 'base64')).digest('hex');
    if (!replacements.has(hash)) throw new Error('Unknown image codec in ' + file);
    seen.add(hash);
    return replacements.get(hash);
  });
  if (seen.size !== replacements.size) throw new Error('Missing image codec in ' + file);
  fs.writeFileSync(file, js);
}
