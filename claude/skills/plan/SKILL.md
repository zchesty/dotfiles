---
name: plan
description: Run plan mode so every approved plan is captured to the decision log. Invoke on "/plan", when starting to plan an implementation, or any time you are working in plan mode. Enforces that approval flows through ExitPlanMode (the only event the log_plan.py capture hook can see).
---

# Plan-mode loop (capture-safe)

The `PostToolUse[ExitPlanMode]` hook (`log_plan.py`) appends the approved plan to
`.decisions/<branch>.md`. It fires **only on a successful `ExitPlanMode`**. There is
no event for a verbal "looks good", so any approval that skips `ExitPlanMode` is lost.
Follow this loop so capture is guaranteed.

When invoked:

1. **Plan.** Research as needed and write the plan to the plan file. Do not edit any
   other file, implement, or launch a background agent yet.

2. **Present only via `ExitPlanMode`.** When the plan is ready, call the `ExitPlanMode`
   tool. Never treat a typed "I approve / go ahead / looks good" as approval to start —
   that bypasses the hook. Approval counts only when the `ExitPlanMode` prompt is accepted.

3. **On feedback or rejection, loop back.** If the user rejects the prompt to give
   feedback, the plan is **not** captured yet. Revise the plan file and call
   `ExitPlanMode` again. The cycle MUST end with an **accepted** `ExitPlanMode` prompt
   before any work begins.

4. **Only after a successful `ExitPlanMode`:** implement, or delegate to a background
   agent. Approval first, work second — never bundle them. A background agent edits in
   its own context and never trips plan mode, so delegating before `ExitPlanMode` is the
   main way capture gets skipped.

5. **Verify.** After approval, confirm the entry landed in `.decisions/<branch>.md`. If
   it did not, the hook never fired — fall back to the `log-decision` skill to record it.
