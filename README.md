# dotfiles

Personal macOS dotfiles managed declaratively using **Homebrew** and **GNU Stow**.

> [!NOTE]
> Designed for a lean macOS host. Language runtimes, heavy compilers, and unrestricted agent environments are kept isolated inside [agent-jail](https://github.com/michalgr/agent-jail).

## Structure

```text
.dotfiles/
├── Brewfile               # macOS formulae & tools
├── bootstrap.sh           # One-step installer (brew bundle + stow)
├── ghostty/               # Ghostty terminal configuration
├── git/                   # Git & Delta diff configuration
├── helix/                 # Helix editor configuration
├── starship/              # Starship prompt configuration
├── tmux/                  # Tmux configuration (submodule: michalgr/tmux-config)
└── zsh/                   # Zsh configuration, aliases, and agent-jail helper
```

## Quick Start (New Machine)

1. Install Homebrew (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Clone this repository (with submodules):
   ```bash
   git clone --recurse-submodules git@github.com:michalgr/.dotfiles.git ~/projects/.dotfiles
   cd ~/projects/.dotfiles
   ```

3. Run the bootstrap script:
   ```bash
   ./bootstrap.sh
   ```

## Managing Packages

* **Stow a single package:**
  ```bash
  stow -v -R -t ~ <package-name>
  ```
* **Unstow a package:**
  ```bash
  stow -v -D -t ~ <package-name>
  ```
