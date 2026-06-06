---
name: log-decision
description: Record an ad-hoc decision (one made outside a formal plan) to the current git branch's decision log at .decisions/<branch>.md. Invoke on "/log-decision", "log this decision", or after settling a non-trivial choice that a future session should remember.
---

# Log a branch decision

When invoked:

1. Get the current branch: `git rev-parse --abbrev-ref HEAD`
2. Compute the path `.decisions/<branch>.md`, replacing any `/` in the branch
   name with `-`. Create the `.decisions/` directory if it does not exist.
3. Append a tight entry in this exact format:

   ## Decision — <YYYY-MM-DD HH:MM>
   **What:** one-line summary of the decision
   **Why:** short rationale
   **Alternatives:** what was considered and rejected, if any

Keep entries to a few lines. Do not duplicate a decision already present in the
file. After writing, confirm to the user exactly what was logged.
