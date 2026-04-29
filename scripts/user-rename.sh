#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

usage() {
  cat <<'EOF'
Usage:
  ~/nixos-config/scripts/user-rename.sh <old-base-user> <new-base-user>

Example:
  ~/nixos-config/scripts/user-rename.sh muffin blueberry

What it changes:
  - text replacements across the repo for:
      old-base-user
      old-base-user-server
      old-base-user-minimal
      /home/old-base-user
  - curated path renames under modules/users/, including:
      modules/users/<user>/
      modules/users/<user>-server/
      modules/users/<user>-minimal/
      home-<user>.nix style files

What it does NOT do:
  - blind path renames across the whole repo
  - automatic git commits
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

old_base="${1:-}"
new_base="${2:-}"

if [[ -z "$old_base" ]]; then
  read -r -p "Old base username: " old_base
fi

if [[ -z "$new_base" ]]; then
  read -r -p "New base username: " new_base
fi

if [[ -z "$old_base" || -z "$new_base" ]]; then
  echo "Both old and new usernames are required." >&2
  exit 1
fi

if [[ "$old_base" == "$new_base" ]]; then
  echo "Old and new usernames are the same. Nothing to do." >&2
  exit 1
fi

old_server="${old_base}-server"
new_server="${new_base}-server"
old_minimal="${old_base}-minimal"
new_minimal="${new_base}-minimal"

RG_GLOBS=(
  --glob '!**/.git/**'
  --glob '!**/node_modules/**'
  --glob '!**/result/**'
  --glob '!**/backups/**'
  --glob '!**/.direnv/**'
  --glob '!**/scroll-flake.bak/**'
)

replace_text() {
  local old_text=$1
  local new_text=$2
  local -a files=()

  mapfile -d '' -t files < <(
    rg -l -0 -F --hidden "${RG_GLOBS[@]}" -- "$old_text" "$REPO_ROOT"
  )

  if (( ${#files[@]} == 0 )); then
    return
  fi

  echo "Replacing '$old_text' -> '$new_text' in ${#files[@]} files"
  local file
  for file in "${files[@]}"; do
    OLD_TEXT="$old_text" NEW_TEXT="$new_text" \
      perl -0pi -e 's/\Q$ENV{OLD_TEXT}\E/$ENV{NEW_TEXT}/g' "$file"
  done
}

rename_path_if_exists() {
  local old_path=$1
  local new_path=$2

  if [[ ! -e "$old_path" ]]; then
    return
  fi

  if [[ -e "$new_path" ]]; then
    echo "Refusing to rename because target already exists:" >&2
    echo "  $old_path" >&2
    echo "  -> $new_path" >&2
    exit 1
  fi

  mv -- "$old_path" "$new_path"
  echo "Renamed path:"
  echo "  $old_path"
  echo "  -> $new_path"
}

echo "Repo root:"
echo "  $REPO_ROOT"
echo
echo "Planned replacements:"
echo "  $old_server -> $new_server"
echo "  $old_minimal -> $new_minimal"
echo "  $old_base -> $new_base"
echo "  /home/$old_base -> /home/$new_base"
echo
echo "Planned curated path renames:"
echo "  modules/users/$old_base/home-$old_base.nix -> modules/users/$old_base/home-$new_base.nix"
echo "  modules/users/$old_server/home-$old_server.nix -> modules/users/$old_server/home-$new_server.nix"
echo "  modules/users/$old_minimal/home-$old_minimal.nix -> modules/users/$old_minimal/home-$new_minimal.nix"
echo "  modules/users/$old_base -> modules/users/$new_base"
echo "  modules/users/$old_server -> modules/users/$new_server"
echo "  modules/users/$old_minimal -> modules/users/$new_minimal"
echo

read -r -p "Proceed? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  exit 0
fi

# Replace longer variants first so base-user replacement does not partially
# transform suffixed usernames first.
replace_text "/home/$old_server" "/home/$new_server"
replace_text "/home/$old_minimal" "/home/$new_minimal"
replace_text "/home/$old_base" "/home/$new_base"
replace_text "$old_server" "$new_server"
replace_text "$old_minimal" "$new_minimal"
replace_text "$old_base" "$new_base"

# Rename curated repo paths after text replacement.
rename_path_if_exists \
  "$REPO_ROOT/modules/users/$old_base/home-$old_base.nix" \
  "$REPO_ROOT/modules/users/$old_base/home-$new_base.nix"

rename_path_if_exists \
  "$REPO_ROOT/modules/users/$old_server/home-$old_server.nix" \
  "$REPO_ROOT/modules/users/$old_server/home-$new_server.nix"

rename_path_if_exists \
  "$REPO_ROOT/modules/users/$old_minimal/home-$old_minimal.nix" \
  "$REPO_ROOT/modules/users/$old_minimal/home-$new_minimal.nix"

rename_path_if_exists \
  "$REPO_ROOT/modules/users/$old_base" \
  "$REPO_ROOT/modules/users/$new_base"

rename_path_if_exists \
  "$REPO_ROOT/modules/users/$old_server" \
  "$REPO_ROOT/modules/users/$new_server"

rename_path_if_exists \
  "$REPO_ROOT/modules/users/$old_minimal" \
  "$REPO_ROOT/modules/users/$new_minimal"

echo
echo "Username migration complete."
echo "Review changes with:"
echo "  git -C \"$REPO_ROOT\" diff --stat"
echo "  git -C \"$REPO_ROOT\" diff"
