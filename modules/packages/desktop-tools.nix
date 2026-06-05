{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    dmenu
    folder-color-switcher
    haskellPackages.greenclip
    libnotify
    rofi
  ];
}
