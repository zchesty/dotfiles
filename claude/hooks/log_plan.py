#!/usr/bin/env python3
"""PostToolUse[ExitPlanMode] hook: append an approved plan to the branch log.

Where the plan text lives in the hook payload has changed across Claude Code
versions: older builds passed it inline as tool_input["plan"], while newer
builds have ExitPlanMode read the plan from a separate plan file. We try the
known inline locations; if none carries the text this version no-ops rather
than writing an empty entry.

To pin down the field on a given machine, set LOG_PLAN_DEBUG=1 and approve one
plan: the full raw payload is written to .decisions/.last_plan_payload.json so
the correct field can be identified and wired in here.
"""
import json, sys, subprocess, os, pathlib, datetime

data = json.load(sys.stdin)
if data.get("tool_name") != "ExitPlanMode":
    sys.exit(0)

cwd = data.get("cwd", os.getcwd())

# Diagnostic: dump the untouched payload so the plan's real location is visible.
if os.environ.get("LOG_PLAN_DEBUG"):
    dbg = pathlib.Path(cwd) / ".decisions"
    dbg.mkdir(exist_ok=True)
    (dbg / ".last_plan_payload.json").write_text(json.dumps(data, indent=2))


def find_plan(d):
    """Return the plan text, only from fields explicitly named ``plan``.

    We deliberately avoid generic fields (a bare ``tool_response`` string, or
    keys like ``content``/``text``): on current versions ``tool_response`` is
    an approval acknowledgment, not the plan, and capturing it would log
    garbage. Once LOG_PLAN_DEBUG reveals this version's real field, wire it in
    here.
    """
    ti = d.get("tool_input")
    if isinstance(ti, dict) and isinstance(ti.get("plan"), str) and ti["plan"].strip():
        return ti["plan"]
    resp = d.get("tool_response")
    if isinstance(resp, dict) and isinstance(resp.get("plan"), str) and resp["plan"].strip():
        return resp["plan"]
    return ""


plan = find_plan(data).strip()
if not plan:
    sys.exit(0)

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
