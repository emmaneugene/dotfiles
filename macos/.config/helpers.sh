#!/usr/bin/env zsh

# Collection of personal aliases, helper functions and env vars
# Core
alias c="clear"
alias l="eza -lAh --icons=always --time-style='+%Y-%m-%d %H:%M'"
alias md="mkdir -p"
alias t="touch"
alias f="file --no-dereference"
alias ide="zed"
alias ldo="lazydocker"
alias lg="lazygit"
alias cc="claude --verbose"
alias cx="codex"
export VAULT_DIR="$HOME/vault"

# git
alias g=git
alias ga="git add"
alias gb="git branch"
alias gbv="git branch -vv"
gbd() {
  local branch="$1"

  if [[ -z "$branch" ]]; then
    echo "Usage: gbd <branch>"
    return 1
  fi

  git branch -D "$branch" && git push --delete origin "$branch"
}
gba() {
  git branch -a --format='%(if)%(HEAD)%(then)* %(else) %(end)%(refname)
    | %(objectname:short) | %(committerdate:relative) | %(authorname) %(authoremail)' \
  | awk -F '|' \
    '{
      printf "\033[36m%-40s\033[0m \033[33m%-8s\033[0m \033[32m%s%s\033[0m\n",
      $1, $2, $3, $4
    }' \
  | less -R
}
alias gc="git commit"
alias gco="git checkout"
alias gd="git difftool"
alias gds="git difftool --staged"
alias gf="git fetch"
alias gl="git log"
alias glg="git log --graph --all --format='%C(yellow)%h%C(reset) \
%C(blue)%an%C(reset) %C(green)(%ar)%C(reset) %s%C(auto)%d%C(reset)'"
alias glo="git log --oneline --decorate"
alias glog="git log --oneline --decorate --graph"
alias gm="git merge"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpl="git pull"
alias gr="git restore"
alias grb="git rebase"
alias grbc="git rebase --continue"
alias grbi="git rebase --interactive"
alias grs="git reset"
alias gst="git status"
alias gsta="git stash"
alias gsw="git switch"
alias gsub="git submodule update --init --recursive"
alias gw="git worktree"

# docker
alias dk=docker
alias dkc="docker container"
alias dkcp="docker-compose"
alias dki="docker image"
alias dkn="docker network"
alias dkv="docker volume"

# kubectl
alias k=kubectl
alias kaf="kubectl apply -f"
