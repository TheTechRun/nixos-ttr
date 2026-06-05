#!/usr/bin/env bash
set -euo pipefail

repo_root="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
    pwd
)"

cd "$repo_root"

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  printf 'error: %s is not inside a git repository\n' "$repo_root" >&2
  exit 1
fi

print_phase_progress() {
  local label="$1"
  local count="$2"

  if (( count == 1 || count % 250 == 0 )); then
    printf '%s processed: %d\n' "$label" "$count"
  fi
}

is_executable_file() {
  local path="$1"
  local first_line=""

  case "$path" in
    scripts/* | *.sh | *.bash | *.zsh | *.fish | *.py | *.pl | *.rb)
      return 0
      ;;
  esac

  if IFS= read -r first_line <"$path"; then
    [[ "$first_line" == '#!'* ]]
    return
  fi

  return 1
}

safe_chmod() {
  local mode="$1"
  local path="$2"

  if chmod "$mode" -- "$path"; then
    return 0
  fi

  printf 'warning: could not set %s on %s\n' "$mode" "$path" >&2
  ((failed_chmod_count += 1))
  return 1
}

dir_count=0
file_count=0
exec_count=0
skipped_symlink_count=0
failed_chmod_count=0

printf 'Setting directory permissions to 755 under %s\n' "$repo_root"

while IFS= read -r -d '' dir; do
  safe_chmod 755 "$dir" || continue
  ((dir_count += 1))
  print_phase_progress "Directories" "$dir_count"
done < <(find . -path './.git' -prune -o -type d -print0)

printf 'Setting tracked file permissions\n'

while IFS= read -r -d '' path; do
  if [[ -L "$path" ]]; then
    ((skipped_symlink_count += 1))
    continue
  fi

  [[ -f "$path" ]] || continue

  if is_executable_file "$path"; then
    safe_chmod 755 "$path" || continue
    ((exec_count += 1))
  else
    safe_chmod 644 "$path" || continue
  fi

  ((file_count += 1))
  print_phase_progress "Files" "$file_count"
done < <(git ls-files -z)

printf 'Done\n'
printf 'Set %d directories to 755\n' "$dir_count"
printf 'Set %d executable files to 755\n' "$exec_count"
printf 'Set %d non-executable files to 644\n' "$((file_count - exec_count))"

if (( skipped_symlink_count > 0 )); then
  printf 'Skipped %d symlink entries\n' "$skipped_symlink_count"
fi

if (( failed_chmod_count > 0 )); then
  printf 'Encountered %d chmod failures\n' "$failed_chmod_count"
fi
