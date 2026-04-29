# /modules/desktop-environment/wm/wayland/swayfx.nix
# SwayFX configuration module
{ config, lib, pkgs, ... }:

{
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;  # Use the nixpkgs swayfx package
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export MOZ_ENABLE_WAYLAND=1
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1

      # SwayFX specific optimizations
      export WLR_NO_HARDWARE_CURSORS=1
    '';
    extraPackages = with pkgs; [
      swaylock
      swayidle
      swayimg
      wl-clipboard
      cliphist
      wdisplays
      # waybar
      grim
      slurp
      wf-recorder
      xwayland
      wlr-randr
      networkmanagerapplet
      rofi
      # pyload-ng
      screenkey
      haskellPackages.greenclip
      dunst
      brightnessctl
      pamixer
      playerctl
      # Additional packages that work well with swayfx
      swaybg
      i3blocks
      wmenu
      nwg-look # wayland lxappearance alternative
    ];
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    config = {
      common.default = ["gtk"];
      sway.default = lib.mkForce ["wlr" "gtk"];
    };
  };

  security.polkit.enable = true;
  hardware.graphics.enable = true;

  # Audio configuration moved to host-specific audio files
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   pulse.enable = true;
  # };
}

# SwayFX Configuration Tips:
# Add these to your ~/.config/sway/config for SwayFX features:
#
# # Rounded corners
# corner_radius 10
#
# # Blur effects
# blur enable
# blur_xray enable
# blur_passes 2
# blur_radius 5
#
# # Window shadows
# shadows enable
# shadow_blur_radius 20
# shadow_color #0000007F
#
# # Dim unfocused windows
# default_dim_inactive 0.1
#
# # Layer effects for waybar
# layer_effects "waybar" {
#     blur enable
#     shadows enable
#     corner_radius 10
# }