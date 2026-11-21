require(process.argv[2])().then(q => {
  const r = q._QTS_NewRuntime();
  if (!r) throw Error('QuickJS runtime');
  const c = q._QTS_NewContext(r);
  if (!c) throw Error('QuickJS context');
  q._QTS_FreeContext(c);
  q._QTS_FreeRuntime(r);
});
