# dotfiles

Personal macOS configuration and setup scripts for automating a new Mac from scratch. Managed with [GNU Stow](https://www.gnu.org/software/stow/) for dotfile symlinking and [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) for package management.

## What's included

| File / Folder | Purpose |
|---|---|
| `bootstrap.sh` | Entry point — installs Homebrew, clones repo, runs everything |
| `Brewfile` | All CLI tools, apps (casks), and Mac App Store installs |
| `macos.sh` | macOS system defaults (Finder, Dock, security, usability) |
| `git/.gitconfig` | Git behaviour config (identity loaded from `~/.gitconfig.local`) |
| `zsh/.zshrc` | Zsh shell config, aliases, and PATH |
| `starship/.config/starship.toml` | [Starship](https://starship.rs) prompt config |

## New Mac setup

### One-liner bootstrap

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/TheYorkshireDev/dotfiles/main/bootstrap.sh)"
```

This will:
1. Install Homebrew (if not present)
2. Clone this repo to `~/.dotfiles`
3. Install everything in the `Brewfile`
4. Apply macOS system defaults via `macos.sh`
5. Symlink all dotfiles via GNU Stow
6. Prompt you to create `~/.gitconfig.local` with your identity

### Manual setup

If you'd prefer to run steps individually:

```bash
# 1. Clone the repo
git clone https://github.com/TheYorkshireDev/dotfiles ~/.dotfiles
cd ~/.dotfiles

# 2. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Install all packages
brew bundle --file=~/.dotfiles/Brewfile

# 4. Apply macOS defaults (log out/in after for full effect)
bash ~/.dotfiles/macos.sh

# 5. Symlink dotfiles
cd ~/.dotfiles
stow git zsh starship

# 6. Create your local git identity (not committed)
touch ~/.gitconfig.local
```

Then add to `~/.gitconfig.local`:
```ini
[user]
    name = Your Name
    email = your@email.com
```

## How Stow works

Each top-level folder is a **package**. Stow mirrors its contents into your home directory as symlinks:

```
~/.dotfiles/zsh/.zshrc        →  ~/.zshrc
~/.dotfiles/git/.gitconfig    →  ~/.gitconfig
~/.dotfiles/starship/.config/starship.toml  →  ~/.config/starship.toml
```

To add a new dotfile to the repo:

```bash
mv ~/.some-config ~/.dotfiles/packagename/.some-config
cd ~/.dotfiles
stow packagename
```

To remove symlinks without deleting files:

```bash
stow -D packagename
```

## Daily workflow

Changes are just normal Git — edit any file directly in `~/.dotfiles`, then commit and push:

```bash
vim ~/.dotfiles/zsh/.zshrc
cd ~/.dotfiles
git add -A
git commit -m "add ll alias"
git push
```

On any new machine, `bootstrap.sh` gets you back to this exact state.

## What is NOT in this repo

- `~/.gitconfig.local` — your git identity (name + email). Created locally, never committed.
- SSH keys — managed separately (recommended: [1Password SSH agent](https://developer.1password.com/docs/ssh/))
- API tokens or secrets — use environment variables or a secrets manager

## Apps installed

### CLI tools (brew)
`awscli` · `azure-cli` · `git` · `gnupg` · `go` · `node` · `terraform` · `starship` · `mas` · `stow`

### Applications (cask)
`dashlane` · `keepassxc` · `firefox` · `google-chrome` · `fork` · `microsoft-office` · `sketch` · `visual-studio-code` · `gpg-suite` · `docker`

### Mac App Store
`Xcode`
