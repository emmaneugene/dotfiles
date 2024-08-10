# Setting PATH with guard clause
if [[ -z $PATH_LOADED ]]; then
  source ~/.profile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="$HOME/bin:$HOME/.gem/bin:$HOME/go/bin:/opt/homebrew/opt/openjdk/bin:$PATH:/Users/emman/.depot_tools"

  source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
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

  # ghcup-env
  [ -f "/Users/emman/.ghcup/env" ] && source "/Users/emman/.ghcup/env"

  # opam configuration
  [[ ! -r /Users/emman/.opam/opam-init/init.zsh ]] || source /Users/emman/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

  # Python 3 versions
  export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:/Library/Frameworks/Python.framework/Versions/3.11/bin:/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"

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

  export PATH_LOADED=1
fi
