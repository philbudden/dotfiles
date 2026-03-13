# shellcheck shell=bash

path_prepend() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_append() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
}

init_brew_shellenv() {
  local brew_bin

  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  else
    for brew_bin in \
      /opt/homebrew/bin/brew \
      /usr/local/bin/brew \
      /home/linuxbrew/.linuxbrew/bin/brew
    do
      [ -x "$brew_bin" ] && break
    done
  fi

  [ -x "${brew_bin:-}" ] || return 0
  eval "$("$brew_bin" shellenv)"
}

init_brew_shellenv

export EDITOR="${EDITOR:-nvim}"
export BAT_THEME="${BAT_THEME:-gruvbox-dark}"
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always {}"'
export GOPATH="${GOPATH:-$HOME/go}"

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
path_append "$GOPATH/bin"

export PATH
