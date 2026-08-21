# Dotfiles

Devcontainer-first dotfiles for my VS Code workflow.

This repository manages a small CLI and terminal setup for the environments where development actually happens: devcontainers. It does not try to provision my Mac, WSL2 host, graphical applications, Docker Desktop, OrbStack, Docker Engine, or machine-specific package recipes.

## What This Repo Manages

- Portable CLI/development tools through `Brewfile`.
- Dotfiles through GNU Stow packages under `stow/`.
- Shell, Git, Starship and tmux configuration.

## What This Repo Does Not Manage

- macOS graphical applications.
- Host terminal applications.
- Ghostty configuration.
- Docker Desktop, OrbStack or Docker Engine setup.
- WSL2 provisioning.
- SSH private keys.
- Machine hostname profiles.
- Neovim configuration.
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

`neovim` is installed as a CLI tool through `Brewfile`, but this repository does not currently manage `~/.config/nvim`.

Neovim configuration will move to a separate repository so it can keep its own Kickstart-based history and update process. Once that repository exists, bootstrap can grow a small clone/update step for it.

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
