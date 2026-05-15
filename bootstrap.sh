#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

echo ""
echo "  macOS dotfiles bootstrap"
echo " =================================="
echo ""

# ── Homebrew ──────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    echo " Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo " Homebrew already installed."
fi

# Apple Silicon: ensure brew is on PATH for this session
if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Clone dotfiles ─────────────────────────────────────────────────────────────
if [ ! -d "$DOTFILES" ]; then
    echo " Cloning dotfiles..."
    git clone https://github.com/TheYorkshireDev/dotfiles "$DOTFILES"
else
    echo " Dotfiles already cloned. Pulling latest..."
    git -C "$DOTFILES" pull
fi

# ── Homebrew Bundle ───────────────────────────────────────────────────────────
echo " Installing packages from Brewfile..."
brew bundle --file="$DOTFILES/Brewfile" --no-upgrade

# ── macOS defaults ────────────────────────────────────────────────────────────
echo " Applying macOS defaults..."
bash "$DOTFILES/macos.sh"

# ── Stow dotfiles ─────────────────────────────────────────────────────────────
echo " Symlinking dotfiles with Stow..."
cd "$DOTFILES"
stow git
stow zsh
stow starship

# ── Git local identity ────────────────────────────────────────────────────────
if [ ! -f "$HOME/.gitconfig.local" ]; then
    echo ""
    echo " Git identity setup (stored in ~/.gitconfig.local, not committed)"
    read -rp "  Full name:  " git_name
    read -rp "  Email:      " git_email

    cat > "$HOME/.gitconfig.local" <<EOF
[user]
    name = $git_name
    email = $git_email
EOF
    echo " ~/.gitconfig.local created."
else
    echo " ~/.gitconfig.local already exists, skipping."
fi

echo ""
echo " Bootstrap complete. Restart your terminal."
echo ""