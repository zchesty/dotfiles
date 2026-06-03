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

- **Permissions** — auto-allows read-only git, `git add`/`commit`/`merge`/`rebase`, and the Go dev loop (`go build`/`test`/`vet`/`run`, `gofmt`). Denies `git push`. `defaultMode` is `acceptEdits` (file edits apply without a prompt).
- **Statusline** — `model effort · ±changes · branch · ctx%`, pure `sh` + `git` (no `jq`).

Global agent rules live in `claude/CLAUDE.md`. Since `settings.json` is symlinked, "always allow" choices and `/config` changes write back into this repo.
