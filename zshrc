export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

export PATH="$HOME/.local/bin:$PATH"

# Claude permission-mode shortcuts (default is acceptEdits in settings)
alias claude-plan='claude --permission-mode plan'
alias claude-auto='claude --permission-mode auto'
alias claude-yolo='claude --permission-mode bypassPermissions'

# Claude model shortcuts (default is opus, set in Claude settings)
alias claude-sonnet='claude --model sonnet'
alias claude-opus='claude --model opus'
alias claude-haiku='claude --model haiku'

# Claude combined model + permission-mode shortcuts
alias claude-plan-sonnet='claude --model sonnet --permission-mode plan'
alias claude-yolo-haiku='claude --model haiku --permission-mode bypassPermissions'

# Claude workflow shortcuts
alias clauder='claude --resume'
# Continue the most recent session directly, skipping the --resume picker
alias claudec='claude --continue'
alias claudep='claude --print'
# Headless with a JSON envelope (result, cost, session_id) — pipe to jq
alias claudej='claude --print --output-format json'

# One-shot question, plain-text answer: ask "why does zsh do X"
ask() { claude --print --output-format json "$@" | jq -r '.result'; }

# Machine-local overrides (gitignored)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
