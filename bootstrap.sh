#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Bootstrapping dotfiles from $DOTFILES_DIR"

# 0. Initialize git submodules (e.g. tmux-config)
git -C "$DOTFILES_DIR" submodule update --init --recursive

# 1. Install Homebrew packages
if command -v brew &>/dev/null; then
  echo "==> Installing packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"
else
  echo "WARNING: Homebrew not found. Please install Homebrew first."
fi

# 2. Ensure target config directory exists
mkdir -p "$HOME/.config"

# 3. Clean up empty placeholder directories if present to let stow manage them
if [ -d "$HOME/.config/helix" ] && [ -z "$(ls -A "$HOME/.config/helix" 2>/dev/null)" ]; then
  rmdir "$HOME/.config/helix"
fi
if [ -d "$HOME/.config/ghostty" ] && [ -z "$(ls -A "$HOME/.config/ghostty" 2>/dev/null)" ]; then
  rmdir "$HOME/.config/ghostty"
fi

# 4. Stow dotfiles packages
PACKAGES=(ghostty git helix starship tmux zsh)

echo "==> Stowing packages: ${PACKAGES[*]}"
for pkg in "${PACKAGES[@]}"; do
  echo "  - Stowing $pkg..."
  stow -v -R -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
done

echo "==> Setup complete! Please restart your shell or run: source ~/.zshrc"
