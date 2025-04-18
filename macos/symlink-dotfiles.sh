#!/usr/bin/env zsh
# Script to symlink dotfiles from a user-specified directory to $HOME
# WARNING: This overwrites existing files, so make sure yours are backed up

if [ $# -eq 0 ]; then
  echo "Usage: $0 <directory_name>"
  exit 1
fi

DOTFILES_DIR="$PWD/$1"

find "$DOTFILES_DIR" -type f | while read -r full_path; do
  file="${full_path#$DOTFILES_DIR/}"

  src_path="$DOTFILES_DIR/$file"
  dst_path="$HOME/$file"

  rm "$dst_path" 2>/dev/null

  if ln -s "$src_path" "$dst_path"; then
    echo "Symlinked $file"
  else
    echo "Failed to symlink $file"
  fi
done
