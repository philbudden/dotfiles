# dotfiles

A small, portable Chezmoi repository for ephemeral development environments.

The repo now does three things only:

- applies a curated set of universal dotfiles
- installs a curated universal Homebrew package list
- adds dotfiles-managed Bash configuration without overwriting an existing `~/.bashrc`

Everything environment-specific has been removed. There is no hostname detection, no profile mapping, and no bootstrap-time `gh auth login`.

## Quick start

If `chezmoi` and `brew` are already available, one command applies the full setup:

```sh
chezmoi init --apply <github-user-or-repo>
```

In the included devcontainer, both `chezmoi` and Homebrew are already available, so the same command works there too.

## Repository structure

```text
.
├── .chezmoidata/
│   └── packages.yaml
├── .devcontainer/
│   ├── devcontainer.json
│   ├── devcontainer.local.example.json
│   └── scripts/
│       └── post-create.sh
├── dot_bashrc.d/
│   └── dotfiles.sh
├── dot_config/
│   ├── bash/rc.d/
│   ├── ghostty/
│   ├── nvim/
│   └── starship.toml
├── dot_gitconfig
├── dot_tmux.conf
├── empty_dot_hushlogin
├── run_onchange_configure-bash.sh.tmpl
└── run_onchange_install-packages.sh.tmpl
```

## Chezmoi approach

The Chezmoi model is intentionally simple:

- static dotfiles live directly in the repo
- `.chezmoidata/packages.yaml` contains the universal package list
- `run_onchange_install-packages.sh.tmpl` installs Homebrew formulae and GitHub CLI extensions idempotently
- `run_onchange_configure-bash.sh.tmpl` maintains a managed source block inside `~/.bashrc`

The package hook will install Homebrew packages when `brew` exists. If GitHub authentication is not already available through `GH_CONFIG_DIR`, `GH_TOKEN`, or `GITHUB_TOKEN`, it skips `gh` extensions instead of starting an interactive login flow.

## Safe Bash integration

This repo no longer owns `~/.bashrc`.

Instead, Chezmoi manages:

- `~/.bashrc.d/dotfiles.sh`
- `~/.config/bash/rc.d/*.sh`

During `chezmoi apply`, the Bash integration hook adds or refreshes this block in `~/.bashrc`:

```sh
# >>> dotfiles bash integration >>>
if [ -f "$HOME/.bashrc.d/dotfiles.sh" ]; then
  . "$HOME/.bashrc.d/dotfiles.sh"
fi
# <<< dotfiles bash integration <<<
```

That keeps the user in control of their own `~/.bashrc` while making the repo-managed configuration modular and repeatable.

## Sharing host GitHub authentication with containers

The recommended pattern is to authenticate on the host once, then reuse that authentication inside containers.

### Option 1: bind mount a host GitHub CLI config directory

1. Authenticate on the host.
2. Copy `.devcontainer/devcontainer.local.example.json` to `.devcontainer/devcontainer.local.json`.
3. Rebuild the container.

The example local override mounts the host GitHub CLI config directory to `/tmp/host-gh` and the base devcontainer sets `GH_CONFIG_DIR=/tmp/host-gh`. That lets `gh`, `gh-copilot`, and other tools that reuse GitHub CLI credentials work without re-authenticating in each new container.

If you prefer a dedicated host-only credential directory, authenticate like this on the host first:

```sh
GH_CONFIG_DIR="$HOME/.config/gh-devcontainer" gh auth login --insecure-storage
```

Then point your local devcontainer override at `~/.config/gh-devcontainer` instead of `~/.config/gh`.

### Option 2: inject a token from the host

The base devcontainer also passes through `GH_TOKEN` and `GITHUB_TOKEN` from the host environment. This is useful for tools that follow the standard GitHub token environment variables rather than GitHub CLI config files.

## Devcontainer design

The devcontainer is intentionally generic:

- standard devcontainer spec
- terminal-first and editor-agnostic
- no VS Code-specific assumptions
- includes Homebrew and Chezmoi as features
- optional automatic `chezmoi init --apply` through `CHEZMOI_INIT_REPO`

To auto-initialize a user's own dotfiles inside the container, set this on the host before creating the container:

```sh
export CHEZMOI_INIT_REPO=<github-user-or-repo>
```

If you need extra arguments, also set:

```sh
export CHEZMOI_INIT_ARGS='--force'
```

For secrets or user-specific config, prefer one of these:

- mount a host directory in `.devcontainer/devcontainer.local.json`
- pass environment variables from the host
- keep user-specific data in local, untracked files outside this repo

## Notes

- `dot_gitconfig` keeps only universal Git behavior and deliberately does not hardcode a user name or email.
- `dot_tmux.conf` and Ghostty config were made portable by removing hardcoded Homebrew paths.
- leftover upstream Neovim repository artifacts were pruned so the repo stays focused on actual dotfiles.
