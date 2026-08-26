if [ -n "${PHIL_DOTFILES_INTERACTIVE_LOADED:-}" ]; then
    return 0 2>/dev/null || exit 0
fi
export PHIL_DOTFILES_INTERACTIVE_LOADED=1

# Shared interactive aliases and functions go here when they work unchanged in
# both Bash and Zsh. Keep shell-specific completions, prompt hooks and key
# bindings in the relevant shell entrypoint.
