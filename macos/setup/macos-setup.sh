#!/usr/bin/env bash
set -euo pipefail

## !BEFORE RUNNING THIS SCRIPT!
## Ensure that macOS is up-to-date

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install brew bundle
# brew bundle install --file <path-to-Brewfile>

# Zsh: Oh-My-Zsh plugins
#   Install Oh-My-Zsh (https://github.com/ohmyzsh/ohmyzsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#   zsh-syntax-highlighting plugin (https://github.com/zsh-users/zsh-syntax-highlighting/)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
#   zsh-autosuggestions plugin (https://github.com/zsh-users/zsh-autosuggestions/)
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
#   Prompt: starship is installed via Homebrew (brew install starship);
#   config lives at ~/.config/starship.toml.
#   Optional: zig-shell-completions plugin (https://codeberg.org/ziglang/shell-completions)
git clone https://codeberg.org/ziglang/shell-completions.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zig-shell-completions"

# tmux: tmux plugin manager (https://github.com/tmux-plugins/tpm)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  # Then setup tmux plugins with <prefix> + I

# Install dev tooling with mise
cd ~ && mise install
#   This should install everything according according to ~/.config/mise/config.toml

# Install preferred python with uv and create symlinks
# ln -s ~/.local/bin/python3.14 ~/.local/bin/python3
# ln -s ~/.local/bin/python3.14 ~/.local/bin/python

# nvim
# Should be handled by symlinks, just launch and load with :Lazy

# jankyborders
brew services start borders

# pi coding agent config
#  go into the repo to initialize additional stuff
git clone git@github.com:emmaneugene/pi.git ~/.pi

# codex coding agent config
git clone git@github.com:emmaneugene/codex.git ~/.codex

# claude code config
git clone git@github.com:emmaneugene/claude.git ~/.claude

## Software configuration

# Setup and sync Internet accounts

# Finder (Favorites, metadata)

# Control centre (widgets and arrangement)

# Notification centre (widgets and arrangement)

# Karabiner (check symlink, permissions, login item)

# Hammerspoon (check symlink, permissions, login item)

# BetterDisplay (permissions, login item)

# noTunes (permissions, login item)

# Maestral (config, permissions, login item, install CLI)

# Raycast (config, permissions)

# LinearMouse (permissions)

# Thaw (config, permissions)

# Stats (config, permissions)

# Tailscale (config, permissions, login item)

# Telegram (manual settings sync)

# Screen Sharing config

# Orbstack

# Browser
# - Extensions, bookmarks, history
# - Custom settings
# - Custom search engines

# Obsidian

# qlstephen (verify working)

# InstantSpaceSwitcher (shortcuts, login item)

# Shottr (shortcuts, license, login item)

# Set preferred code editor as default for plain text and code file types
duti ~/.duti

# Configure and check monospace font of choice for dev tooling software

# IDES
# - TextEdit
# - Zed (symlink)
# - Jetbrains IDEs (settings sync)

# Terminal emulators
# - Ghostty (symlink)

# Note-taking
# - Obsidian

# Dev clients
# - API (Postman, Yaak)
# - DB (DBeaver, TablePro)
