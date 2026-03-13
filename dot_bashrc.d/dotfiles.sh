# shellcheck shell=bash

if [ "${DOTFILES_BASH_LOADED:-0}" = "1" ]; then
  return
fi
export DOTFILES_BASH_LOADED=1

for file in "$HOME"/.config/bash/rc.d/*.sh; do
  [ -r "$file" ] || continue
  . "$file"
done
