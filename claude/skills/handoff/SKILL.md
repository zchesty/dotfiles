---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save it to `${TMPDIR:-/tmp}/claude-handoffs/` (create the directory if missing) - not the current workspace. Name the file `handoff-<YYYY-MM-DD-HHMM>-<slug>.md`, where `<slug>` is a short kebab-case summary of the work. This shared directory is what the `handoff-list` and `handoff-pickup` skills read from.

Include a "suggested skills" section in the document, which suggests skills that the agent should invoke.

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.
