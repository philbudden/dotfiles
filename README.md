# Dotfiles

Devcontainer-first dotfiles for my VS Code workflow.

This repository manages a small CLI and terminal setup for the environments where development actually happens: devcontainers. It does not try to provision my Mac, WSL2 host, graphical applications, Docker Desktop, OrbStack, Docker Engine, or machine-specific package recipes.

## What This Repo Manages

- Portable CLI/development tools through `Brewfile`.
- Dotfiles through GNU Stow packages under `stow/`.
- Shell, Git, Starship and tmux configuration.
- Installation of the separate Neovim configuration repository into `~/.config/nvim`.

## What This Repo Does Not Manage

- macOS graphical applications.
- Host terminal applications.
- Ghostty configuration.
- Docker Desktop, OrbStack or Docker Engine setup.
- WSL2 provisioning.
- SSH private keys.
- Machine hostname profiles.
- Neovim configuration internals.
- Project-specific language runtimes or dependencies.

Project tooling should normally live in the relevant repository's devcontainer, not in this dotfiles repo.

## Repository Layout

```text
.
├── Brewfile
├── README.md
├── bootstrap.sh
└── stow
    ├── git
    │   └── .gitconfig
    ├── shell
    │   ├── .bash_profile
    │   ├── .bashrc
    │   └── .hushlogin
    ├── starship
    │   └── .config/starship.toml
    └── tmux
        └── .tmux.conf
```

## Bootstrap In A New Devcontainer

Clone the repo inside the devcontainer, then run the bootstrap script:

```bash
git clone git@github.com:philbudden/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
./bootstrap.sh
```

The script will:

1. Load Homebrew if it is already installed.
2. Install Homebrew automatically when it appears to be running inside a container and Homebrew is missing.
3. Run `brew bundle --file Brewfile`.
4. Link the Stow packages into `$HOME`.
5. Clone or update `git@github.com:philbudden/neovim-config.git` into `~/.config/nvim`.

After it finishes, restart the shell or run:

```bash
source ~/.bashrc
```

## Bootstrap On A Host

Host setup is deliberately out of scope. If I choose to apply the same dotfiles on macOS or WSL2, Homebrew must already be installed. Then I can run:

```bash
cd ~/Developer/dotfiles
./bootstrap.sh
```

The script will not install Homebrew automatically on a host. This is intentional: the host should remain mostly untouched, and daily development should happen inside devcontainers.

## Packages

`Brewfile` contains portable CLI tools only:

- `bat`
- `fd`
- `fzf`
- `gh`
- `jq`
- `neovim`
- `ripgrep`
- `starship`
- `stow`
- `tmux`
- `unzip`
- `zip`
- `zoxide`

Do not add graphical applications, host services, Docker packages, WSL setup packages, or project-specific runtimes here unless they are genuinely useful across most devcontainers.

## Dotfile Linking

Dotfiles are linked with GNU Stow:

```bash
stow --dir stow --target "$HOME" shell git starship tmux
```

Run this manually after changing Stow packages if package installation is not needed.

## Neovim

`neovim` is installed as a CLI tool through `Brewfile`. The actual configuration lives in the separate `git@github.com:philbudden/neovim-config.git` repository.

During bootstrap, this repo clones that configuration into `~/.config/nvim` when it is missing. If `~/.config/nvim` is already a clone of the same repository, bootstrap updates it with `git pull --ff-only`. If another Git-backed Neovim config already exists, bootstrap leaves it unchanged and reports the different origin. If a non-Git config already exists, bootstrap moves it aside with a timestamped `.backup.YYYYMMDDHHMMSS` suffix before cloning.

To use a different source temporarily:

```bash
NVIM_CONFIG_REPO=git@github.com:example/neovim-config.git ./bootstrap.sh
```

## Git And SSH

The repo manages generic Git defaults only. SSH keys and host-specific Git identities should remain outside the repo.

For multiple GitHub organisations, use SSH host aliases and Git configuration that points individual repositories or directory trees at the right identity. Keep private keys out of this repository.

## Design Notes

This repo used to use Chezmoi with hostname-based package profiles. That was useful when hosts were the primary development environments. The current workflow is different: VS Code connects to Mac/WSL hosts, and the real development tooling lives inside devcontainers.

The simpler model is now:

1. Build or enter a devcontainer.
2. Clone this repo.
3. Run `./bootstrap.sh`.
4. Work inside the container.

No hostname detection, templating, package-manager orchestration, GUI app installation, or host provisioning is needed.
