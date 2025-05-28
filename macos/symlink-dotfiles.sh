#!/usr/bin/env zsh
# Script to symlink dotfiles from a user-specified directory to $HOME
# WARNING: This overwrites existing files, so make sure yours are backed up

local -a EXCLUDE_FILES=(
  "README.md"
  "secrets.sh.example"
  ".DS_Store"
)

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <directory_name>"
  exit 1
fi

DOTFILES_DIR="$PWD/$1"

find "$DOTFILES_DIR" -type f | while read -r full_path; do
  file="${full_path#$DOTFILES_DIR/}"
  filename=${file:t}

  if [[ -n ${EXCLUDE_FILES[(r)$filename]} ]]; then
    echo "\e[33mSkipping $file\e[0m"
    continue
  fi

  src_path="$DOTFILES_DIR/$file"
  dst_path="$HOME/$file"

  dst_dir="$(dirname "$dst_path")"
  mkdir -p "$dst_dir"

  rm "$dst_path" 2>/dev/null

  if ln -s "$src_path" "$dst_path"; then
    echo "\e[32mSymlinked $file\e[0m"
  else
    echo "\e[31mFailed to symlink $file\e[0m"
  fi
done
