# Environment variables needed by all zsh invocations (interactive, scripts, cron, etc.)

# Locale
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Editor
export EDITOR="$(command -v nvim || command -v vim || command -v vi)"
export VISUAL="$EDITOR"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"

# Homebrew (set here so .zshrc PATH setup can reference $HOMEBREW_PREFIX)
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"

# Aliases and helper functions
source "$HOME/.config/helpers.sh"
