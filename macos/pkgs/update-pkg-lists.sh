#!/bin/zsh
# homebrew
brew list --cask > brew-casks.txt && brew leaves > brew-formulae.txt && arch -x86_64 /usr/local/Homebrew/bin/brew leaves > x86-brew-formulae.txt
# cargo
cp ~/.cargo/.crates.toml cargo.toml
# go
ls ~/go/bin > go.txt
# npm
npm ls -g --json > npm.json
# pip
pipdeptree -d 0 > pip.txt
