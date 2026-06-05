{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gImageReader
    imagemagick
    piper-tts
    pandoc
    satty
    obs-studio
    tesseract
  ];
}
