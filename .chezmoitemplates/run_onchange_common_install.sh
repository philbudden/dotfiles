#!/bin/bash
{{ range .packages.nix.common -}}
nix-env -iA {{ . | quote }}
{{ end -}}
