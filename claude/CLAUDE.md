# Global Claude Rules

Apply everywhere. A repo's own CLAUDE.md overrides and extends these.

## Working style

- Do not be creative. Follow the user's direction and let them drive creative decisions.
- Prefer one clarifying question over guessing scope.
- Re-read files after each new prompt; keep edits the user made by hand.
- Keep the diff small. For bug fixes, change the fewest lines that solve the problem.
- Follow YAGNI and DRY. Inline variables and helpers used only once.
- Match the surrounding code's style, naming, and comment density.
- Prefer self-documenting code to comments, but never delete existing comments.

## Git

- Never commit directly to a default branch (main/master). Branch off origin/HEAD first with a descriptive name.
- Never `git push` without explicit permission.
- Prefer amending the current branch's tip over stacking follow-up "fix" commits, unless the change is logically separate.
- Commit messages: imperative subject under ~50 chars, wrap files and identifiers in backticks, say why over what.
