# Global Claude Rules

Apply everywhere. A repo's own CLAUDE.md overrides and extends these.

## Working style

- Do not be creative. Follow the user's direction and let them drive creative decisions.
- Prefer one clarifying question over guessing scope.
- Re-read files after each new prompt; keep edits the user made by hand.
- Before overwriting something you may not hold the latest copy of — a file, a PR description, an issue body — re-fetch it first and check whether I changed it since you last read it. If I did, fold my changes in rather than clobbering them.
- Keep the diff small. For bug fixes, change the fewest lines that solve the problem.
- Follow YAGNI and DRY. Inline variables and helpers used only once.
- Match the surrounding code's style, naming, and comment density.
- Prefer self-documenting code to comments, but never delete existing comments.

## Planning

- Surface the simplest sufficient approach and recommend it. When an insight relaxes a constraint, re-check whether the rest of the design is still needed before committing to it.
- For non-trivial changes — refactors, cross-file moves, renames, type placement — show short before/after snippets with file-path markers (`// pchandlers/foo.go (AFTER)`) and the resulting payload shape, not just prose.
- Mark any step with an outward-facing side-effect as "checkpoint — do not run automatically."

## Outward-facing actions are mine

Anything that reaches a person or an external system is mine to send. Draft it, show it, wait.

- Never reply to PR review comments or post any message under my identity on your own initiative. Make the code changes, report what you changed, and let me respond.
- Never @-tag anyone in a PR title or description. Reference the work instead — PR number, ticket, the prior PR that caused the problem. If someone's input is what's needed, say so in chat and let me route it.
- Postman edits, Jira ticket creation (especially follow-up tickets), Confluence pages, Slack messages: draft, surface, and wait for confirmation before the call.
- Never `kubectl exec`, port-forward, or otherwise touch a live cluster or running prod/staging service without explicit permission — and don't propose verification steps that require it. Write up the exact commands for me to run instead.

## Editing external artifacts

- Re-fetch the artifact's current version immediately before **every** update call, not once per task. "I just wrote this version" is not "this is the current version."
- The fetch and the write must be adjacent tool calls in the same turn. Any drafting, discussion, or question in between reopens the staleness window — I edit these while we talk.
- If it moved, diff and fold my changes in before pushing.

## PRs and comments

- Open PRs as draft (`gh pr create --draft`).
- Keep the description concise — no fluff, no filler sentences, no tangents. Deeper "how to review / why" context goes in a committed `.md` in the diff; the description stays short.
- Keep in-code comments terse — one or two lines, ticket ref plus the essential why. Detailed rationale, alternatives, and context belong in the PR description or the committed doc, not inline.

## Git

- Never commit directly to a default branch (main/master). Branch off origin/HEAD first with a descriptive name.
- Pushing to a feature branch is fine; never `git push` to `main`/`master` (a hook enforces this).
- Do not amend commits unless I explicitly ask. Make follow-up changes as new commits so I can review each one; amending rewrites history and can lose work.
- Commit messages: imperative subject under ~50 chars, wrap files and identifiers in backticks, say why over what.
- Never put `| tail`/`| head` on the left of `&&` when the right side is destructive (`reset --hard`, `clean -f`, `checkout -f`). The pipe's exit code masks git's failure, so the destructive step runs anyway. Check the raw exit first (`git checkout X || exit 1`) or run the steps separately and read each result.

## Verification

- Never push a blind fix to turn CI green. Pull the real failing log first, then fix what it says.
- Verify exit codes, not the absence of the word "error". A linter or analyzer that fails on warnings and help messages has not passed just because there are zero errors.
- Don't assume the surrounding code is the pattern to copy — existing violations are often baselined or grandfathered.

## Harness

- Auto-memory is keyed by launch cwd, so anything written from one directory is invisible from another. Durable preferences belong in this file; repo-specific personal notes belong in that repo's `CLAUDE.local.md`.
- `settings.json` resolves from the launch cwd with no parent fallback (`settings.local.json` does aggregate up), and subagent discovery walks up from cwd but never descends. So launch monorepo work from the repo root with `--add-dir <pkg>` — never by `cd`-ing into the package, and never from `~/repos`, or the repo's deny list, ask gates, and hooks silently vanish.
