{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cryptomator
    cryptomator-cli
    restic
  ];
}
