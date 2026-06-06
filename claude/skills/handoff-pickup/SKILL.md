---
name: handoff-pickup
description: Resume work from a handoff document written by the handoff skill. Invoke on "/handoff-pickup", "pick up the handoff", or "resume the <name> handoff".
argument-hint: "Which handoff to pick up (filename or a description)"
---

# Pick up a handoff

When invoked:

1. Resolve the handoff directory `${TMPDIR:-/tmp}/claude-handoffs/`. If it does
   not exist or is empty, tell the user there are no handoffs and stop.
2. Select the handoff to resume:
   - If the user named a file or gave a description, match it against the
     `handoff-*.md` files. On an exact or single clear match, use it.
   - If nothing was passed, or several files match, list the candidates (as the
     `handoff-list` skill does) and ask the user which one before continuing.
3. Read the chosen document in full.
4. Invoke any skills listed in its "suggested skills" section.
5. Summarise the current state and the next steps back to the user, then
   continue the work described in the handoff.

Do not delete the handoff file unless the user asks.
