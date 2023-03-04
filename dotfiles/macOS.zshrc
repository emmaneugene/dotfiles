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
  minikube
  node
  macos
  npm
  nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

eval $(thefuck --alias)

function vidtogif() {
  gifski -r 10 $1 -o $1
}

# JAVA_HOME
export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# homebrew command-not-found
HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
if [ -f "$HB_CNF_HANDLER" ]; then
source "$HB_CNF_HANDLER";
fi

# PATH config
export PATH="/opt/homebrew/coreutils/libexec/gnubin:/opt/homebrew/opt/openjdk/bin:$PATH:/Users/emman/.depot_tools"

# Replace with GNU coreutils (https://github.com/darksonic37/linuxify)
BREW_HOME=$(brew --prefix)
# most programs
export PATH="${BREW_HOME}/bin:$PATH"
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

# python
export PATH="${BREW_HOME}/opt/python/libexec/bin:$PATH"

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

unset BREW_HOME

# Custom aliases
alias appupdate="brew update; brew upgrade; brew autoremove; brew cleanup;
x86-brew update; x86-brew upgrade;
x86-brew autoremove; x86-brew cleanup;"
alias ohmyzsh="code ~/.oh-my-zsh"
alias fk="fuck"
alias x86-brew="arch -x86_64 /usr/local/Homebrew/bin/brew"
alias x86-gcc="/usr/local/bin/gcc-12"
alias zshconfig="nvim ~/.zshrc"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

