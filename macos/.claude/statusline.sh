#!/usr/bin/env zsh
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
git_branch=$(cd "$cwd" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'no-git')
printf "\033[2m%s\033[0m \033[36m%s\033[0m \033[33m[%s]\033[0m" "$model" "$cwd" "$git_branch"
