#!/usr/bin/env python3
"""PostToolUse[ExitPlanMode] hook: append an approved plan to the branch log."""
import json, sys, subprocess, os, pathlib, datetime

data = json.load(sys.stdin)
if data.get("tool_name") != "ExitPlanMode":
    sys.exit(0)

# NOTE: verify this field name — see Caveats. Print the payload once if unsure.
plan = (data.get("tool_input", {}).get("plan") or "").strip()
if not plan:
    sys.exit(0)

cwd = data.get("cwd", os.getcwd())
try:
    branch = subprocess.check_output(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"], cwd=cwd, text=True
    ).strip()
except Exception:
    sys.exit(0)

ddir = pathlib.Path(cwd) / ".decisions"
ddir.mkdir(exist_ok=True)
path = ddir / f"{branch.replace('/', '-')}.md"

stamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
with path.open("a") as f:
    f.write(f"\n## Plan approved — {stamp}\n\n{plan}\n")
