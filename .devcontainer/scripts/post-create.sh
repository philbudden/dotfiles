#!/usr/bin/env bash
set -euo pipefail

if [ -n "${CHEZMOI_INIT_REPO:-}" ]; then
  if [ -d "$HOME/.local/share/chezmoi/.git" ]; then
    echo "chezmoi already initialized; skipping automatic init."
  else
    echo "Initializing chezmoi from ${CHEZMOI_INIT_REPO}"
    if [ -n "${CHEZMOI_INIT_ARGS:-}" ]; then
      # shellcheck disable=SC2086
      chezmoi init --apply ${CHEZMOI_INIT_ARGS} "${CHEZMOI_INIT_REPO}"
    else
      chezmoi init --apply "${CHEZMOI_INIT_REPO}"
    fi
  fi
fi

cat <<'MESSAGE'
Devcontainer ready.

Preferred host auth sharing:
  - Run `gh auth login` on the host once.
  - Before creating or rebuilding the container, export `GH_TOKEN="$(gh auth token)"`.
  - Set `GITHUB_TOKEN="$GH_TOKEN"` as well if other tools expect it.

Optional advanced auth sharing:
  - If your devcontainer tooling supports extra bind mounts and your GitHub CLI auth is already file-backed,
    mount that directory read-only and set `GH_CONFIG_DIR` before creating the container.
  - This is tooling-specific and does not work when the host keeps credentials only in a system keychain.

Optional dotfiles bootstrap:
  - Set CHEZMOI_INIT_REPO on the host before creating the container.
  - Or run: chezmoi init --apply <github-user-or-repo>
MESSAGE
