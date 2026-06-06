#!/usr/bin/env python3
"""Claude Code statusline: Opus · dotfiles · branch · ±Nf · ctx 8% · 16.7k · $0.01 · 12m"""
import json, os, subprocess, sys

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

# Resolve working directory from payload, falling back to process cwd.
cwd = (data.get("workspace") or {}).get("current_dir") or data.get("cwd") or os.getcwd()

def git(*args):
    """Run git with -C <cwd>; return stdout stripped, or '' on any error."""
    try:
        return subprocess.check_output(["git", "-C", cwd] + list(args),
                                       stderr=subprocess.DEVNULL, text=True).strip()
    except Exception:
        return ""

branch = git("branch", "--show-current")
# Count non-empty lines from `git status --short` as files changed.
status_out = git("status", "--short")
changes = sum(1 for line in status_out.splitlines() if line.strip()) if status_out else 0

def fmt_tokens(n):
    return f"{n/1000:.1f}k" if n >= 1000 else str(n)

def fmt_duration(ms):
    s = int(ms / 1000)
    if s < 60:
        return f"{s}s"
    m = s // 60
    if m < 60:
        return f"{m}m"
    h, rm = divmod(m, 60)
    return f"{h}h{rm:02d}m"

green  = "\033[32m"; blue   = "\033[34m"
yellow = "\033[33m"; cyan   = "\033[36m"; reset = "\033[0m"

parts = []
def add(s): parts.append(s)

model_name = (data.get("model") or {}).get("display_name", "")
if model_name:
    add(f"{yellow}{model_name}{reset}")

# Directory: basename of the resolved cwd.
dirname = os.path.basename(cwd.rstrip("/"))
if dirname:
    add(f"{cyan}{dirname}{reset}")

if branch:
    add(f"{green}{branch}{reset}")

if changes > 0:
    add(f"{blue}±{changes}f{reset}")

ctx = (data.get("context_window") or {})
used_pct = ctx.get("used_percentage")
if used_pct is not None:
    add(f"{yellow}ctx {int(used_pct)}%{reset}")

total_tokens = ctx.get("total_input_tokens", 0) + ctx.get("total_output_tokens", 0)
if total_tokens:
    add(fmt_tokens(total_tokens))

cost_block = data.get("cost") or {}
usd = cost_block.get("total_cost_usd", 0)
if usd:
    add(f"${usd:.2f}")

ms = cost_block.get("total_duration_ms", 0)
if ms:
    add(fmt_duration(ms))

print(" · ".join(parts))
