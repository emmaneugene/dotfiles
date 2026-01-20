## Core Principles
- Be as succinct as possible when writing documentation. Prefer concrete examples over description, and use mermaid or ASCII diagrams if helpful

## Tool Usage

### Use Direct Tools For:
- Specific file reads/edits (Read, Edit, Write)
- Git operations (Bash with git commands)
- Targeted grep/glob searches with known patterns
- Terminal operations (npm, docker, etc.)

## Git & Commits
- NEVER `--force-push` to main/master
- NEVER skip hooks (`--no-verify`)
- Block-at-submit hooks for test validation preferred
- Reference file locations as `path:line_number` in commits
- Sign commits only if explicitly requested

## File Operations
- Always Read before Edit/Write
- Preserve exact indentation when editing
