# dotfiles

Personal macOS dotfiles.

## What's here

| File | Installs to |
|---|---|
| `zshrc` | `~/.zshrc` |
| `zprofile` | `~/.zprofile` |
| `gitconfig` | `~/.gitconfig` |
| `gitignore` | `~/.gitignore` |
| `vimrc` | `~/.vimrc` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` |
| `claude/hooks/<name>` | `~/.claude/hooks/<name>` |
| `claude/skills/<name>/` | `~/.claude/skills/<name>/` |

## Install

```sh
git clone <repo> ~/Development/dotfiles
cd ~/Development/dotfiles
bash install.sh
```

`install.sh` also installs vim-plug and vim-go binaries (including `gopls`). Go must be installed and in `PATH` first for the vim-go step to run.

## Local overrides

Machine-specific config goes in gitignored `*.local` files:

- `~/.zshrc.local` — env vars, tool setup (NVM, Go, etc.)
- `~/.zprofile.local` — PATH additions (Sublime Text, etc.)
- `~/.gitconfig.local` — git identity (`[user]` name and email)
- `~/.claude/settings.local.json` — per-machine Claude permissions/env (gitignored by Claude; not symlinked)

## Claude Code

`claude/settings.json` sets up an agentic workflow:

- **Permissions** — auto-allows read-only git, `git add`/`commit`/`merge`/`rebase`/`push`, and the Go dev loop (`go build`/`test`/`vet`/`run`, `gofmt`). `defaultMode` is `acceptEdits` (file edits apply without a prompt).
- **Push guard** — a `git-push-guard.sh` PreToolUse hook hard-blocks `git push` to `main`/`master`; pushes to feature branches go through without a prompt.
- **Statusline** — `model effort · ±changes · branch · ctx%`, pure `sh` + `git` (no `jq`).

Global agent rules live in `claude/CLAUDE.md`. Since `settings.json` is symlinked, "always allow" choices and `/config` changes write back into this repo.

Each directory under `claude/skills/` is symlinked into `~/.claude/skills/`, so custom skills sync to every machine. `install.sh` links them individually (not the whole folder), so externally-installed skills can coexist there. Add a skill by dropping `claude/skills/<name>/SKILL.md` in and re-running `install.sh`. Hooks under `claude/hooks/` are linked the same way.

### Branch decision log

A per-git-branch "decision log" captures working context as a branch evolves and reloads it when a new session starts on that branch. Logs live at `<project>/.decisions/<branch>.md` (any `/` in the branch name becomes `-`), and `.decisions/` is in the global `gitignore` so it never has to be handled per-repo.

- **Resume** — a `SessionStart` hook (`hooks/load_branch_decisions.py`) injects the current branch's log into the new session's context.
- **Plan capture** — a `PostToolUse` hook on `ExitPlanMode` (`hooks/log_plan.py`) appends each approved plan, timestamped. No model action needed.
- **Ad-hoc capture** — the `log-decision` skill records a decision made outside a formal plan (`/log-decision` or "log this decision").

In a non-git directory the hooks no-op and write nothing.
