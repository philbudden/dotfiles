#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

is_container() {
    [ -f /.dockerenv ] || [ -f /run/.containerenv ] || [ -n "${REMOTE_CONTAINERS:-}" ] || [ -n "${DEVCONTAINER:-}" ]
}

load_brew() {
    if command -v brew >/dev/null 2>&1; then
        return 0
    fi

    if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        return 0
    fi

    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        return 0
    fi

    return 1
}

install_homebrew_for_container() {
    if ! command -v bash >/dev/null 2>&1 || ! command -v curl >/dev/null 2>&1; then
        echo "Homebrew is not installed, and this environment is missing bash or curl."
        echo "Install those base packages using the container image or devcontainer features, then rerun this script."
        exit 1
    fi

    echo "Installing Homebrew for this container..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

if ! load_brew; then
    if is_container; then
        install_homebrew_for_container
    else
        echo "Homebrew is not installed."
        echo "This bootstrap is devcontainer-first and will not install host tooling automatically."
        echo "Install Homebrew manually if you want to apply these dotfiles on a host, then rerun ./bootstrap.sh."
        exit 1
    fi
fi

echo "Installing CLI tools from Brewfile..."
brew bundle --file "$repo_dir/Brewfile"

echo "Linking dotfiles with GNU Stow..."
stow --dir "$repo_dir/stow" --target "$HOME" shell git starship tmux

echo "Done. Restart the shell, or run: source ~/.bashrc"
