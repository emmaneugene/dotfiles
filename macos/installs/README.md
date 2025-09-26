# MacOS packages

Contains lists of software to be installed across various package managers or language runtimes

Install homebrew casks and formulae:

```bash
brew install --cask $(cat brew-casks.txt)
brew install --formula $(cat brew-formulae.txt)
```

Install packages for specific python versions with `pip install`:

```bash
python3.X -m pip install -r pip.txt
```

Install node packages with `npm install`:

```bash
npm install -g $(cat npm.txt)
# If on asdf, you may need to reshim binaries
asdf reshim nodejs
```

Install rust packages with `cargo install`:

```bash
cargo install difftastic
# ...
```

Install go packages with `go install`:

```bash
go install github.com/x-motemen/gore/cmd/gore@latest
# ...
```

Install `uv` tools:

```bash
uv tool install --python=3.12 aider-chat
# ...
```

Install VSCode/Cursor extensions:

```bash
cat vsc-extensions.txt | xargs -I {} code --install-extension {}
```
