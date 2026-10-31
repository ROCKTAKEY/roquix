"""Use Hermes's Python API to generate its entry points and project metadata."""
from pathlib import Path
import sys

sys.dont_write_bytecode = True
out = Path(sys.argv[1])
repo = out / "lib/hermes/source"
sys.path.insert(0, str(repo))
from scripts.build.agent import write_metadata
from scripts.build.inputs import project_entries
from scripts.build.launchers import write_launchers

project = repo / "pyproject.toml"
write_metadata(project, repo)
write_launchers(out, project_entries(project), python=sys.argv[2], repo=str(repo),
                site=str(out / "lib/hermes/site-packages"), target="linux-x64")
