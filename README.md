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
