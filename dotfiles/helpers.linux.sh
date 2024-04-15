# Collection of aliases, helper functions and scripts for UNIX-based systems
alias fk="fuck"
alias routerip="curl https://api.incolumitas.com | jq ."
alias l="ls -lAh"
alias md="mkdir -p"

# Update applications and binaries
alias appupdate="sudo apt update && sudo apt upgrade -y \
&& sudo apt autoclean -y && sudo apt autoremove -y;
sudo flatpak update -y;"
alias goupdate="go-global-update"
alias rustupdate="cargo-install-update install-update --all"
alias jsupdate="npm install -g npm && npm -g update"
function pyupdate() {
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
    return
  fi
  gifski -r 10 $1 -o $2
}

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

# Show basic info on wifi interfaces
function wificheck() {
  interface=$(nmcli -t -f active,device d wifi list | grep '^yes' | cut -d':' -f2)
  echo -e "\n        \033[1;33mInterface:\033[0m $interface"
  signal_strength=$(iw dev $interface link | awk '/signal/ {print $2}')
  echo -e "        \033[1;33mSignal strength:\033[0m $signal_strength"
  signal_quality=$(nmcli d wifi list ifname $interface | grep '*' | awk '{print $8}')
  echo -e "        \033[1;33mSignal quality:\033[0m $signal_quality"
  signal_bars=$(nmcli -t -f active,bars d wifi list | grep '^yes' | awk -F: '{print $2}')
  echo -e "        \033[1;33mSignal bars:\033[0m $signal_bars"
  speed=$(nmcli -t -f IN-USE,RATE dev wifi list | grep '*' | awk -F: '{print $2}')
  echo -e "        \033[1;33mWi-Fi Speed:\033[0m $speed"
  channel=$(nmcli -t -f IN-USE,CHAN dev wifi list | grep '*' | awk -F: '{print $2}')
  echo -e "        \033[1;33mWi-Fi Channel:\033[0m $channel"
  noise=$(awk 'NR==3 {print "Link: " $3 " Level: " $4 " Noise: " $5}' /proc/net/wireless)
  echo -e "        \033[1;33mWi-Fi Noise, Link and Quality Level:\033[0m $noise";
}
