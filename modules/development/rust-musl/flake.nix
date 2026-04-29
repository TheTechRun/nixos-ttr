{
  description = "Rust cross-compilation development environments";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        muslPkgs = pkgs.pkgsCross.musl64;
      in {
        devShells = {
          default = pkgs.mkShell {
            name = "rust-musl";

            packages = with pkgs; [
              pkg-config
              perl
              gnumake
              rustup
              muslPkgs.stdenv.cc
              muslPkgs.openssl
              muslPkgs.zlib
            ];

            shellHook = ''
              export CC_x86_64_unknown_linux_musl="$(
                command -v x86_64-linux-musl-gcc || command -v x86_64-unknown-linux-musl-gcc
              )"
              export AR_x86_64_unknown_linux_musl="$(
                command -v x86_64-linux-musl-ar || command -v x86_64-unknown-linux-musl-ar || command -v ar
              )"
              export CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_AR="$AR_x86_64_unknown_linux_musl"
              export CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_LINKER="$CC_x86_64_unknown_linux_musl"
              export PKG_CONFIG_ALLOW_CROSS=1
              export OPENSSL_STATIC=1
              export OPENSSL_DIR="${muslPkgs.openssl.dev}"
              export OPENSSL_LIB_DIR="${muslPkgs.openssl.out}/lib"
              export OPENSSL_INCLUDE_DIR="${muslPkgs.openssl.dev}/include"
              export PKG_CONFIG_PATH="${muslPkgs.openssl.dev}/lib/pkgconfig:${muslPkgs.zlib.dev}/lib/pkgconfig''${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"

              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
              echo "Rust musl development environment"
              echo "linker: $CC_x86_64_unknown_linux_musl"
              echo "ar: $AR_x86_64_unknown_linux_musl"
              echo ""
              echo "Build with:"
              echo "  rustup target add x86_64-unknown-linux-musl"
              echo "  cargo build --release --target x86_64-unknown-linux-musl"
              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            '';
          };

          android-termux = pkgs.mkShell {
            name = "rust-android-termux";

            packages = with pkgs; [
              pkg-config
              perl
              gnumake
              cmake
              rustup
            ];

            shellHook = ''
              export ANDROID_SDK_ROOT="''${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}"
              export ANDROID_HOME="$ANDROID_SDK_ROOT"
              export ANDROID_API_LEVEL="''${ANDROID_API_LEVEL:-24}"
              export PKG_CONFIG_ALLOW_CROSS=1

              if [ ! -d "$ANDROID_SDK_ROOT/ndk" ]; then
                echo "Android NDK directory not found under $ANDROID_SDK_ROOT/ndk"
                echo "Set ANDROID_SDK_ROOT or ANDROID_NDK_HOME to your installed SDK/NDK path."
                return 1
              fi

              export ANDROID_NDK_HOME="''${ANDROID_NDK_HOME:-$(find "$ANDROID_SDK_ROOT/ndk" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n1)}"
              if [ -z "$ANDROID_NDK_HOME" ]; then
                echo "No Android NDK versions found under $ANDROID_SDK_ROOT/ndk"
                echo "Set ANDROID_NDK_HOME to a specific installed NDK directory."
                return 1
              fi

              export ANDROID_NDK_ROOT="$ANDROID_NDK_HOME"
              export ANDROID_NDK_TOOLCHAIN_ROOT="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64"
              if [ ! -d "$ANDROID_NDK_TOOLCHAIN_ROOT" ]; then
                echo "Android NDK toolchain root not found: $ANDROID_NDK_TOOLCHAIN_ROOT"
                echo "Set ANDROID_NDK_HOME to a valid NDK directory."
                return 1
              fi

              export CC_aarch64_linux_android="$ANDROID_NDK_TOOLCHAIN_ROOT/bin/aarch64-linux-android$ANDROID_API_LEVEL-clang"
              export CXX_aarch64_linux_android="$ANDROID_NDK_TOOLCHAIN_ROOT/bin/aarch64-linux-android$ANDROID_API_LEVEL-clang++"
              export AR_aarch64_linux_android="$ANDROID_NDK_TOOLCHAIN_ROOT/bin/llvm-ar"
              export RANLIB_aarch64_linux_android="$ANDROID_NDK_TOOLCHAIN_ROOT/bin/llvm-ranlib"

              export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER="$CC_aarch64_linux_android"
              export CARGO_TARGET_AARCH64_LINUX_ANDROID_AR="$AR_aarch64_linux_android"

              if [ ! -x "$CC_aarch64_linux_android" ]; then
                echo "Android clang not found: $CC_aarch64_linux_android"
                return 1
              fi

              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
              echo "Rust Android/Termux development environment"
              echo "ndk: $ANDROID_NDK_HOME"
              echo "api: $ANDROID_API_LEVEL"
              echo "linker: $CC_aarch64_linux_android"
              echo ""
              echo "Build with:"
              echo "  rustup target add aarch64-linux-android"
              echo "  cargo build --release --target aarch64-linux-android"
              echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            '';
          };
        };
      }
    );
}
