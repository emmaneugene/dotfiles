# Software and configuration

An effort to automate the process of setting up software and configurations on new computers - I'm publishing lists of all the important software and extensions I have on my devices alongside configuration files and setup scripts. 

### Software packages

Some of the *absolute essentials*:

- **Browser**: Firefox, Chromium
- **Mail client**: Thunderbird
- **Password manager**: Bitwarden
- **Cloud storage**: Dropbox, Google Drive
- **Clipboard history**: CopyQ/BettterTouchTools
- **Chat**: Telegram
- **Work communication**: Slack, Mattermost
- **E-library**: Calibre
- **Knowledge base**: Notion, Obsidian
- **Screen recorder**: Peek/Proprietary
- **Package manager**: Homebrew, Chocolatey, Flatpak, etc.
- **Container/virtualization runtime**: Docker
- **Shell**: zsh with [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and [powerlevel10k](https://github.com/romkatv/powerlevel10k) (use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) if you're on windows)
- **Command-line utilities**: `git`, `git-lfs`, `gh`, `nvim`, `nvm`, `pyenv`, `conda`, `fuck`, `openssh`, `curl`, `rsync`, `fzf`  (more to come)

### Dotfiles and configs

I use these files to personalize software like `zsh` and `nvim`.  In most cases, it's possible to clone this repo and [symlink](https://news.ycombinator.com/item?id=11071754) these files to set up configurations locally. Any changes can then be made directly on the repository with full history tracked remotely with a VCS.
