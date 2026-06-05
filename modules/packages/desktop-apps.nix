{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    alacritty
    bitwarden-desktop
    chromium
    eog
    gImageReader
    networkmanagerapplet
    scrcpy
    solaar
    telegram-desktop
    vial
    virt-manager
    xed-editor
  ];
}
