#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

echo ""
echo "  macOS dotfiles bootstrap"
echo "=================================="
echo ""

# Homebrew
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

# Clone dotfiles
if [ ! -d "$DOTFILES" ]; then
    echo " Cloning dotfiles..."
    git clone https://github.com/TheYorkshireDev/dotfiles "$DOTFILES"
else
    echo " Dotfiles already cloned. Pulling latest..."
    git -C "$DOTFILES" pull
fi

# Homebrew Bundle
echo " Installing packages from Brewfile..."
brew bundle --file="$DOTFILES/Brewfile" --no-upgrade

# Logitech Options+
# Installed separately from the Brewfile due to a known SIP conflict where
# Homebrew's post-install chown step fails on the signed .app bundle.
# --no-quarantine bypasses the postflight ownership change that triggers the error.
# See: https://github.com/Homebrew/homebrew-cask/issues/187722
echo " Installing Logitech Options+..."
if [ -d "/Applications/logioptionsplus.app" ]; then
    echo " Logitech Options+ already installed, skipping."
else
    brew install --cask --no-quarantine logi-options+ || {
        echo " Logitech Options+ install encountered errors (likely SIP/chown)."
        echo " The app should still be usable — reboot if it doesn't open."
    }
fi

# macOS defaults
echo " Applying macOS defaults..."
bash "$DOTFILES/macos.sh"

# Firefox extensions
echo " Installing Firefox extensions via enterprise policy..."
FIREFOX_DISTRIBUTION="/Applications/Firefox.app/Contents/Resources/distribution"
if [ -d "/Applications/Firefox.app" ]; then
    mkdir -p "$FIREFOX_DISTRIBUTION"
    cp "$DOTFILES/firefox/policies.json" "$FIREFOX_DISTRIBUTION/policies.json"
    echo " Firefox policies.json written. Extensions will install on first launch."
else
    echo " Firefox not found, skipping. Run bootstrap again after installing Firefox."
fi

# VS Code extensions
echo " Installing VS Code extensions..."
if command -v code &>/dev/null; then
    installed=$(code --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')
    while IFS= read -r extension; do
        [[ -z "$extension" || "$extension" == \#* ]] && continue
        if echo "$installed" | grep -qi "^${extension}$"; then
            echo "  VSCODE => $extension already installed."
        else
            code --install-extension "$extension" --force
        fi
    done < "$DOTFILES/vscode/extensions.txt"
else
    echo " VS Code 'code' CLI not found, skipping. Ensure 'code' is in PATH and re-run."
fi

# Stow dotfiles
echo " Symlinking dotfiles with Stow..."
cd "$DOTFILES"
stow git
stow zsh
stow starship

# Git local identity
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
echo " Bootstrap complete. Reboot recommended (required for Logitech Options+)."
echo ""