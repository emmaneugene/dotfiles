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
alias gbv="git branch -vv"
gba() {
  git branch -a --format='%(if)%(HEAD)%(then)* %(else)  %(end)%(refname) | %(objectname:short) | %(committerdate:relative) | %(authorname) %(authoremail)' \
  | awk -F '|' '{printf "\033[36m%-40s\033[0m \033[33m%-8s\033[0m \033[32m%s%s\033[0m\n", $1, $2, $3, $4}' \
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
alias dkcp="docker compose"
alias dki="docker image"
alias dkn="docker network"
alias dkv="docker volume"

# kubectl
alias k=kubectl
alias kaf="kubectl apply -f"

# Invoke manpage or --help for a binary
function m() {
  if [ $# -lt 1 ]; then
    echo "Usage: $0 <command> [subcommand...]"
    return 1
  fi

  cmd=""
  cmd_array=("$@")
  for arg in "$@"; do
    if [ -z "$cmd" ]; then
      cmd="$arg"
    else
      cmd="$cmd $arg"
    fi
  done

  man_cmd=$(echo "$cmd" | tr ' ' '-')

  if man -w "$man_cmd" >/dev/null 2>&1; then
    man "$man_cmd"
  else
    "${cmd_array[@]}" --help
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
  gifski -r 10 "$1" -o "$2"
}
