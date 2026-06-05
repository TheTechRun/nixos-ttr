{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    alsa-lib-with-plugins
    dragon-drop
    ffmpeg
    gthumb
    imagemagick
    imv
    # n-m3u8dl-re
    nomacs
    obs-studio
    playerctl
    piper-tts
    scrot
    satty
    swayimg
    tesseract
    vlc
    wl-color-picker
    wtype
  ];
}