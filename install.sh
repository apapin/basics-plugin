#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    *) echo "Usage: $0 [--dry-run]"; exit 1 ;;
  esac
done

link() {
  local src="$1" dst="$2"
  if [ "$DRY_RUN" = true ]; then
    echo "[dry-run] ln -sf $src -> $dst"
    return
  fi
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "  linked $dst -> $src"
}

echo "Installing from $REPO_DIR"
echo

# CLAUDE.md
echo "Global CLAUDE.md:"
link "$REPO_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# Hooks
echo "Hooks:"
link "$REPO_DIR/claude/hooks/inject-qmd-collections.sh" "$HOME/.claude/hooks/inject-qmd-collections.sh"

# QMD configs
echo "QMD configs:"
mkdir -p "$HOME/.config/qmd"
for yml in "$REPO_DIR"/qmd/*.yml; do
  [ -f "$yml" ] || continue
  name=$(basename "$yml")
  link "$yml" "$HOME/.config/qmd/$name"
done

echo
echo "Done. Verify with: ls -la ~/.claude/CLAUDE.md ~/.claude/hooks/ ~/.config/qmd/"
echo
echo "Manual steps (if fresh machine):"
echo "  1. Add hooks to ~/.claude/settings.json (see claude/settings.reference.json)"
echo "  2. Install plugins: claude plugin marketplace add apapin/basics-plugin"
echo "  3. Install QMD: npm install -g @tobilu/qmd"
echo "  4. Index vaults: qmd --index <name> update && qmd --index <name> embed"
