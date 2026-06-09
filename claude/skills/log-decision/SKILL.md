---
name: log-decision
description: Record an ad-hoc decision (one made outside a formal plan) to the decision log at .decisions/log.jsonl. Invoke on "/log-decision", "log this decision", or after settling a non-trivial choice that a future session should remember.
---

# Log a branch decision

When invoked:

1. Get the current branch: `git rev-parse --abbrev-ref HEAD`
2. Create the `.decisions/` directory if it does not exist.
3. Append one JSON object as a single line to `.decisions/log.jsonl`, in this
   exact shape:

   {"ts":"<YYYY-MM-DDTHH:MM>","branch":"<branch>","type":"decision","what":"one-line summary","why":"short rationale","alternatives":"what was considered and rejected"}

   Omit the `alternatives` key entirely if nothing else was considered.

Keep values to one line each. Do not duplicate a decision already present in
the log. After writing, confirm to the user exactly what was logged.
