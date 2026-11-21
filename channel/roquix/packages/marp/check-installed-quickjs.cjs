const assert = require('node:assert/strict');
const { createRequire } = require('node:module');
const load = createRequire(process.argv[2] + '/package.json');
(async () => {
  const qjs = await load('@tootallnate/quickjs-emscripten').getQuickJS();
  const context = qjs.newContext();
  const result = context.evalCode('6 * 7');
  assert.equal(context.dump(context.unwrapResult(result)), 42);
  result.value.dispose();
  context.dispose();
  const resolve = load('pac-resolver').createPacResolver(qjs,
    `function FindProxyForURL(url, host) {
      return dnsResolve(host) === '127.0.0.1' ? 'DIRECT' : 'PROXY proxy.test:8080';
    }`,
    { sandbox: { dnsResolve: async () => '127.0.0.1' } });
  assert.equal(await resolve('https://example.test/'), 'DIRECT');
})().catch(error => { console.error(error); process.exit(1); });
