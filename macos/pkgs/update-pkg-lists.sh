#!/usr/bin/env zsh
# homebrew (arm64)
brew tap > brew-taps.txt && brew list --cask > brew-casks.txt && brew leaves > brew-formulae.txt
# homebrew (x86)
if [[ -x "/usr/local/Homebrew/bin/brew" ]]; then
  arch -x86_64 /usr/local/Homebrew/bin/brew leaves > x86-brew-formulae.txt
fi
# cargo
cp ~/.cargo/.crates.toml cargo.toml
# go
ls ~/go/bin > go.txt
# npm
npm ls -g --json > npm.json
# uv
uv tool list > uv-tools.txt
# pip
pipdeptree -d 0 > pip.txt
# ruby gems
gem dep > gem-deps.txt
