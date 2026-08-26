if [ -f "$HOME/.config/shell/env.sh" ]; then
    source "$HOME/.config/shell/env.sh"
fi

case "$-" in
    *i*) ;;
    *) return ;;
esac

if [ -f "$HOME/.config/shell/interactive.sh" ]; then
    source "$HOME/.config/shell/interactive.sh"
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi
