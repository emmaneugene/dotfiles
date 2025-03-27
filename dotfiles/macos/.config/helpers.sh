# Collection of aliases, helper functions and scripts for UNIX-based systems
# Core
alias c="clear"
alias ls="eza"
alias l="eza -lAh --icons=always"
alias md="mkdir -p"
alias t="touch"
alias file="file -h"
alias path="echo $PATH | tr ':' '\n'"
alias ldo="lazydocker"
alias lg="lazygit"

# Applications/context specific
alias aichatserve="nohup aichat --serve 10100> /dev/null 2>&1 &; open http://localhost:10100/playground"
alias routerip="curl https://api.incolumitas.com | jq ."
alias x86-gcc="/usr/local/bin/gcc-13"
alias x86-brew="arch -x86_64 /usr/local/Homebrew/bin/brew"

# Update applications and binaries
alias appupd="brew update && brew upgrade && brew autoremove && brew cleanup;
x86-brew update && x86-brew upgrade && x86-brew autoremove && x86-brew cleanup;"
alias appupdcask="brew update && brew upgrade --greedy && brew autoremove && brew cleanup"
alias goupd="go-global-update"
alias rustupd="cargo-install-update install-update --all"
alias jsupd="npm install -g npm && npm -g update"
function pyupd() {
  if [ $# -ne 1 ]; then
    echo "Please provide a version number (e.g. 3.10, 3.11)"
    return
  fi

  python$1 -m pip install --upgrade pip
  python$1 -m pip --disable-pip-version-check list --outdated --format=json | python3 -c "import json, sys; print('\n'.join([x['name'] for x in json.load(sys.stdin)]))" | xargs -n1 python$1 -m pip install -U
}

# git
alias g=git
alias ga="git add"
alias gb="git branch"
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
alias dkcp="docker compose"
alias dki="docker image"
alias dkn="docker network"
alias dkv="docker volume"

# kubectl
alias k=kubectl
alias kaf="kubectl apply -f"

# Invoke manpage or --help for a binary
function doc() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 <binary>"
    return
  fi

  binary="$1"

  if man -w "$binary" >/dev/null 2>&1; then
    man "$binary"
  else
    "$binary" --help
  fi
}

# ripgrep + fzf
function rga-fzf() {
  RG_PREFIX="rga --files-with-matches"
  local file
  file="$(
    FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
      fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
        --phony -q "$1" \
        --bind "change:reload:$RG_PREFIX {q}" \
        --preview-window="70%:wrap"
  )" &&
  echo "opening $file" &&
  open "$file"
}

# Converts a video(.mp4) to GIF format
function vidtogif() {
  if [ $# -ne 2 ]; then
    echo "Usage: $0 <inputFile> <outputFile>
    where input file is of type: .mp4, .webm, ...
    and output file is .gif"
    return
  fi
  gifski -r 10 $1 -o $2
}
