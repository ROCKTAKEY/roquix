// Loader-utils' hash interface, using source JavaScript implementations.
const xxhash = require('xxhashjs');
const md4 = require('js-md4');

function streamingHash(state, finish) {
  return {
    update(data, encoding) {
      state.update(typeof data === 'string' ? Buffer.from(data, encoding) : data);
      return this;
    },
    digest(encoding) {
      const hex = finish(state);
      if (encoding === 'hex') return hex;
      const bytes = Buffer.from(hex, 'hex');
      return !encoding || encoding === 'binary' ? bytes : bytes.toString(encoding);
    },
  };
}

exports.createXxhash64 = () => streamingHash(xxhash.h64(0), h => h.digest().toString(16).padStart(16, '0'));
exports.createMd4 = () => streamingHash(md4.create(), h => h.hex());

if (require.main === module) {
  const assert = require('node:assert/strict');
  assert.equal(exports.createXxhash64().digest('hex'), 'ef46db3751d8e999');
  assert.equal(exports.createMd4().digest('hex'), '31d6cfe0d16ae931b73c59d7e0c089c0');
  assert.equal(exports.createMd4().update('a').update('bc').digest('hex'), 'a448017aaf21d8525fc10ae87aa6729d');
  assert.deepEqual(exports.createMd4().update('abc').digest(), Buffer.from('a448017aaf21d8525fc10ae87aa6729d', 'hex'));
}
