### `gitignore`
Symlink or copy `global.gitignore` to `~/.gitignore`, then add this entry into `~/.gitconfig`:

```
[core]
	excludesfile = ~/.gitignore
```

### `gitmessage`
Symlink or copy `global.gitmessage` to `~/.gitmessage`, then add this entry into `~/.gitconfig`:
```
[commit]
	template = ~/.gitmessage
```