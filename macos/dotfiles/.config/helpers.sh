#!/usr/bin/env zsh

# Collection of aliases, helper functions and scripts for UNIX-based systems
# Core
alias c="clear"
alias ls="eza --time-style='+%Y-%m-%d %H:%M'"
alias l="eza -lAh --icons=always --time-style='+%Y-%m-%d %H:%M'"
alias md="mkdir -p"
alias t="touch"
alias file="file -h"
alias ldo="lazydocker"
alias lg="lazygit"

# git
alias g=git
alias ga="git add"
alias gb="git branch"
alias gbv="git branch -vv"
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
alias gcam="git commit -am"
alias gco="git checkout"
alias gd="git difftool"
alias gf="git fetch"
alias gfap="git fetch --all --prune"
alias gl="git log"
alias glo="git log --oneline --decorate"
alias glog="git log --oneline --decorate --graph"
alias gm="git merge"
alias gp="git push"
alias gpl="git pull"
alias gr="git restore"
alias grb="git rebase"
alias grbi="git rebase --interactive"
alias grs="git reset"
alias gst="git status"
alias gsta="git stash"
alias gsub="git submodule update --init --recursive"

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
