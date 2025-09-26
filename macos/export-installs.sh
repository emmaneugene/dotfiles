#!/usr/bin/env zsh
# Exports various installed software packages to $PWD/installs
source ~/.zshrc

TARGET_DIR="$PWD/installs"
mkdir -p "$TARGET_DIR"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: Could not create or access directory '$TARGET_DIR'"
  exit 1
fi

echo "Exporting to: $TARGET_DIR"

# homebrew (arm64)
if command -v brew &> /dev/null; then
  echo "Exporting Homebrew (arm64)..."
  if brew tap > "$TARGET_DIR/brew-taps.txt" && \
     brew list --cask > "$TARGET_DIR/brew-casks.txt" && \
     brew leaves > "$TARGET_DIR/brew-formulae.txt"; then
    echo "✓ Homebrew (arm64) export completed"
  else
    echo "✗ Homebrew (arm64) export failed"
  fi
fi

# homebrew (x86)
if [[ -x "/usr/local/Homebrew/bin/brew" ]]; then
  echo "Exporting Homebrew (x86)..."
  if arch -x86_64 /usr/local/Homebrew/bin/brew leaves > "$TARGET_DIR/x86-brew-formulae.txt"; then
    echo "✓ Homebrew (x86) export completed"
  else
    echo "✗ Homebrew (x86) export failed"
  fi
fi

# cargo
if [[ -f "$HOME/.cargo/.crates.toml" ]]; then
  echo "Exporting Cargo..."
  if cp $HOME/.cargo/.crates.toml "$TARGET_DIR/cargo.toml"; then
    echo "✓ Cargo export completed"
  else
    echo "✗ Cargo export failed"
  fi
fi

# go
if [[ -d "$HOME/go/bin" ]]; then
  echo "Exporting Go..."
  if ls "$HOME/go/bin" > "$TARGET_DIR/go.txt"; then
    echo "✓ Go export completed"
  else
    echo "✗ Go export failed"
  fi
fi

# npm
if command -v npm &> /dev/null; then
  echo "Exporting NPM..."
  if npm ls -g --json > "$TARGET_DIR/npm.json"; then
    echo "✓ NPM export completed"
  else
    echo "✗ NPM export failed"
  fi
fi

# uv
if command -v uv &> /dev/null; then
  echo "Exporting UV..."
  if uv tool list > "$TARGET_DIR/uv-tools.txt"; then
    echo "✓ UV export completed"
  else
    echo "✗ UV export failed"
  fi
fi

# pip
if command -v pipdeptree &> /dev/null; then
  echo "Exporting Pip..."
  if pipdeptree -d 0 > "$TARGET_DIR/pip.txt"; then
    echo "✓ Pip export completed"
  else
    echo "✗ Pip export failed"
  fi
fi

# ruby gems
if command -v gem &> /dev/null; then
  echo "Exporting Ruby Gems..."
  if gem dep > "$TARGET_DIR/gem-deps.txt"; then
    echo "✓ Ruby Gems export completed"
  else
    echo "✗ Ruby Gems export failed"
  fi
fi

# sdkman
if [[ -n "$SDKMAN_DIR" && -d "$SDKMAN_DIR/candidates" ]]; then
  echo "Exporting SDKMan..."
  if tree -L 2 "$SDKMAN_DIR/candidates" > "$TARGET_DIR/sdkman.txt"; then
    echo "✓ SDKMan export completed"
  else
    echo "✗ SDKMan export failed"
  fi
fi

# docker
if command -v docker &> /dev/null; then
  echo "Exporting Docker..."
  if docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}" | tail -n +2 | sort > "$TARGET_DIR/docker-images.txt"; then
    echo "✓ Docker export completed"
  else
    echo "✗ Docker export failed"
  fi
fi

# vscode extensions
if command -v code &> /dev/null; then
  echo "Exporting VSCode extensions..."
  if code --list-extensions > "$TARGET_DIR/vsc-extensions.txt"; then
    echo "✓ VSCode extensions export completed"
  else
    echo "✗ VSCode extensions export failed"
  fi
fi

# cursor extensions
if command -v cursor &> /dev/null; then
  echo "Exporting Cursor extensions..."
  if cursor --list-extensions > "$TARGET_DIR/cursor-extensions.txt"; then
    echo "✓ Cursor extensions export completed"
  else
    echo "✗ Cursor extensions export failed"
  fi
fi

echo "Export complete!"
