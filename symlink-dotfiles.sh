#!/usr/bin/env bash
# Script to symlink dotfiles from a user-specified directory to $HOME
# Existing non-symlinked files are copied as .bak before overwriting

# Do not symlink these
EXCLUDE_FILES=(
  "README.md"
  "secrets.sh.example"
  ".DS_Store"
)

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <directory_name>"
  exit 1
fi

DOTFILES_DIR="$PWD/$1"

is_excluded() {
  local file="$1"
  for exclude in "${EXCLUDE_FILES[@]}"; do
    if [[ "$file" == "$exclude" ]]; then
      return 0
    fi
  done
  return 1
}

find "$DOTFILES_DIR" -type f | while read -r full_path; do
  file="${full_path#$DOTFILES_DIR/}"
  filename="$(basename "$file")"

  if is_excluded "$filename"; then
    echo -e "\e[33mSkipping $file\e[0m"
    continue
  fi

  src_path="$DOTFILES_DIR/$file"
  dst_path="$HOME/$file"

  dst_dir="$(dirname "$dst_path")"
  mkdir -p "$dst_dir"

  if [[ -L "$dst_path" ]]; then
    original="$(readlink "$dst_path")"
    echo -e "\e[36mOverwriting existing symlink: $file -> $original\e[0m"
  elif [[ -e "$dst_path" ]]; then
    cp "$dst_path" "$dst_path.bak"
    echo -e "\e[36mFound existing file: $file - backed up to ${file}.bak\e[0m"
  fi

  rm -f "$dst_path"

  if ln -s "$src_path" "$dst_path"; then
    echo -e "\e[32mSymlinked $file\e[0m"
  else
    echo -e "\e[31mFailed to symlink $file\e[0m"
  fi
done
