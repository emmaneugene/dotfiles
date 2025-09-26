# MacOS packages

Contains lists of software to be installed by various

Install brew casks and formulae

```bash
brew install --cask $(cat brew-casks.txt)
brew install --formula $(cat brew-formulae.txt)
```

Install python packages with `pip install`, while specifying your desired python version:

```bash
python3.X -m pip install -r pip.txt
```

Install node packages with `npm install`:

```bash
npm install -g $(cat npm.txt)
# If on asdf, reshim the binaries
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

Install `uv` tools :

```bash
uv tool install --python=3.12 aider-chat
# ...
```
