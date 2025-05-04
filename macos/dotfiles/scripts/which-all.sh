#!/usr/bin/env zsh

#  Find all instances of a command in PATH
if [[ $# -eq 0 ]]; then
  echo "Usage: which-all command_name" >&2
  exit 1
fi

command_name="$1"
found=0

# Split PATH using ':' delimiter
path_dirs=(${(s.:.)PATH})
for dir in $path_dirs; do
  # Skip empty directory entries
  if [[ -z "$dir" ]]; then
      dir="."
  fi

  # Check if the command exists in this directory
  if [[ -f "$dir/$command_name" && -x "$dir/$command_name" ]]; then
    echo "$dir/$command_name"
    found=1
  fi
done

if [[ $found -eq 0 ]]; then
  echo "$command_name not found in PATH" >&2
  exit 1
fi

exit 0
