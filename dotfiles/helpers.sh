# Collection of aliases, helper functions and scripts for UNIX-based systems
alias fk="fuck"
alias routerip="curl https://api.incolumitas.com | jq . && curl ifconfig.me/forwarded"

# Converts a video(.mp4) to GIF format
function vidtogif() {
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
