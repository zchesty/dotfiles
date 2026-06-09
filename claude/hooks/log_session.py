#!/usr/bin/env python3
"""SessionEnd hook: append one line per session to ~/.claude/sessions.jsonl.

Each entry is {ts, session_id, cwd, branch, reason, duration_s, input_tokens,
output_tokens}. Duration and token totals are derived from the transcript,
best-effort: the transcript's line shapes vary across Claude Code versions, so
anything we cannot parse is simply omitted rather than failing the hook.

Query examples:
  jq -r 'select(.ts >= "2026-06-01") | .branch' ~/.claude/sessions.jsonl
  jq -s 'map(.output_tokens // 0) | add' ~/.claude/sessions.jsonl
"""
import json, sys, subprocess, os, pathlib, datetime

data = json.load(sys.stdin)
cwd = data.get("cwd", os.getcwd())

try:
    branch = subprocess.check_output(
        ["git", "rev-parse", "--abbrev-ref", "HEAD"],
        cwd=cwd, text=True, stderr=subprocess.DEVNULL,
    ).strip()
except Exception:
    branch = ""

entry = {
    "ts": datetime.datetime.now().strftime("%Y-%m-%dT%H:%M"),
    "session_id": data.get("session_id", ""),
    "cwd": cwd,
    "branch": branch,
    "reason": data.get("reason", ""),
}

transcript = data.get("transcript_path", "")
if transcript and os.path.exists(transcript):
    first = last = None
    tokens_in = tokens_out = 0
    with open(transcript) as f:
        for line in f:
            try:
                rec = json.loads(line)
            except ValueError:
                continue
            ts = rec.get("timestamp")
            if ts:
                first = first or ts
                last = ts
            usage = (rec.get("message") or {}).get("usage") or {}
            tokens_in += usage.get("input_tokens") or 0
            tokens_out += usage.get("output_tokens") or 0
    if first and last:
        try:
            parse = lambda s: datetime.datetime.fromisoformat(s.replace("Z", "+00:00"))
            entry["duration_s"] = int((parse(last) - parse(first)).total_seconds())
        except ValueError:
            pass
    entry["input_tokens"] = tokens_in
    entry["output_tokens"] = tokens_out

ledger = pathlib.Path.home() / ".claude" / "sessions.jsonl"
ledger.parent.mkdir(exist_ok=True)
with ledger.open("a") as f:
    f.write(json.dumps(entry) + "\n")
