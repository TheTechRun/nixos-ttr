{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bottom
    cliphist # clipboard history
    cloudflared
    curl
    docker
    docker-compose
    eza
    fd
    ffmpeg
    firefox
    fzf
    git
    micro
    n-m3u8dl-re
    nodejs_24
    ripgrep
    rclone
    starship
    wget
    wl-clipboard
  ];
}