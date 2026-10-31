const assert = require("node:assert/strict");
const { readdirSync, writeFileSync } = require("node:fs");
const path = require("node:path");
const { pathToFileURL } = require("node:url");
const { app, BrowserWindow } = require("electron");

function measureCodeGlyphs() {
  const sample = document.querySelector("code");
  return ["", "monospace"].map((override) => {
    sample.style.fontFamily = override;
    const family = getComputedStyle(sample).fontFamily;
    sample.textContent = "iiiiiiii";
    const narrow = sample.getBoundingClientRect().width;
    sample.textContent = "WWWWWWWW";
    const wide = sample.getBoundingClientRect().width;
    return { family, narrow, wide };
  });
}

app.whenReady().then(async () => {
  const assets = path.join(
    process.argv.at(-1), "lib/t3code/resources/app/apps/server/dist/client/assets"
  );
  const stylesheets = readdirSync(assets).filter((file) => file.endsWith(".css"));
  assert.ok(stylesheets.length > 0, "the installed renderer has stylesheets");
  const html = path.join(__dirname, "code-font.html");
  writeFileSync(html, [
    "<!doctype html><html><head>",
    ...stylesheets.map((file) =>
      `<link rel="stylesheet" href="${pathToFileURL(path.join(assets, file)).href}">`
    ),
    "</head><body>",
    '<code class="font-mono" style="position:absolute;white-space:pre;font-size:32px"></code>',
    "</body></html>",
  ].join("\n"));

  const window = new BrowserWindow({ show: false, webPreferences: { sandbox: true } });
  await window.loadFile(html);
  const metrics = await window.webContents.executeJavaScript(`(${measureCodeGlyphs})()`);
  // Fontconfig matching alone cannot prove which face Chromium renders.
  assert.ok(metrics.every(({ narrow, wide }) => narrow > 0 && Math.abs(narrow - wide) < 0.01),
    `code glyphs must have equal advance widths: ${JSON.stringify(metrics)}`);
  process.stdout.write("code-font-contract-ok");
  app.quit();
}).catch((error) => {
  console.error(error);
  app.exit(1);
});
