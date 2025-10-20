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
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[1;100m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

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
# SDKman (https://sdkman.io/)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# Rust (https://rust-lang.org/)
source "$HOME/.cargo/env"
# Custom scripts, uv, Python 3, Ruby, Golang, asdf
export ASDF_DATA_DIR="$HOME/.asdf"
python3="/Library/Frameworks/Python.framework/Versions/3.12/bin"
path=(
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
    command-not-found
    docker
    docker-compose
    dotenv
    git
    history-substring-search
    macos
    node
    # Custom
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source "$ZSH/oh-my-zsh.sh"

#### Post-OMZ customizations ####
source "$HOME/.config/secrets.sh"
source "$HOME/.config/helpers.sh"
export PYTHONSTARTUP="$HOME/.config/pythonstartup.py"
export FZF_DEFAULT_OPTS='--walker file,dir,hidden'
source <(fzf --zsh)
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(zoxide init zsh)"
alias claude="~/.claude/local/claude"
