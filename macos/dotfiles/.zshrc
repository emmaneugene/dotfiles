# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

## Environment variables
# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
# VISUAL, EDITOR
export EDITOR="$(command -v nvim || command -v vim || command -v vi)"
export VISUAL="$EDITOR"
# XDG_CONFIG_HOME
export XDG_CONFIG_HOME="$HOME/.config"
# Secrets
source "$HOME/.config/secrets.sh"

## Oh-My-Zsh config
ZSH_THEME="powerlevel10k/powerlevel10k"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd/mm/yyyy"
zstyle ':omz:update' mode disabled
# Plugins ($ZSH/plugins/:$ZSH_CUSTOM/plugins/)
plugins=(
  aliases
  aws
  colored-man-pages
  command-not-found
  docker
  docker-compose
  dotenv
  gh
  git
  golang
  history-substring-search
  kubectl
  macos
  node
  zsh-autosuggestions
  zsh-syntax-highlighting
)

## Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
# homebrew command-not-found
HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
[[ -f "$HB_CNF_HANDLER" ]] && source "$HB_CNF_HANDLER"

## AWS CLI
export AWS_PROFILE=personal
## iPython sessions
export PYTHONSTARTUP="$HOME/.config/pythonstartup.py"

## PATH and shell completions
# Orbstack
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
# LMStudio (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# cargo
source "$HOME/.cargo/env"
# uv
export PATH="$HOME/.local/bin:$PATH"
# asdf
export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
# Haskell
[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"
# Ocaml
[[ -f "$HOME/.opam/opam-init/init.zsh" ]] && source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
# Gcloud
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
# Ngrok
command -v ngrok &>/dev/null && eval "$(ngrok completion)"
# Postgres 16
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
# Python 3.12 (official installer)
export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH"
# User, Ruby, Golang
export PATH="$HOME/scripts:$HOME/.gem/bin:$HOME/go/bin:$PATH"
# SDKman for JVMs and associated SDKs
export SDKMAN_DIR="$HOME/.sdkman"
[[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

## Replace inbuilt binaries with GNU coreutil equivalents (https://github.com/darksonic37/linuxify)
BREW_HOME="$(brew --prefix)"
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

# Deduplicate ?PATH env vars
# (e.g. multiple .zshrc executions when opening tmux sessions)
dedupe_env() {
  local var_name="${1:?Must provide an environment variable name}"
  local orig_var=$(eval "echo \$$var_name")

  if [ -n "$orig_var" ]; then
    local deduped_var=""
    local remaining_var="$orig_var:"

    while [ -n "$remaining_var" ]; do
      local current_entry="${remaining_var%%:*}"

      case ":$deduped_var:" in
        *:"$current_entry":*) ;;
        *)
          if [ -z "$deduped_var" ]; then
            deduped_var="$current_entry"
          else
            deduped_var="$deduped_var:$current_entry"
          fi
          ;;
      esac

      remaining_var="${remaining_var#*:}"
    done

    # Update the environment variable
    eval "export $var_name='$deduped_var'"
  fi
}

dedupe_env FPATH
dedupe_env INFOPATH
dedupe_env MANPATH
dedupe_env PATH

autoload -U compinit; compinit
source "$ZSH/oh-my-zsh.sh"
unalias -m  "*"
source "$HOME/.config/helpers.sh"
source <(fzf --zsh)
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(zoxide init zsh)"
