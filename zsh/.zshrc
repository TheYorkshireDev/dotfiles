# ── Oh My Zsh ──────────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # using Starship instead
plugins=(git macos z zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# ── Homebrew ───────────────────────────────────────────────────────────────────
# Apple Silicon
if [[ $(uname -m) == "arm64" ]] && [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
# Intel
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ── Starship prompt ────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── Path additions ─────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"

# ── Environment ────────────────────────────────────────────────────────────────
export EDITOR="vim"
export LANG="en_GB.UTF-8"

# ── Aliases ────────────────────────────────────────────────────────────────────
# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"

# Listing
alias ls="ls -G"
alias ll="ls -lAFh"
alias la="ls -A"

# Git shortcuts
alias g="git"
alias gs="git status -sb"
alias gp="git push"
alias gl="git pull"

# Homebrew
alias bu="brew update && brew upgrade && brew cleanup"

# Dotfiles
alias dotfiles="cd ~/.dotfiles"

# ── Local overrides ────────────────────────────────────────────────────────────
# Machine-specific config that isn't committed (tokens, work aliases, etc.)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
