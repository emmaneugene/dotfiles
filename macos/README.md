# Private config

Private config files for MacOS systems

- [dotfiles](dotfiles/): Dotfiles, symlinked into `$HOME` via `symlink.py`
- [`setup/`](setup/): One-time macOS setup scripts
  - [`apply-macos-settings.sh`](setup/apply-macos-settings.sh): Idempotently apply curated macOS defaults/settings
  - [`macos-setup.sh`](setup/macos-setup.sh): One-time macOS setup guide

## Setup

Clone and symlink dotfiles:

```bash
./symlink.py
```

Apply curated macOS settings:

```bash
./setup/apply-macos-settings.sh
```
