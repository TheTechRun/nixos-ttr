#!/usr/bin/env bash
set -euo pipefail

MUSL_FLAKE="${MUSL_FLAKE:-path:${HOME}/nixos-config/modules/development/rust-musl}"

usage() {
  cat <<'EOF'
Usage: musl-rust-build.sh [linux|termux|android|all] [cargo-build-args...]

Examples:
  musl-rust-build.sh
  musl-rust-build.sh linux --bin tt
  musl-rust-build.sh termux
  musl-rust-build.sh all --bin tt
EOF
}

prepare_android_env() {
  export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}"
  export ANDROID_HOME="$ANDROID_SDK_ROOT"
  export ANDROID_API_LEVEL="${ANDROID_API_LEVEL:-24}"

  if [[ ! -d "$ANDROID_SDK_ROOT/ndk" ]]; then
    printf 'error: Android NDK directory not found under %s/ndk\n' "$ANDROID_SDK_ROOT" >&2
    exit 1
  fi

  if [[ -z "${ANDROID_NDK_HOME:-}" ]]; then
    ANDROID_NDK_HOME="$(find "$ANDROID_SDK_ROOT/ndk" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n1)"
    export ANDROID_NDK_HOME
  fi

  if [[ -z "${ANDROID_NDK_HOME:-}" || ! -d "$ANDROID_NDK_HOME" ]]; then
    printf 'error: valid ANDROID_NDK_HOME not found\n' >&2
    exit 1
  fi

  export ANDROID_NDK_ROOT="$ANDROID_NDK_HOME"
  export ANDROID_NDK_TOOLCHAIN_ROOT="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64"
  local android_bin_dir="$ANDROID_NDK_TOOLCHAIN_ROOT/bin"

  if [[ -d "$android_bin_dir" ]]; then
    find "$android_bin_dir" -maxdepth 1 -type f ! -perm -u+x -exec chmod u+x {} +
  fi

  if [[ ! -x "$android_bin_dir/aarch64-linux-android${ANDROID_API_LEVEL}-clang" ]]; then
    printf 'error: Android clang not found at %s/bin/aarch64-linux-android%s-clang\n' \
      "$ANDROID_NDK_TOOLCHAIN_ROOT" "$ANDROID_API_LEVEL" >&2
    exit 1
  fi
}

build_target() {
  local target="$1"
  local flake_ref="$2"

  if [[ "$target" == "aarch64-linux-android" ]]; then
    prepare_android_env
  fi

  nix develop "$flake_ref" -c rustup target add "$target"
  nix develop "$flake_ref" -c cargo build --release --target "$target" "${CARGO_ARGS[@]}"

  printf 'built %s\n' "$PWD/target/$target/release"
}

if [[ ! -f Cargo.toml ]]; then
  printf 'error: expected Cargo.toml in %s\n' "$PWD" >&2
  exit 1
fi

MODE="linux"
if [[ $# -gt 0 ]]; then
  case "$1" in
    linux|termux|android|all)
      MODE="$1"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
  esac
fi

CARGO_ARGS=("$@")

case "$MODE" in
  linux)
    build_target "x86_64-unknown-linux-musl" "$MUSL_FLAKE"
    ;;
  termux|android)
    build_target "aarch64-linux-android" "$MUSL_FLAKE#android-termux"
    ;;
  all)
    build_target "x86_64-unknown-linux-musl" "$MUSL_FLAKE"
    build_target "aarch64-linux-android" "$MUSL_FLAKE#android-termux"
    ;;
esac
