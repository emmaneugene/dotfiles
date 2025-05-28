# Shell completions

On ZSH, to find out where all your shell completions are sourced from:

```bash
echo $FPATH | tr ':' '\n'
```

To find all completion files across these directories:

```bash
for dir in $fpath; do
  [[ -d "$dir" ]] && find "$dir" -type f -name "_*"
done | sort
```
