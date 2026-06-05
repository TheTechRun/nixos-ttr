{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    libxcb
    setxkbmap
    xinit
    xmodmap
    xdotool
  ];
}