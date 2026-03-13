# shellcheck shell=bash

if command -v brew >/dev/null 2>&1; then
  brew_prefix="$(brew --prefix)"
  if [ -r "$brew_prefix/etc/profile.d/bash_completion.sh" ]; then
    . "$brew_prefix/etc/profile.d/bash_completion.sh"
  fi
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
