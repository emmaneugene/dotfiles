#!/bin/zsh
# WARNING: This may overwrite files, so make sure yours are backed up

echo "Symlinking all files in /macos to your home directory..."
DOTFILES_DIR="$PWD/macos"

find "$DOTFILES_DIR" -type f | while read -r full_path; do
  file="${full_path#$DOTFILES_DIR/}"

  src_path="$DOTFILES_DIR/$file"
  dst_path=~/"$file"

  rm "$dst_path" 2>/dev/null

  if ln -s "$src_path" "$dst_path"; then
    echo "Symlinked $file"
  else
    echo "Failed to symlink $file"
  fi
done
