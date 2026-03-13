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
- `.chezmoiignore` keeps repository-only files like `README.md` and `.devcontainer/` out of the target home directory

The package hook will install Homebrew packages when `brew` exists. If `gh auth status` does not succeed, it skips `gh` extensions instead of starting an interactive login flow.

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

### Preferred option: pass through a host-derived token

1. Authenticate once on the host:

```sh
gh auth login
```

2. Before creating or rebuilding the container, export a host-derived token:

```sh
export GH_TOKEN="$(gh auth token)"
export GITHUB_TOKEN="$GH_TOKEN"
```

The base `devcontainer.json` passes those variables through from the host environment, so `gh`, `gh-copilot`, `copilot-cli`, `coderabbit-cli`, and other GitHub-aware tools can reuse the host authentication without storing credentials in this repository or prompting on every rebuild.

This is the portable default because it works whether the host stores GitHub CLI credentials in a keychain, a credential manager, or a plain file.

### Optional advanced option: reuse a file-backed GitHub CLI config

If your devcontainer tooling supports extra bind mounts and your host `gh` credentials are already stored in files, you can mount that directory read-only and set `GH_CONFIG_DIR` before creating the container.

This is intentionally not baked into the repository because it is tooling-specific and does not work on hosts where `gh` uses a system credential store instead of file-backed credentials.

## Devcontainer design

The devcontainer is intentionally generic:

- standard devcontainer spec
- terminal-first and editor-agnostic
- no VS Code-specific assumptions
- includes Homebrew and Chezmoi as features
- optional automatic `chezmoi init --apply` through `CHEZMOI_INIT_REPO`
- passes through host-provided GitHub token environment variables

To auto-initialize a user's own dotfiles inside the container, set this on the host before creating the container:

```sh
export CHEZMOI_INIT_REPO=<github-user-or-repo>
```

For secrets or user-specific config, prefer one of these:

- pass environment variables from the host
- use tool-specific bind mounts outside this repository when you need them
- keep user-specific data in local, untracked files outside this repo

## Notes

- `dot_gitconfig` keeps only universal Git behavior and deliberately does not hardcode a user name or email.
- In fresh environments, set your Git identity once before committing:
  `git config --global user.name "Your Name"` and `git config --global user.email "you@example.com"`.
- `dot_tmux.conf` and Ghostty config were made portable by removing hardcoded Homebrew paths.
- leftover upstream Neovim repository artifacts were pruned so the repo stays focused on actual dotfiles.
