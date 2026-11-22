#!@python@
"""Connect the desktop bridge to the Hermes package selected by the profile."""

import json
import os
from pathlib import Path
import shutil
import sys


hermes = shutil.which("hermes")
if hermes and not os.environ.get("OMHER_HERMES_PYTHON"):
    runtime = Path(hermes).resolve().parents[1] / "lib" / "hermes"
    metadata = runtime / "pm-runtime.json"
    if metadata.is_file():
        os.environ["OMHER_HERMES_PYTHON"] = json.loads(metadata.read_text())["python"]
        os.environ["OMHER_HERMES_ROOT"] = str(runtime / "source")

os.environ["PATH"] = os.pathsep.join([os.environ.get("PATH") or os.defpath, "@host_tools@"])
os.execv("@executable@", ["omher", *sys.argv[1:]])
