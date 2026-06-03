export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Flag the prompt when running inside the sandvault sandbox
if [[ "$USER" == sandvault-* ]]; then
  PROMPT="%F{red}🔒sv%f ${PROMPT}"
fi

export PATH="$HOME/.local/bin:$PATH"

# Machine-local overrides (gitignored)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
