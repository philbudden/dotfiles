#!/usr/bin/env bash
set -euo pipefail

mkdir -p "${GH_CONFIG_DIR:-$HOME/.config/gh}"

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

Optional host auth sharing:
  - Mount a host GitHub CLI config directory to /tmp/host-gh and keep GH_CONFIG_DIR=/tmp/host-gh.
  - Or pass GH_TOKEN / GITHUB_TOKEN from the host.

Optional dotfiles bootstrap:
  - Set CHEZMOI_INIT_REPO on the host before creating the container.
  - Or run: chezmoi init --apply <github-user-or-repo>
MESSAGE
