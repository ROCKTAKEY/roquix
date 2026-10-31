"""Insert only WASM built from declared source inputs into the JS wrappers."""
import base64
from pathlib import Path
import sys

root = Path(sys.argv[1])
full = base64.b64encode(Path(sys.argv[2], 'lexer.wasm').read_bytes()).decode()
minimal = base64.b64encode(Path(sys.argv[2], 'lexer.min.wasm').read_bytes()).decode()
count = 0
for path in root.rglob('*'):
    if path.is_file() and not path.is_symlink() and path.suffix in {'.js', '.mjs', '.cjs'}:
        text = path.read_text()
        if 'HERMES_SOURCE_LEXER_' in text:
            text = text.replace('HERMES_SOURCE_LEXER_FULL', full).replace('HERMES_SOURCE_LEXER_MINIMAL', minimal)
            path.write_text(text)
            count += 1
if count != 5:
    raise ValueError(f'expected five lexer wrappers, found {count}')
