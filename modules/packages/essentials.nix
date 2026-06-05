{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cliphist # clipboard history
    curl
    docker
    docker-compose
    featherpad
    fd
    firefox
    fzf
    git
    kitty
    micro
    nodejs_24
    pcmanfm
    ripgrep
    rclone
    starship
    wget
    wl-clipboard
  ];
}