# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
  aliases
  aws
  command-not-found
  colored-man-pages
  docker
  docker-compose
  dotenv
  gh
  git
  history-substring-search
  kubectl
  node
  macos
  nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Helpers
source $HOME/.config/helpers.sh
eval $(thefuck --alias)

# JAVA_HOME
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PYTHONSTARTUP="$HOME/.config/pythonstartup.py"

# homebrew command-not-found
HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
if [ -f "$HB_CNF_HANDLER" ]; then
source "$HB_CNF_HANDLER";
fi

# PATH config
export PATH="/Users/emman/go/bin:/opt/homebrew/opt/curl/bin:/opt/homebrew/opt/openjdk/bin:$PATH:/Users/emman/.depot_tools"

# Replace with GNU coreutils (https://github.com/darksonic37/linuxify)
BREW_HOME=$(brew --prefix)
# most programs
export MANPATH="${BREW_HOME}/share/man:$MANPATH"
export INFOPATH="${BREW_HOME}/share/info:$INFOPATH"
# coreutils
export PATH="${BREW_HOME}/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="${BREW_HOME}/opt/coreutils/libexec/gnuman:$MANPATH"
# make
export PATH="${BREW_HOME}/opt/make/libexec/gnubin:$PATH"
export MANPATH="${BREW_HOME}/opt/make/libexec/gnuman:$MANPATH"
# m4
export PATH="${BREW_HOME}/opt/m4/bin:$PATH"
# file-formula
export PATH="${BREW_HOME}/opt/file-formula/bin:$PATH"
# unzip
export PATH="${BREW_HOME}/opt/unzip/bin:$PATH"
# flex
export PATH="${BREW_HOME}/opt/flex/bin:$PATH"
export LDFLAGS="-L${BREW_HOME}/opt/flex/lib"
export CPPFLAGS="-I${BREW_HOME}/opt/flex/include"
# bison
export PATH="${BREW_HOME}/opt/bison/bin:$PATH"
export LDFLAGS="-L${BREW_HOME}/opt/bison/lib"
# libressl
export PATH="${BREW_HOME}/opt/libressl/bin:$PATH"
export LDFLAGS="-L${BREW_HOME}/opt/libressl/lib"
export CPPFLAGS="-I${BREW_HOME}/opt/libressl/include"
export PKG_CONFIG_PATH="${BREW_HOME}/opt/libressl/lib/pkgconfig"
# ed
export PATH="${BREW_HOME}/opt/ed/libexec/gnubin:$PATH"
# findutils
export PATH="${BREW_HOME}/opt/findutils/libexec/gnubin:$PATH"
# gnu-indent
export PATH="${BREW_HOME}/opt/gnu-indent/libexec/gnubin:$PATH"
# gnu-sed
export PATH="${BREW_HOME}/opt/gnu-sed/libexec/gnubin:$PATH"
# gnu-tar
export PATH="${BREW_HOME}/opt/gnu-tar/libexec/gnubin:$PATH"
# gnu-which
export PATH="${BREW_HOME}/opt/gnu-which/libexec/gnubin:$PATH"
# grep
export PATH="${BREW_HOME}/opt/grep/libexec/gnubin:$PATH"

# unset BREW_HOME

# Custom aliases
alias appupdate="brew update && brew upgrade --greedy && brew autoremove && brew cleanup; 
x86-brew update && x86-brew upgrade && x86-brew autoremove && x86-brew cleanup;"
alias x86-brew="arch -x86_64 /usr/local/Homebrew/bin/brew"
alias x86-gcc="/usr/local/bin/gcc-13"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f "/Users/emman/.ghcup/env" ] && source "/Users/emman/.ghcup/env" # ghcup-env

# opam configuration
[[ ! -r /Users/emman/.opam/opam-init/init.zsh ]] || source /Users/emman/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# invoke `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
