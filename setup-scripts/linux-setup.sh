# Setup script for machines running Ubuntu/Mint

# Install zsh
sudo apt-get update; sudo apt-get install zsh
# Make zsh default login shell
sudo chsh -s $(which zsh)
# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# Install plugins `zsh-autosuggestions` and `zsh-syntax-highlighting`
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Clone config repo
git clone git@github.com:

# Symlink dotfiles
# .zshrc
rm ~/.zshrc && ln -s ~/config/public/dotfiles/linux.zshrc ~/.zshrc
# nvim init.lua
mkdir -p ~/.config/nvim && rm ~/.config/nvim/init.lua && ln -s ~/config/public/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
# git config files
ln -s ~/config/public/dotfiles/git/global.gitignore ~/.gitignore
ln -s ~/config/public/dotfiles/git/global.gitmessage ~/.gitmessage

# Install software
# pyenv
curl https://pyenv.run | bash
# refer to https://github.com/pyenv/pyenv/wiki#suggested-build-environment for build setup
sudo apt update; sudo apt install build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

#rclone
sudo -v ; curl https://rclone.org/install.sh | sudo bash

# nix package manager
bash <(curl -L https://nixos.org/nix/install) --daemon

# Add apt repositories 
# Docker 
# Typora
