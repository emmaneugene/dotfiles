#!/usr/bin/env zsh
source ~/.zshrc

echo "Updating brew formulae..."
brew update && brew upgrade && brew autoremove && brew cleanup

echo "Updating oh-my-zsh..."
omz update

echo "Updating global rust packages..."
rustup update stable
cargo-install-update install-update --all

echo "Updating global go packages..."
go-global-update
