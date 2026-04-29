#!/usr/bin/env bash
# ln -s ~/nixos-config/modules/development/python/nixpy ~/.local/bin 
# then run: nixpy
set -euo pipefail

if [[ $# -eq 0 ]]; then
  printf 'Usage: nixpy.sh <python-script> [args...]\n' >&2
  exit 1
fi

SCRIPT_PATH="$(readlink -f -- "${BASH_SOURCE[0]}")"
FLAKE_DIR="$(cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)"

exec nix run "path:${FLAKE_DIR}" -- "$@"