# Homebrew environment setup
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Path configuration
export PATH="$HOME/.config/tmux/bin:$HOME/.local/bin:$PATH"

# Shell Aliases
alias lg="lazygit"
alias cat="bat"
alias ls="eza --icons --git"
alias top="btm"
alias tmux="tmux -u"
alias tl="tmux ls"
alias ts="ta"

# Tool Integrations
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

# Persistent Agent Jail (attaches to long-running container with tmux)
jail() {
  if ! podman container inspect agent-jail &>/dev/null; then
    echo "Creating persistent agent-jail container..."
    podman run -d \
      --name agent-jail \
      --restart unless-stopped \
      -v "$HOME/projects:/home/michalgr/workspace" \
      agent-jail sleep infinity
  else
    podman start agent-jail &>/dev/null
  fi

  if [[ $# -gt 0 ]]; then
    podman exec -it agent-jail zsh -l -c "$*"
  else
    podman exec -it agent-jail zsh -l -c "ta"
  fi
}

# One-off throwaway container (destroyed on exit)
jail-ephemeral() {
  podman run -it --rm -v "$(pwd):/home/michalgr/workspace" agent-jail "$@"
}

