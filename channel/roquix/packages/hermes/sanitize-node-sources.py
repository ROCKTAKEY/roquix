"""Keep npm source inputs free of platform binaries and precompiled WASM."""
import re
import base64
import hashlib
from pathlib import Path
import sys

MAGIC = {b'\x7fELF', b'\0asm', b'\xcf\xfa\xed\xfe', b'\xce\xfa\xed\xfe',
         b'\xfe\xed\xfa\xcf', b'\xfe\xed\xfa\xce', b'\xca\xfe\xba\xbe'}

def binary(path):
    with path.open('rb') as stream:
        header = stream.read(4)
    return header in MAGIC or header[:2] == b'MZ'


def replace_embedded_wasm(path, root):
    text = path.read_text(errors='strict')
    if not re.search(r'AGFzbQ[A-Za-z0-9+/=]{20,}', text):
        return
    name = path.relative_to(root).as_posix()
    unused = ('/undici/lib/llhttp/', '/postject/', '/three/examples/',
              '/@shikijs/engine-oniguruma/dist/wasm-inlined.mjs', '/prettier/plugins/flow.', '/tsx/dist/lexer-', '/@vitest/mocker/')
    if any(part in '/' + name for part in unused) or path.name == 'yoga-wasm-base64-esm.js':
        path.unlink()
        return
    if name.endswith('/vite/dist/node/chunks/build.js'):
        for algorithm in ('xxhash64', 'md4'):
            pattern = (r'//#region [^\n]*loader-utils[^\n]*/' + algorithm +
                       r'\.js\n.*?//#endregion')
            replacement = ('var require_' + algorithm + ' = () => __hermesHashes.' +
                           ('createXxhash64' if algorithm == 'xxhash64' else 'createMd4') + ';')
            text, count = re.subn(pattern, replacement, text, flags=re.S)
            if count != 1:
                raise ValueError(f'changed Vite hash wrapper: {algorithm}')
        text = "import __hermesHashes from 'hermes-source-hashes';\n" + text
    else:
        markers = {'04270c743e88': 'HERMES_SOURCE_LEXER_FULL',
                   '44c8677a6404': 'HERMES_SOURCE_LEXER_MINIMAL'}
        def replace(match):
            digest = hashlib.sha256(base64.b64decode(match[0])).hexdigest()[:12]
            if digest not in markers:
                raise ValueError(f'unclassified embedded WASM: {name}: {digest}')
            return markers[digest]
        text = re.sub(r'AGFzbQ[A-Za-z0-9+/=]{20,}', replace, text)
    path.write_text(text)


def sanitize(root):
    for path in root.rglob('*'):
        if not path.is_file() or path.is_symlink():
            continue
        if binary(path):
            path.unlink()
        elif path.suffix in {'.js', '.mjs', '.cjs'}:
            replace_embedded_wasm(path, root)
    # Streamdown already selects Shiki's JavaScript regex engine. Select it for
    # Shiki's default bundle as well, so bundlers never embed the WASM fallback.
    for path in root.glob('**/shiki/dist/bundle-*.mjs'):
        text = path.read_text()
        if 'createOnigurumaEngine' not in text:
            continue
        text = re.sub(r'^import .*engine.oniguruma.*;\n', '', text, flags=re.M)
        text = re.sub(r'engine: \(\) => .*createOnigurumaEngine.*',
                      'engine: () => createJavaScriptRegexEngine({ forgiving: true })', text)
        path.write_text("import { createJavaScriptRegexEngine } from '@shikijs/engine-javascript';\n" + text)
    for path in root.glob('**/@shikijs/engine-oniguruma/dist/wasm-inlined.mjs'):
        path.unlink()


if __name__ == '__main__':
    sanitize(Path(sys.argv[1]))
