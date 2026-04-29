{
  description = "NixOS flake for scroll, a fork of Sway with a scrolling tiling layout";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    scroll-stable = {
      url = "git+https://github.com/dawsers/scroll?ref=refs/tags/1.12.4";
      flake = false;
    };

    scroll-git = {
      url = "git+https://github.com/dawsers/scroll?ref=master";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    eachSystem = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];

    mkScrollOverlay =
      src:
      final: prev: {
        sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
          inherit src;
          meta.mainProgram = "scroll";

          patches = [];

          nativeBuildInputs = old.nativeBuildInputs ++ (with prev; [
            glslang
            lcms
            hwdata
            libliftoff
          ]);

          buildInputs = old.buildInputs ++ (with prev; [
            lua54Packages.lua
            vulkan-loader
            xwayland
            seatd
            lcms
            libdisplay-info
            libxcb-render-util
            libxcb-errors
            libliftoff
            libgbm
          ]);
        });
      };
  in
  {
    packages = eachSystem (system: {
      "scroll-stable" = (import nixpkgs {
        inherit system;
        overlays = [ (mkScrollOverlay inputs.scroll-stable) ];
      }).sway;

      "scroll-git" = (import nixpkgs {
        inherit system;
        overlays = [ (mkScrollOverlay inputs.scroll-git) ];
      }).sway;

      default = self.packages.${system}."scroll-stable";
    });

    nixosModules.default =
      {
        config,
        lib,
        pkgs,
        modulesPath,
        ...
      }:
      let
        cfg = config.programs.scroll;
        wayland-lib = import (modulesPath + "/programs/wayland/lib.nix") { inherit lib; };
      in
      {
        options.programs.scroll = {
          enable =
            lib.mkEnableOption ''
              scroll, a fork of Sway (an i3-compatible Wayland compositor) with a scrolling
              tiling layout.
            '';

          package =
            lib.mkOption {
              type = lib.types.package;
              default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
              example = self.packages.${pkgs.stdenv.hostPlatform.system}.scroll-git;
              description = ''
                The scroll package to use.
              '';

              apply =
                p:
                if p == null then
                  null
                else
                  wayland-lib.genFinalPackage p {
                    extraSessionCommands = cfg.extraSessionCommands;
                    extraOptions = cfg.extraOptions;
                    withBaseWrapper = cfg.wrapperFeatures.base;
                    withGtkWrapper = cfg.wrapperFeatures.gtk;
                    enableXWayland = cfg.xwayland.enable;
                    isNixOS = true;
                  };
            };

          wrapperFeatures = {
            base =
              lib.mkEnableOption ''
                the base wrapper to execute extra session commands and prepend a
                dbus-run-session to the scroll command''
              // {
                default = true;
              };
            gtk = lib.mkEnableOption ''
              the wrapGAppsHook wrapper to execute scroll with required environment
              variables for GTK applications'';
          };

          extraSessionCommands = lib.mkOption {
            type = lib.types.lines;
            default = "";
            example = ''
              export GTK_THEME=Adwaita-dark
              export QT_QPA_PLATFORM="wayland;xcb"
              export GDK_BACKEND="wayland,x11"
              export SDL_VIDEODRIVER=wayland
              export CLUTTER_BACKEND=wayland
              export XDG_CURRENT_DESKTOP=scroll
              export XDG_SESSION_TYPE=wayland
              export XDG_SESSION_DESKTOP=scroll
              export ELECTRON_OZONE_PLATFORM_HINT=wayland
              export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
              export QT_QPA_PLATFORMTHEME=qt6ct
              export QT_SCALE_FACTOR_ROUNDING_POLICY=RoundPreferFloor
              export LIBVA_DRIVER_NAME=nvidia
              export GBM_BACKEND=nvidia-drm
              export __GLX_VENDOR_LIBRARY_NAME=nvidia
              export XCURSOR_THEME=Adwaita
              export XCURSOR_SIZE=24
            '';
            description = ''
              Shell commands executed just before scroll is started.
            '';
          };

          extraOptions = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            example = [
              "--verbose"
              "--debug"
            ];
            description = ''
              Command line arguments passed to launch scroll.
            '';
          };

          xwayland.enable = lib.mkEnableOption "XWayland" // {
            default = true;
          };

          extraPackages = lib.mkOption {
            type = with lib.types; listOf package;
            default = with pkgs; [
              brightnessctl
              kitty
              grim
              pulseaudio
              swayidle
              swaylock
              wmenu
              xdg-desktop-portal
              xdg-desktop-portal-gtk
              xdg-desktop-portal-wlr
            ];
            defaultText = lib.literalExpression ''
              with pkgs; [ brightnessctl kitty grim pulseaudio swayidle swaylock wmenu xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
            '';
            example = lib.literalExpression ''
              with pkgs; [ i3status i3status-rust termite rofi light ]
            '';
            description = ''
              Extra packages to be installed system wide.
            '';
          };
        };

        config = lib.mkIf cfg.enable (
          lib.mkMerge [
            {
              assertions = [
                {
                  assertion = cfg.extraSessionCommands != "" -> cfg.wrapperFeatures.base;
                  message = ''
                    The extraSessionCommands for scroll will not be run if wrapperFeatures.base is disabled.
                  '';
                }
              ];

              warnings =
                lib.mkIf
                  (
                    (lib.elem "nvidia" config.services.xserver.videoDrivers)
                    && (lib.versionOlder (lib.versions.major (lib.getVersion config.hardware.nvidia.package)) "551")
                  )
                  [
                    "Using scroll with Nvidia driver version <= 550 may result in a poor experience. Configure hardware.nvidia.package to use a newer version, or alternatively switch to using Nouveau."
                  ];

              environment = {
                systemPackages = lib.optional (cfg.package != null) cfg.package ++ cfg.extraPackages;
                pathsToLink = lib.optional (cfg.package != null) "/share/backgrounds/scroll";

                etc =
                  {
                    "scroll/config.d/nixos.conf".source = pkgs.writeText "nixos.conf" ''
                      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SCROLLSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE PATH NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE
                      exec "systemctl --user import-environment {,WAYLAND_}DISPLAY SCROLLSOCK; systemctl --user start scroll-session.target"
                      exec scrollmsg -t subscribe '["shutdown"]' && systemctl --user stop scroll-session.target
                    '';
                  }
                  // lib.optionalAttrs (cfg.package != null) {
                    "scroll/config".source = lib.mkOptionDefault "${cfg.package}/etc/scroll/config";
                  };
              };

              systemd.user.targets.scroll-session = {
                description = "scroll compositor session";
                documentation = [ "man:systemd.special(7)" ];
                bindsTo = [ "graphical-session.target" ];
                wants = [ "graphical-session-pre.target" ];
                after = [ "graphical-session-pre.target" ];
              };

              services.displayManager.sessionPackages = lib.optional (cfg.package != null) cfg.package;

              xdg.portal.config.scroll = {
                default = [ "gtk" ];
                "org.freedesktop.impl.portal.ScreenCast" = "wlr";
                "org.freedesktop.impl.portal.Screenshot" = "wlr";
                "org.freedesktop.impl.portal.Inhibit" = "none";
              };
            }

            (import (modulesPath + "/programs/wayland/wayland-session.nix") {
              inherit lib pkgs;
              enableXWayland = cfg.xwayland.enable;
            })
          ]
        );
      };
  };
}
