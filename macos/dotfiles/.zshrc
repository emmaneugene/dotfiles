# Starship prompt (replaces powerlevel10k)
(( $+commands[starship] )) && eval "$(starship init zsh)"

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
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
# Orbstack
[[ -f "$HOME/.orbstack/shell/init.zsh" ]] && source "$HOME/.orbstack/shell/init.zsh"
# Haskell
[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"

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
  ~/.local/share/mise/installs/pipx-argcomplete/latest/argcomplete/lib/python*/site-packages/argcomplete/bash_completion.d(/N)  # argcomplete
  $fpath
)

#### Oh-My-Zsh ####
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
COMPLETION_WAITING_DOTS="true"
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
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

#### Post-OMZ ####
[[ -f "$HOME/.config/secrets.sh" ]] && source "$HOME/.config/secrets.sh"
export AWS_PROFILE=personal
# ipython startup
export PYTHONSTARTUP="$HOME/.config/pythonstartup.py"
# marimo
(( $+commands[marimo] )) && eval "$(_MARIMO_COMPLETE=zsh_source marimo)"
# fzf
export FZF_DEFAULT_OPTS='--walker file,dir,hidden'
(( $+commands[fzf] )) && source <(fzf --zsh)
# mise
(( $+commands[mise] )) && eval "$(mise activate zsh)"
# atuin
(( $+commands[atuin] )) && eval "$(atuin init zsh --disable-up-arrow)"
# zoxide
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
