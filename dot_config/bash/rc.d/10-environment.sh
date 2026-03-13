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

export EDITOR="${EDITOR:-nvim}"
export BAT_THEME="${BAT_THEME:-gruvbox-dark}"
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always {}"'
export GOPATH="${GOPATH:-$HOME/go}"

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"
path_append "$GOPATH/bin"

export PATH
