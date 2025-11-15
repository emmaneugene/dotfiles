# kickstart.nvim

## Introduction

A starting point for Neovim that is:

* Small
* Single-file
* Completely Documented

**NOT** a Neovim distribution, but instead a starting point for your configuration.

## Installation

### Install Neovim

Kickstart.nvim targets *only* the latest
['stable'](https://github.com/neovim/neovim/releases/tag/stable) and latest
['nightly'](https://github.com/neovim/neovim/releases/tag/nightly) of Neovim.
If you are experiencing issues, please make sure you have the latest versions.

### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- Clipboard tool (xclip/xsel/win32yank or other depending on platform)
- A [Nerd Font](https://www.nerdfonts.com/): optional, provides various icons
  - if you have it set `vim.g.have_nerd_font` in `init.lua` to true
- Language Setup:
  - If want to write Typescript, you need `npm`
  - If want to write Golang, you will need `go`
  - etc.

> **NOTE**
> See [Install Recipes](#Install-Recipes) for additional Windows and Linux specific notes
> and quick install snippets

### Install Kickstart

> **NOTE**
> [Backup](#FAQ) your previous configuration (if any exists)

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%localappdata%\nvim\` |
| Windows (powershell)| `$env:LOCALAPPDATA\nvim\` |

#### Recommended Step

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo
so that you have your own copy that you can modify, then install by cloning the
fork to your machine using one of the commands below, depending on your OS.

> **NOTE**
> Your fork's url will be something like this:
> `https://github.com/<your_github_username>/kickstart.nvim.git`

#### Clone kickstart.nvim
> **NOTE**
> If following the recommended step above (i.e., forking the repo), replace
> `nvim-lua` with `<your_github_username>` in the commands below

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/nvim-lua/kickstart.nvim.git %localappdata%\nvim\
```

If you're using `powershell.exe`

```
git clone https://github.com/nvim-lua/kickstart.nvim.git $env:LOCALAPPDATA\nvim\
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
current plugin status. Hit `q` to close the window.

Read through the `init.lua` file in your configuration folder for more
information about extending and exploring Neovim. That also includes
examples of adding popularly requested plugins.


### Getting Started

[The Only Video You Need to Get Started with Neovim](https://youtu.be/m8C0Cq9Uv9o)

## Understanding Lazy.nvim

### What is Lazy?

[Lazy.nvim](https://github.com/folke/lazy.nvim) is a modern plugin manager for Neovim that provides:

- **Lazy loading**: Plugins load only when needed (on specific commands, filetypes, keys, etc.)
- **Fast startup**: Minimal overhead at Neovim startup
- **Dependency management**: Automatic plugin dependency resolution
- **Easy updates**: Simple commands to update all plugins
- **Configuration as code**: Plugins are defined in Lua configuration

### Plugin Storage Locations

Plugins managed by lazy.nvim are stored in the following locations:

| Component | Path | Purpose |
| :- | :--- | :--- |
| Lazy root | `~/.local/share/nvim/lazy/` | Default location where all plugins are cloned |
| Plugin lockfile | `~/.config/nvim/lazy-lock.json` | Stores exact commit/version of each plugin for reproducibility |
| Cache/State | `~/.local/state/nvim/` | Lazy's internal state and cache files |

#### Custom Lazy Root (Optional)

You can change the lazy root directory in your `init.lua`:

```lua
require("lazy").setup(plugins, {
  root = vim.fn.stdpath("data") .. "/lazy", -- default
  -- or customize it
  -- root = "/custom/path/to/plugins",
})
```

### Managing Plugins with Lazy

#### Viewing Plugin Status

Open Neovim and run:

```vim
:Lazy
```

This opens an interactive UI showing:
- All installed plugins
- Update availability
- Plugin status (loaded, not loaded, etc.)
- Keybindings for common operations

#### Updating Plugins

Update all plugins to their latest versions:

```vim
:Lazy update
```

Update a specific plugin:

```vim
:Lazy update plugin-name
```

#### Installing Missing Plugins

Install any plugins missing from `~/.local/share/nvim/lazy/`:

```vim
:Lazy install
```

### Handling Plugin Update Issues

Sometimes plugins fail to update due to:
- Network issues
- Conflicting changes in the plugin
- Corrupted local repository
- Upstream breaking changes

#### Option 1: Retry Update

First attempt is usually to simply retry:

```vim
:Lazy update
```

#### Option 2: Clean and Reinstall Specific Plugin

Remove a plugin and let lazy reinstall it:

```vim
:Lazy clean plugin-name
```

Then reinstall:

```vim
:Lazy install
```

#### Option 3: Full Plugin Reset

If multiple plugins have issues or you want a complete fresh start:

1. **Remove lazy's plugin cache:**
   ```bash
   rm -rf ~/.local/share/nvim/lazy/
   ```

2. **Clear lazy's state:**
   ```bash
   rm -rf ~/.local/state/nvim/
   ```

3. **Restart Neovim:**
   ```bash
   nvim
   ```

Lazy will automatically clone all plugins again and reinstall everything from the lockfile.

#### Option 4: Reset to Locked Versions

If you want to revert all plugins to the versions stored in `lazy-lock.json`:

```vim
:Lazy restore
```

This reverts all plugins to their locked versions without deleting them.

#### Checking Plugin Lock Status

View which plugins are locked to specific versions:

```vim
:Lazy show
```

#### Updating Lock File

After updating plugins, the `lazy-lock.json` file is automatically updated. Commit this to git to ensure reproducible builds:

```bash
git add ~/.config/nvim/lazy-lock.json
git commit -m "Update plugin versions"
```

### Troubleshooting Common Plugin Issues

**Plugin fails to load:**
- Check `:Lazy` for error messages
- Review plugin-specific configuration in `init.lua`
- Ensure plugin dependencies are satisfied

**Plugin update hangs:**
- Press `<C-c>` to cancel
- Check git status: `git -C ~/.local/share/nvim/lazy/plugin-name status`
- Manually reset if needed: `rm -rf ~/.local/share/nvim/lazy/plugin-name`

**Outdated lockfile causing issues:**
- Delete `lazy-lock.json` to remove version constraints
- Run `:Lazy update` to generate fresh lockfile

### FAQ

* What should I do if I already have a pre-existing neovim configuration?
  * You should back it up and then delete all associated files.
  * This includes your existing init.lua and the neovim files in `~/.local`
    which can be deleted with `rm -rf ~/.local/share/nvim/`
* Can I keep my existing configuration in parallel to kickstart?
  * Yes! You can use [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME)`=nvim-NAME`
    to maintain multiple configurations. For example, you can install the kickstart
    configuration in `~/.config/nvim-kickstart` and create an alias:
    ```
    alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
    ```
    When you run Neovim using `nvim-kickstart` alias it will use the alternative
    config directory and the matching local directory
    `~/.local/share/nvim-kickstart`. You can apply this approach to any Neovim
    distribution that you would like to try out.
* What if I want to "uninstall" this configuration:
  * See [lazy.nvim uninstall](https://github.com/folke/lazy.nvim#-uninstalling) information
* Why is the kickstart `init.lua` a single file? Wouldn't it make sense to split it into multiple files?
  * The main purpose of kickstart is to serve as a teaching tool and a reference
    configuration that someone can easily use to `git clone` as a basis for their own.
    As you progress in learning Neovim and Lua, you might consider splitting `init.lua`
    into smaller parts. A fork of kickstart that does this while maintaining the 
    same functionality is available here:
    * [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
  * Discussions on this topic can be found here:
    * [Restructure the configuration](https://github.com/nvim-lua/kickstart.nvim/issues/218)
    * [Reorganize init.lua into a multi-file setup](https://github.com/nvim-lua/kickstart.nvim/pull/473)

### Install Recipes

Below you can find OS specific install instructions for Neovim and dependencies.

After installing all the dependencies continue with the [Install Kickstart](#Install-Kickstart) step.

#### Windows Installation

<details><summary>Windows with Microsoft C++ Build Tools and CMake</summary>
Installation may require installing build tools and updating the run command for `telescope-fzf-native`

See `telescope-fzf-native` documentation for [more details](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation)

This requires:

- Install CMake and the Microsoft C++ Build Tools on Windows

```lua
{'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
```
</details>
<details><summary>Windows with gcc/make using chocolatey</summary>
Alternatively, one can install gcc and make which don't require changing the config,
the easiest way is to use choco:

1. install [chocolatey](https://chocolatey.org/install)
either follow the instructions on the page or use winget,
run in cmd as **admin**:
```
winget install --accept-source-agreements chocolatey.chocolatey
```

2. install all requirements using choco, exit previous cmd and
open a new one so that choco path is set, and run in cmd as **admin**:
```
choco install -y neovim git ripgrep wget fd unzip gzip mingw make
```
</details>
<details><summary>WSL (Windows Subsystem for Linux)</summary>

```
wsl --install
wsl
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>

#### Linux Install
<details><summary>Ubuntu Install Steps</summary>

```
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip neovim
```
</details>
<details><summary>Debian Install Steps</summary>

```
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip curl

# Now we install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim-linux64
sudo mkdir -p /opt/nvim-linux64
sudo chmod a+rX /opt/nvim-linux64
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# make it available in /usr/local/bin, distro installs to /usr/bin
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/
```
</details>
<details><summary>Fedora Install Steps</summary>

```
sudo dnf install -y gcc make git ripgrep fd-find unzip neovim
```
</details>

<details><summary>Arch Install Steps</summary>

```
sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim
```
</details>

