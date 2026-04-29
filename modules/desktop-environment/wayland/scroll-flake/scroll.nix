# /modules/desktop-environment/wayland/scroll-flake/scroll.nix
# Scroll configuration module using scroll-flake NixOS module
{ config, lib, pkgs, inputs, ... }:

{
  programs.scroll = {
    enable = true;
    # Try scroll-git instead of default (stable) - might have package name fixes
    package = inputs.scroll-flake.packages.${pkgs.stdenv.hostPlatform.system}.scroll-git;

    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    extraSessionCommands = ''
      # Tell QT, GDK and others to use the Wayland backend by default
      export QT_QPA_PLATFORM="wayland;xcb"
      export GDK_BACKEND="wayland,x11"
      export SDL_VIDEODRIVER=wayland
      export CLUTTER_BACKEND=wayland

      # XDG desktop variables to set scroll as the desktop
      export XDG_CURRENT_DESKTOP=scroll
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=scroll

      # Configure Electron to use Wayland
      export ELECTRON_OZONE_PLATFORM_HINT=wayland

      # Cursor and theme settings
      export GTK_THEME=Adwaita-dark
      export XCURSOR_THEME=Adwaita
      export XCURSOR_SIZE=24

      # Nvidia/Wayland support
      export WLR_NO_HARDWARE_CURSORS=1
      # export WLR_RENDERER=vulkan  # Uncomment for HDR support
    '';

    extraPackages = with pkgs; [
      swaylock
      swayidle
      swayimg
      wl-clipboard
      cliphist
      wdisplays
      grim
      slurp
      wf-recorder
      xwayland
      wlr-randr
      networkmanagerapplet
      rofi
      screenkey
      haskellPackages.greenclip
      dunst
      brightnessctl
      pamixer
      playerctl
      swaybg
      i3blocks
      wmenu
      nwg-look # wayland lxappearance alternative

      # Scroll-specific packages
      jq      # For scroll IPC scripting
      lua5_4  # For scroll lua scripting
      wev     # For key code detection
    ];
  };

  # Portal configuration for screencasting
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = ["gtk"];
    };
  };

  # Create portal config file for scroll
  environment.etc."xdg-desktop-portal/scroll-portals.conf".text = ''
    [preferred]
    default=gtk
    org.freedesktop.impl.portal.ScreenCast=wlr
    org.freedesktop.impl.portal.Screenshot=wlr
    org.freedesktop.impl.portal.Inhibit=none
  '';

  security.polkit.enable = true;
  hardware.graphics.enable = true;
}

# IMPORTANT: After switching, create ~/.config/scroll/config with:
#
# include /etc/scroll/config.d/*
#
# # Your scroll configuration here...
#
# This is required to avoid Waybar startup issues.
# See: https://github.com/Alexays/Waybar/issues/2675#issuecomment-3288118070
#
# For example config: https://github.com/dawsers/scroll/blob/master/config.in
# Manual: man 5 scroll
