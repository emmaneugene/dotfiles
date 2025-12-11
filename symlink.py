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

import sys
import argparse
import fnmatch
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


def symlink_dotfiles(
    dotfiles_dir: Path, home_dir: Path, dry_run: bool = False
) -> Tuple[List[str], List[str], List[str]]:
    """Symlink files from dotfiles directory to home.

    Args:
        dotfiles_dir: Path to dotfiles directory
        home_dir: Path to home directory
        dry_run: If True, don't actually create symlinks

    Returns:
        Tuple of (symlinked_paths, backed_up_paths, failed_paths)
    """
    symlinked = []
    backed_up = []
    failed = []

    for dotfile_path in sorted(dotfiles_dir.rglob("*")):
        if not dotfile_path.is_file():
            continue

        rel_path = dotfile_path.relative_to(dotfiles_dir)

        filename = dotfile_path.name

        # Skip if excluded file or parent directory is excluded
        if filename in EXCLUDE_FILES or any(
            fnmatch.fnmatch(filename, pattern) for pattern in EXCLUDE_PATTERNS
        ) or any(
            part in EXCLUDE_DIRS for part in rel_path.parts[:-1]
        ):
            continue

        dst_path = home_dir / rel_path
        dst_dir = dst_path.parent
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
                dst_path.symlink_to(dotfile_path.resolve())
            symlinked.append(str(rel_path))
        except OSError as _:
            failed.append(str(rel_path))

    return symlinked, backed_up, failed


def main() -> int:
    """Main entry point."""
    parser = argparse.ArgumentParser(
        description="Symlink dotfiles to home directory with tree output",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s dotfiles           # Symlink files from ./dotfiles to $HOME
  %(prog)s dotfiles --dry-run # Preview changes without making them
        """,
    )

    parser.add_argument(
        "directory",
        help="Directory containing dotfiles to symlink",
    )

    parser.add_argument(
        "-d",
        "--dry-run",
        action="store_true",
        help="Preview changes without creating symlinks",
    )

    args = parser.parse_args()

    # Paths
    dotfiles_dir = Path.cwd() / args.directory
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
        # Symlink files
        symlinked, backed_up, failed = symlink_dotfiles(
            dotfiles_dir, home_dir, dry_run=args.dry_run
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
        ("Symlinked", symlinked, "[OK]", "\033[32m"),
        ("Backed Up", backed_up, "[BACKUP]", "\033[36m"),
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
    print(
        f"[SUMMARY] {len(symlinked)} symlinked, {len(backed_up)} backed up, {len(failed)} failed"
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
