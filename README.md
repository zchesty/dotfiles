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

`install.sh` also installs vim-plug and vim-go binaries (including `gopls`). Go must be installed and in `PATH` first for the vim-go step to run. It installs [`sandvault`](https://github.com/webcoyote/sandvault) via Homebrew (warn-and-continue if that fails).

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

## Sandvault

[Sandvault](https://github.com/webcoyote/sandvault) runs agents as a locked-down macOS user plus `sandbox-exec`, so you can run `sv claude` (Claude Code with `--dangerously-skip-permissions`) without it touching your real home directory.

`install.sh` syncs these dotfiles into the sandbox's shared workspace (`/Users/Shared/sv-$USER/user/`) so sandboxed sessions inherit your shell, git, and Claude config. The sandbox loads them via rsync + sourcing; `.zshrc`/`.zprofile` are sourced from the workspace, while `.gitconfig` and `.claude/` are copied into the sandbox home.

Notes:

- The workspace only exists after sandvault has built once. Run `sv build` (or any `sv` command) first, then re-run `install.sh` to sync.
- Inside the sandbox the prompt shows a red `🔒sv` badge (set in `zshrc` when `$USER` is `sandvault-*`).
- `gitconfig` carries `safe.directory` for the shared workspace, since our synced `.gitconfig` shadows the one sandvault would otherwise generate. Git identity comes from `~/.gitconfig.local`, which is synced too.
