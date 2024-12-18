#!/bin/zsh
source ~/.zshrc

echo "Updating brew packages..."
appupd

echo "Updating oh-my-zsh..."
omz update

echo "Updating rust packages..."
rustupd

echo "Updating go packages..."
goupd
