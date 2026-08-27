#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
nvim_config_repo="${NVIM_CONFIG_REPO:-https://github.com/philbudden/neovim-config.git}"
nvim_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
stow_packages=(shell git starship)

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

ensure_c_compiler() {
    if command -v cc >/dev/null 2>&1; then
        return 0
    fi

    if [ "$(uname -s)" != "Linux" ]; then
        return 0
    fi

    echo "No C compiler found. Installing build-essential for Neovim Treesitter parser builds..."

    if command -v apt-get >/dev/null 2>&1; then
        if [ "$(id -u)" -eq 0 ]; then
            apt-get update
            apt-get install -y build-essential
        elif command -v sudo >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y build-essential
        else
            echo "sudo is not available. Install build-essential manually, then rerun ./bootstrap.sh:"
            echo "  apt-get update && apt-get install -y build-essential"
            exit 1
        fi
    else
        echo "No supported system package manager found for installing a C compiler."
        echo "Install a system C compiler so Neovim Treesitter can build parsers, then rerun ./bootstrap.sh."
        exit 1
    fi

    if ! command -v cc >/dev/null 2>&1; then
        echo "build-essential installation completed, but cc is still not available on PATH."
        exit 1
    fi
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

install_neovim_config() {
    mkdir -p "$(dirname "$nvim_config_dir")"

    if [ -d "$nvim_config_dir/.git" ]; then
        current_remote="$(git -C "$nvim_config_dir" remote get-url origin 2>/dev/null || true)"
        if [ "$current_remote" = "$nvim_config_repo" ]; then
            echo "Updating Neovim config..."
            git -C "$nvim_config_dir" pull --ff-only
            return 0
        fi

        echo "Existing Neovim config at $nvim_config_dir has a different origin: $current_remote"
        echo "Leaving it unchanged."
        return 0
    fi

    if [ -e "$nvim_config_dir" ] || [ -L "$nvim_config_dir" ]; then
        backup="${nvim_config_dir}.backup.$(date +%Y%m%d%H%M%S)"
        echo "Moving existing Neovim config to $backup"
        mv "$nvim_config_dir" "$backup"
    fi

    echo "Installing Neovim config..."
    git clone "$nvim_config_repo" "$nvim_config_dir"
}

backup_stow_conflicts() {
    backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d%H%M%S)"
    made_backup_dir=0

    for package in "${stow_packages[@]}"; do
        while IFS= read -r -d '' source_path; do
            relative_path="${source_path#"$repo_dir/stow/$package/"}"
            target_path="$HOME/$relative_path"

            if [ -L "$target_path" ]; then
                continue
            fi

            if [ -e "$target_path" ]; then
                if [ "$made_backup_dir" -eq 0 ]; then
                    mkdir -p "$backup_dir"
                    made_backup_dir=1
                fi

                backup_path="$backup_dir/$relative_path"
                mkdir -p "$(dirname "$backup_path")"
                echo "Moving existing $target_path to $backup_path"
                mv "$target_path" "$backup_path"
            fi
        done < <(find "$repo_dir/stow/$package" -type f -print0)
    done
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

ensure_c_compiler

echo "Installing CLI tools from Brewfile..."
brew bundle --file "$repo_dir/Brewfile"

backup_stow_conflicts

echo "Linking dotfiles with GNU Stow..."
stow --dir "$repo_dir/stow" --target "$HOME" "${stow_packages[@]}"

install_neovim_config

echo "Done. Restart the shell, or run: source ~/.bashrc"
