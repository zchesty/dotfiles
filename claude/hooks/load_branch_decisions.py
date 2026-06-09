#!/usr/bin/env python3
"""SessionStart hook: inject the current branch's decision log into context.

Reads .decisions/log.jsonl (one JSON object per line, written by log_plan.py
and the log-decision skill), filters to the current branch, and renders a
markdown view. A legacy per-branch .decisions/<branch>.md from the old format
is included verbatim if present.
"""
import json, sys, subprocess, os, pathlib

data = json.load(sys.stdin)
cwd = data.get("cwd", os.getcwd())

try:
    branch = subprocess.check_output(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"], cwd=cwd, text=True
    ).strip()
except Exception:
    sys.exit(0)  # not a git repo; nothing to inject

ddir = pathlib.Path(cwd) / ".decisions"
sections = []

legacy = ddir / f"{branch.replace('/', '-')}.md"
if legacy.exists():
    sections.append(legacy.read_text().strip())

log = ddir / "log.jsonl"
if log.exists():
    for line in log.read_text().splitlines():
        try:
            e = json.loads(line)
        except ValueError:
            continue
        if e.get("branch") != branch:
            continue
        if e.get("type") == "plan":
            sections.append(f"## Plan approved — {e.get('ts', '')}\n\n{e.get('text', '')}")
        else:
            body = (
                f"## Decision — {e.get('ts', '')}\n"
                f"**What:** {e.get('what', '')}\n"
                f"**Why:** {e.get('why', '')}"
            )
            if e.get("alternatives"):
                body += f"\n**Alternatives:** {e['alternatives']}"
            sections.append(body)

if not sections:
    sys.exit(0)  # no log for this branch yet

print(json.dumps({
    "hookSpecificOutput": {
        "hookEventName": "SessionStart",
        "additionalContext": (
            f"# Decision log for branch `{branch}`\n\n" + "\n\n".join(sections)
        ),
    }
}))
