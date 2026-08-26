if [ -n "${PHIL_DOTFILES_ENV_LOADED:-}" ]; then
    return 0 2>/dev/null || exit 0
fi
export PHIL_DOTFILES_ENV_LOADED=1

export EDITOR="nvim"
export BAT_THEME="gruvbox-dark"
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always {}"'

path_prepend() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
