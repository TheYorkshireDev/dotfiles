#!/usr/bin/env bash

echo " Applying macOS defaults..."

# ── UI ─────────────────────────────────────────────────────────────────────────
defaults write com.apple.menuextra.battery ShowPercent -bool true
defaults write com.apple.menuextra.battery ShowTime -bool true

# ── Dock ───────────────────────────────────────────────────────────────────────
defaults write com.apple.dock show-recents -bool false

# ── Finder ─────────────────────────────────────────────────────────────────────
echo "  Finder: show hidden files"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "  Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "  Finder: set Desktop as default location for new windows"
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

echo "  Finder: display full POSIX path in window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "  Finder: keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true

echo "  Finder: use current directory as default search scope"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "  Finder: show Path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "  Finder: show Status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "  Finder: expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "  Finder: expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# ── Login window ───────────────────────────────────────────────────────────────
echo "  Login window: show IP address, hostname, and OS version when clicking the clock"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# ── Text input ─────────────────────────────────────────────────────────────────
echo "  Text: disable automatic capitalisation"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo "  Text: disable smart dashes"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "  Text: disable automatic period substitution"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

echo "  Text: disable smart quotes"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo "  Text: disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ── Usability ──────────────────────────────────────────────────────────────────
echo "  Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "  Avoid creating .DS_Store files on USB volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ── Security ───────────────────────────────────────────────────────────────────
echo "  Require password immediately after sleep or screen saver"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# ── Apply changes ──────────────────────────────────────────────────────────────
killall Finder
killall Dock
killall SystemUIServer

echo " macOS defaults applied."