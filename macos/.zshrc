# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

#### Custom stuff ####
# Basic environment
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="$(command -v nvim || command -v vim || command -v vi)"
export VISUAL="$EDITOR"
export XDG_CONFIG_HOME="$HOME/.config"

# Keybindings
# (⌘ + ←)
bindkey '\e\eOD' beginning-of-line
# (⌘ + →)
bindkey '\e\eOC' end-of-line

# Prevent duplicates
typeset -U path fpath manpath infopath

#### PATH$ modifications ####
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
BREW_HOME="$(brew --prefix)"
# Use GNU coreutils (https://github.com/darksonic37/linuxify)
path=(
    "${BREW_HOME}/opt/coreutils/libexec/gnubin"     # coreutils
    "${BREW_HOME}/opt/make/libexec/gnubin"          # make
    "${BREW_HOME}/opt/m4/bin"                       # m4
    "${BREW_HOME}/opt/file-formula/bin"             # file-formula
    "${BREW_HOME}/opt/unzip/bin"                    # unzip
    "${BREW_HOME}/opt/flex/bin"                     # flex
    "${BREW_HOME}/opt/bison/bin"                    # bison
    "${BREW_HOME}/opt/libressl/bin"                 # libressl
    "${BREW_HOME}/opt/ed/libexec/gnubin"            # ed
    "${BREW_HOME}/opt/findutils/libexec/gnubin"     # findutils
    "${BREW_HOME}/opt/gnu-indent/libexec/gnubin"    # gnu-indent
    "${BREW_HOME}/opt/gnu-sed/libexec/gnubin"       # gnu-sed
    "${BREW_HOME}/opt/gnu-tar/libexec/gnubin"       # gnu-tar
    "${BREW_HOME}/opt/gnu-which/libexec/gnubin"     # gnu-which
    "${BREW_HOME}/opt/grep/libexec/gnubin"          # grep
    $path
)
manpath=(
    "${BREW_HOME}/share/man"                        # most programs
    "${BREW_HOME}/opt/coreutils/libexec/gnuman"     # coreutils
    "${BREW_HOME}/opt/make/libexec/gnuman"          # make
    $manpath
)
infopath=(
    "${BREW_HOME}/share/info"                       # most programs
    $infopath
)
# SDKman (https://sdkman.io/)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# Rust (https://rust-lang.org/)
source "$HOME/.cargo/env"
# Orbstack
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
# LMStudio (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# Haskell
[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"
# Gcloud
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
# Ngrok
command -v ngrok &>/dev/null && eval "$(ngrok completion)"
# Custom scripts, uv, Python 3, Ruby, Golang, asdf
export ASDF_DATA_DIR="$HOME/.asdf"
python3="/Library/Frameworks/Python.framework/Versions/3.12/bin"
path=(
    "/opt/homebrew/opt/postgresql@16/bin"
    "$HOME/bin"             # Custom scripts
    "$HOME/.local/bin"      # uv
    $python3                # Python3
    "$HOME/.gem/bin"        # Ruby
    "$HOME/go/bin"          # Golang
    "$ASDF_DATA_DIR/shims"  # asdf
    $path
)
# Shell completions
fpath=(
    "$(brew --prefix)/share/zsh/site-functions"
    "$HOME/.zfunc"
    $fpath
)

#### Oh-My-Zsh ####
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
zstyle ':omz:update' mode disabled
zstyle ':omz:plugins:*' aliases no
# ($ZSH/plugins/:$ZSH_CUSTOM/plugins/)
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
    # Custom
    zig-shell-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source "$ZSH/oh-my-zsh.sh"

#### Post-OMZ customizations ####
source "$HOME/.config/secrets.sh"
source "$HOME/.config/helpers.sh"
export AWS_PROFILE=personal
export PYTHONSTARTUP="$HOME/.config/pythonstartup.py"
export FZF_DEFAULT_OPTS='--walker file,dir,hidden'
source <(fzf --zsh)
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(zoxide init zsh)"
