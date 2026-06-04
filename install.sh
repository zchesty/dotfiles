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
link claude/git-push-guard.sh     .claude/git-push-guard.sh

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
