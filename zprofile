# Homebrew (Apple Silicon): put brew and installed tools on PATH
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Machine-local overrides (gitignored)
[[ -f ~/.zprofile.local ]] && source ~/.zprofile.local
