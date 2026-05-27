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
