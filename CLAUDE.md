# CLAUDE.md

## Environment

- macOS, zsh
- Editor: vim
- Homebrew for packages

## Design principles

- Sparse over impressive. 10 aliases I use beats 100 I don't.
- No dependencies beyond standard Unix tools for core scripts.
- Re-run safety: setup scripts must be idempotent.
- Secrets stay out of this repo. Use `*.local` files (gitignored) sourced from main configs.
- One-line comment above any non-obvious alias or function.

## Not in scope

- Windows or PowerShell
- Cross-platform branching (Mac only)
- Plugin managers, dotfile frameworks (chezmoi, stow, yadm)
- Automated package installation (no Brewfile yet)

## When extending

Read existing files before suggesting changes. Prefer one clarifying question over guessing scope. Push back if something seems like cargo-culting.
