#!/usr/bin/env zsh
source ~/.zshrc

# Default to interactive mode
AUTO_APPROVE=false

if [[ "$1" == "-y" ]]; then
  AUTO_APPROVE=true
  echo "Running in non-interactive mode. All updates will be applied automatically."
fi

# Prompt user for confirmation
confirm() {
  local prompt="$1"
  local check_command="$2"
  local action="$3"

  if ! $AUTO_APPROVE && [[ -n "$check_command" ]]; then
    echo "Checking for updates"
    eval "$check_command"
  fi

  if $AUTO_APPROVE; then
    eval "$action"
    return
  fi

  echo -n "\033[33m$prompt\033[0m [Y/n]: "
  read -r response

  if [[ "$response" =~ ^[Nn]$ ]]; then
    echo "Skipping this step."
  else
    eval "$action"
  fi
}

brew update
echo "Fetching outdated brew packages..."
brew upgrade --greedy --dry-run

echo "=== Homebrew ==="
confirm "Update Homebrew formulae?" \
  "" \
  "{ echo 'Updating brew formulae...'; brew upgrade; }"

confirm "Update Homebrew casks?" \
  "" \
  "{ echo 'Updating brew casks...'; brew upgrade --greedy --no-quarantine; }"

echo "Running cleanup for brew"
brew autoremove
brew cleanup

echo "=== Oh-My-Zsh ==="
confirm "Update Oh-My-Zsh?" \
  "" \
  "{ echo 'Updating oh-my-zsh...'; omz update; }"

# Rust update
echo "=== Rust and Cargo Packages ==="
confirm "Update Rust and global Rust binaries?" \
"{ echo 'Rust version:'; rustup check; echo 'Cargo package versions:'; cargo install-update --list; }" \
"{ echo 'Updating global rust binaries...'; rustup update stable; cargo install-update --all; }"

# Go binaries update
echo "=== Go Packages ==="
confirm "Update global Go binaries?" \
"go-global-update --dry-run" \
"{ echo 'Updating global go binaries...'; go-global-update; }"

echo "\033[32mSystem update complete!\033[0m"
