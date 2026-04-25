# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

#### Interactive shell settings ####

# Terminal color support
export COLORTERM="truecolor"

# Man page colors
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[1;100m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
export MANPAGER="less -FRMX"

# Keybindings
bindkey '\e\eOD' beginning-of-line     # (⌘ + ←)
bindkey '\e\eOC' end-of-line           # (⌘ + →)

#### PATH ####

# Prevent duplicates in path arrays
typeset -U path fpath manpath infopath

# Rust
source "$HOME/.cargo/env"

path=(
  "$HOME/bin"             # custom commands and clis
  "$HOME/.local/bin"      # uv and others
  "$HOMEBREW_PREFIX/bin"  # homebrew
  "$HOMEBREW_PREFIX/sbin" # homebrew
  "/Applications/Obsidian.app/Contents/MacOS" # obsidian CLI
  $path
)

manpath=(
  "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/share/man" # xcode command line tools
  "$HOMEBREW_PREFIX/share/man"                                        # homebrew
  "/usr/local/share/man"                                              # local man pages
  "/usr/share/man"                                                    # system man pages
  $manpath
)

fpath=(
  "$HOME/.zfunc/generated"                      # custom-generated completions
  "$HOME/.zfunc"                                # custom-sourced
  "$HOMEBREW_PREFIX/share/zsh/site-functions"   # homebrew
  ~/.local/share/uv/tools/argcomplete/lib/python*/site-packages/argcomplete/bash_completion.d(/N)  # argcomplete
  $fpath
)

#### Oh-My-Zsh ####
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
zstyle ':omz:update' mode disabled
zstyle ':omz:plugins:*' aliases no
# See $ZSH/plugins/:$ZSH_CUSTOM/plugins/
plugins=(
  aliases
  command-not-found
  history-substring-search
  macos
  # Custom
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source "$ZSH/oh-my-zsh.sh"

#### Post-OMZ ####
source "$HOME/.config/secrets.sh"
# Interactive Python
export PYTHONSTARTUP="$HOME/.config/pythonstartup.py"
# fzf
export FZF_DEFAULT_OPTS='--walker file,dir,hidden'
source <(fzf --zsh)
# mise
eval "$(mise activate zsh)"
# atuin
eval "$(atuin init zsh --disable-up-arrow)"
# zoxide
eval "$(zoxide init zsh)"
