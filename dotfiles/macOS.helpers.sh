# Collection of aliases, helper functions and scripts for UNIX-based systems
alias fk="fuck"
alias routerip="curl https://api.incolumitas.com | jq ."
alias appupdate="brew update && brew upgrade --greedy && brew autoremove && brew cleanup; 
x86-brew update && x86-brew upgrade && x86-brew autoremove && x86-brew cleanup;"
alias x86-brew="arch -x86_64 /usr/local/Homebrew/bin/brew"
alias x86-gcc="/usr/local/bin/gcc-13"
alias l="ls -lAh"
alias md="mkdir -p"

# git
alias g=git
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gf="git fetch"
alias gl="git pull"
alias glo="git log --oneline --decorate"
alias glog="git log --oneline --decorate --graph"
alias gm="git merge"
alias gp="git push"
alias grb="git rebase"
alias grbi="git rebase --interactive"
alias grs="git reset"
alias gst="git status"
alias gsta="git stash"

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

# Converts a video(.mp4) to GIF format
function vidtogif() {
  if [ $# -ne 2 ]; then
    echo "Usage: $0 <inputFile> <outputFile>
    where input file is of type: .mp4, .webm, ...
    and output file is .gif"
  fi
  gifski -r 10 $1 -o $2
}

# Invoke manpage or --help for a binary
function doc() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 <binary>"
    exit 1
  fi

  binary="$1"

  if man -w "$binary" >/dev/null 2>&1; then
    man "$binary"
  else
    "$binary" --help
  fi
}
