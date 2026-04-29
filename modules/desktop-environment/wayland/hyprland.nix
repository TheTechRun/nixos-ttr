{ config, pkgs, ... }:{

  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    cliphist
    hyprpaper
    hyprpicker
    hyprlock
    nwg-displays #wayland monitors
    nwg-look #wayland themes
    rofi-wayland
    waybar
    wlr-randr
    wtype
    wl-clipboard
    wpaperd
  ];
}
