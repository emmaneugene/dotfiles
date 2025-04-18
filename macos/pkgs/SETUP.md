# MacOS packages

Contains lists of software to be installed by various

Install brew casks and formulae

```bash
brew install --cask $(cat brew-casks.txt)
brew install --formula $(cat brew-formulae.txt)
```

Install python packages with `pip`:

```bash
python3.X -m pip install -r pip.txt
```

Install node packages with `npm`:

```bash
npm install -g $(cat npm.txt)
```

Install rust packages with `cargo`

Install go packages `go` 
