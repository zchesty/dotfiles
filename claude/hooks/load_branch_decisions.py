#!/usr/bin/env python3
"""SessionStart hook: inject the current branch's decision log into context."""
import json, sys, subprocess, os, pathlib

data = json.load(sys.stdin)
cwd = data.get("cwd", os.getcwd())

try:
    branch = subprocess.check_output(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"], cwd=cwd, text=True
    ).strip()
except Exception:
    sys.exit(0)  # not a git repo; nothing to inject

path = pathlib.Path(cwd) / ".decisions" / f"{branch.replace('/', '-')}.md"
if not path.exists():
    sys.exit(0)  # new branch, no log yet

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": (
            f"# Decision log for branch `{branch}`\n\n{path.read_text()}"
        ),
    }
}))
