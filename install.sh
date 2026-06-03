#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$DOTFILES/$1"
  local dst="$HOME/$2"

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "ok      $dst"
    return
  fi

  # Back up existing file
  if [[ -e "$dst" ]]; then
    mv "$dst" "${dst}.bak"
    echo "backed up ${dst} -> ${dst}.bak"
  fi

  ln -s "$src" "$dst"
  echo "linked  $dst -> $src"
}

link zshrc     .zshrc
link zprofile  .zprofile
link gitconfig .gitconfig
link gitignore .gitignore
link vimrc     .vimrc

mkdir -p "$HOME/.claude"
link claude/CLAUDE.md            .claude/CLAUDE.md
link claude/settings.json       .claude/settings.json
link claude/statusline-command.sh .claude/statusline-command.sh

# Install vim-plug if not already present
PLUG="$HOME/.vim/autoload/plug.vim"
if [[ ! -f "$PLUG" ]]; then
  curl -fLo "$PLUG" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "installed vim-plug"
else
  echo "ok      vim-plug"
fi

# Install vim plugins
vim +PlugInstall +qall
echo "ok      vim plugins"

# Install Go binaries (gopls etc.) — requires go in PATH
if command -v go &>/dev/null; then
  vim +GoInstallBinaries +qall
  echo "ok      vim-go binaries"
else
  echo "skip    vim-go binaries (go not in PATH)"
fi

# Install sandvault (sandboxed agent runner); never fail the whole install over it
if command -v sv &>/dev/null; then
  echo "ok      sandvault"
elif command -v brew &>/dev/null; then
  brew install sandvault && echo "installed sandvault" \
    || echo "warn    sandvault install failed; continuing"
else
  echo "skip    sandvault (brew not found)"
fi

# Sync dotfiles into the sandvault shared workspace so sandboxed sessions inherit them.
# The workspace exists only after sandvault has built (sv build / sv shell).
SV_USER="/Users/Shared/sv-${USER}/user"
if [[ -d "$SV_USER" && -w "$SV_USER" ]]; then
  cp zshrc     "$SV_USER/.zshrc"
  cp zprofile  "$SV_USER/.zprofile"
  cp gitconfig "$SV_USER/.gitconfig"
  cp vimrc     "$SV_USER/.vimrc"
  mkdir -p "$SV_USER/.claude"
  cp claude/CLAUDE.md claude/settings.json claude/statusline-command.sh "$SV_USER/.claude/"
  # Carry git identity so sandboxed commits work (sandvault skips its own gitconfig once ours exists)
  [[ -f "$HOME/.gitconfig.local" ]] && cp "$HOME/.gitconfig.local" "$SV_USER/.gitconfig.local"
  echo "synced  dotfiles -> $SV_USER"
else
  echo "skip    sandvault sync ($SV_USER missing; run 'sv build' first, then re-run)"
fi
