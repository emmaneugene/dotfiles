#!/usr/bin/env python3

"""Symlink dotfiles to home directory with tree-structured output.

Creates symlinks from ./dotfiles to $HOME. Existing non-symlinked files are
backed up with .bak extension before being replaced. Results are displayed
in separate tree structures grouped by status:
  [OK] Successfully symlinked
  [BACKUP] Files that were backed up
  [FAILED] Files that failed to symlink

Example:
    $ python symlink.py
    $ python symlink.py --dry-run
"""

import argparse
import filecmp
import fnmatch
import shutil
import sys
from pathlib import Path
from typing import Dict, List, Tuple

# Configuration
EXCLUDE_FILES = {
    ".DS_Store",
    "README.md",
    "LICENSE",
    "symlink.py",
    "symlink.sh",
}

EXCLUDE_DIRS = {
    ".git",
}

EXCLUDE_PATTERNS = {
    "*.example",
}


def build_tree(paths: List[str]) -> Dict:
    """Build a nested dictionary tree structure from paths.

    Args:
        paths: List of file paths (e.g., ['.config/nvim/init.lua', '.zshrc'])

    Returns:
        Nested dict representing the tree structure
    """
    tree = {}

    for path in sorted(paths):
        parts = path.split("/")
        current = tree

        for part in parts[:-1]:
            if part not in current:
                current[part] = {}
            current = current[part]

        # Leaf node (file)
        current[parts[-1]] = None

    return tree


def format_tree(tree: Dict, prefix: str = "") -> List[str]:
    """Format a tree dict as lines with unicode box-drawing characters.

    Args:
        tree: Nested dict from build_tree()
        prefix: Current indentation prefix
        is_last: Whether this is the last item at this level

    Returns:
        List of formatted lines
    """
    lines = []
    items = sorted(tree.items())

    for idx, (name, subtree) in enumerate(items):
        is_last_item = idx == len(items) - 1

        # Current connector
        connector = "└── " if is_last_item else "├── "
        lines.append(prefix + connector + name)

        # Subtree connector
        if subtree is not None:
            extension = "    " if is_last_item else "│   "
            sublines = format_tree(subtree, prefix + extension)
            lines.extend(sublines)

    return lines


def remove_broken_symlinks(dirs: List[Path], dry_run: bool = False) -> List[str]:
    """Remove broken symlinks from a list of directories.

    Args:
        dirs: Directories to scan
        dry_run: If True, don't actually remove

    Returns:
        List of removed (or would-be-removed) symlink paths relative to home
    """
    removed = []
    home_dir = Path.home()
    for d in dirs:
        if not d.is_dir():
            continue
        for item in sorted(d.iterdir()):
            if item.is_symlink() and not item.exists():
                if not dry_run:
                    item.unlink()
                try:
                    removed.append(str(item.relative_to(home_dir)))
                except ValueError:
                    removed.append(str(item))
    return removed


