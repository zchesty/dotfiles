---
name: handoff-list
description: List the handoff documents written by the handoff skill so the user can choose one to resume. Invoke on "/handoff-list", "list handoffs", or "what handoffs are there".
---

# List handoff documents

When invoked:

1. Resolve the handoff directory `${TMPDIR:-/tmp}/claude-handoffs/`. If it does
   not exist or is empty, tell the user there are no handoffs and stop.
2. List the `handoff-*.md` files, newest first.
3. For each, show a tight one-line entry: the filename, its modified time, and
   the first heading or summary line from the document so the user can tell them
   apart.

Do not open or act on any handoff — this skill only lists. To resume one, point
the user at the `handoff-pickup` skill.
