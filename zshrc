export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.local/bin:$PATH"

# Machine-local overrides (gitignored)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