def symlink_dotfiles(
    dotfiles_dir: Path, home_dir: Path, dry_run: bool = False, copy: bool = False
) -> Tuple[List[str], List[str], List[str], List[str]]:
    """Symlink or copy files from dotfiles directory to home.

    Args:
        dotfiles_dir: Path to dotfiles directory
        home_dir: Path to home directory
        dry_run: If True, don't actually create symlinks/copies
        copy: If True, copy files instead of symlinking

    Returns:
        Tuple of (installed_paths, backed_up_paths, failed_paths, removed_broken_paths)
    """
    symlinked = []
    backed_up = []
    failed = []
    touched_dirs: set[Path] = set()

    for dotfile_path in sorted(dotfiles_dir.rglob("*")):
        if not dotfile_path.is_file():
            continue

        rel_path = dotfile_path.relative_to(dotfiles_dir)

        filename = dotfile_path.name

        # Skip if excluded file or parent directory is excluded
        if (
            filename in EXCLUDE_FILES
            or any(fnmatch.fnmatch(filename, pattern) for pattern in EXCLUDE_PATTERNS)
            or any(part in EXCLUDE_DIRS for part in rel_path.parts[:-1])
        ):
            continue

        dst_path = home_dir / rel_path
        dst_dir = dst_path.parent
        touched_dirs.add(dst_dir)
        try:
            if not dry_run:
                dst_dir.mkdir(parents=True, exist_ok=True)
        except OSError as _:
            failed.append(str(rel_path))
            continue

        if dst_path.exists() or dst_path.is_symlink():
            if dst_path.is_symlink():
                if not dry_run:
                    dst_path.unlink()
            elif filecmp.cmp(dotfile_path, dst_path, shallow=False):
                # Contents are identical, no backup needed
                if not dry_run:
                    dst_path.unlink()
            else:
                backup_path = Path(str(dst_path) + ".bak")
                try:
                    if not dry_run:
                        dst_path.rename(backup_path)
                    backed_up.append(str(rel_path) + ".bak")
                except OSError as _:
                    failed.append(str(rel_path))
                    continue

        try:
            if not dry_run:
                if copy:
                    shutil.copy2(dotfile_path, dst_path)
                else:
                    dst_path.symlink_to(dotfile_path.resolve())
            symlinked.append(str(rel_path))
        except OSError as _:
            failed.append(str(rel_path))

    removed = remove_broken_symlinks(sorted(touched_dirs), dry_run=dry_run)
    return symlinked, backed_up, failed, removed


def main() -> int:
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Symlink dotfiles to home directory with tree output",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                    # Run normally
  %(prog)s --dry-run          # Preview changes without making them
  %(prog)s --copy             # Copy files instead of symlinking
        """,
    )

    parser.add_argument(
        "-d",
        "--dry-run",
        action="store_true",
        help="Preview changes without creating symlinks",
    )
    parser.add_argument(
        "-c",
        "--copy",
        action="store_true",
        help="Copy files instead of symlinking (broken symlink cleanup still runs)",
    )

    args = parser.parse_args()

    # Paths
    dotfiles_dir = Path.cwd() / "dotfiles"
    home_dir = Path.home()

    # Validate
    if not dotfiles_dir.exists():
        print(
            f"[ERROR] dotfiles directory not found at {dotfiles_dir}", file=sys.stderr
        )
        return 1

    if args.dry_run:
        print("[DRY-RUN] No changes will be made\n", file=sys.stderr)

    try:
        # Symlink or copy files
        symlinked, backed_up, failed, removed = symlink_dotfiles(
            dotfiles_dir, home_dir, dry_run=args.dry_run, copy=args.copy
        )
    except KeyboardInterrupt:
        print("\n[CANCELLED] Operation cancelled by user", file=sys.stderr)
        return 130
    except Exception as e:
        print(f"[ERROR] Unexpected error: {e}", file=sys.stderr)
        return 1

    # Print results
    print("\n" + "=" * 60)

    reset = "\033[0m"
    for title, paths, tag, color in [
        ("Copied" if args.copy else "Symlinked", symlinked, "[OK]", "\033[32m"),
        ("Backed Up", backed_up, "[BACKUP]", "\033[36m"),
        ("Removed Broken", removed, "[CLEANED]", "\033[33m"),
        ("Failed", failed, "[FAILED]", "\033[31m"),
    ]:
        if paths:
            print(f"\n{color}{tag} {title} ({len(paths)}){reset}")
            print(f"{color}{'─' * 60}{reset}")
            tree = build_tree(paths)
            for line in format_tree(tree):
                print(f"{color}{line}{reset}")

    # Summary
    print(f"\n{'=' * 60}")
    action_word = "copied" if args.copy else "symlinked"
    print(
        f"[SUMMARY] {len(symlinked)} {action_word}, {len(backed_up)} backed up, {len(removed)} cleaned, {len(failed)} failed"
    )
    print("=" * 60)

    if args.dry_run:
        print(
            "\n[DRY-RUN] This was a dry-run. Re-run without --dry-run to make changes.",
            file=sys.stderr,
        )

    return 0 if failed == [] else 1


if __name__ == "__main__":
    sys.exit(main())
