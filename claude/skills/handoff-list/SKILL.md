---
name: handoff-list
description: List the handoff documents written by the handoff skill so the user can choose one to resume. Invoke on "/handoff-list", "list handoffs", or "what handoffs are there".
---

# List handoff documents

When invoked:

1. Resolve the handoff directory `~/.claude/handoffs/`. If it does not exist or
   is empty, also check the legacy location `${TMPDIR:-/tmp}/claude-handoffs/`;
   if both are empty, tell the user there are no handoffs and stop.
2. List the `handoff-*.md` files, newest first.
3. For each, show a tight one-line entry built from the YAML front matter:
   filename, `date`, `branch`, and `title`. For older handoffs without front
   matter, fall back to the modified time and first heading.

Do not open or act on any handoff — this skill only lists. To resume one, point
the user at the `handoff-pickup` skill.
