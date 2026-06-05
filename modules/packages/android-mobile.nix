{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    android-tools
    apksigner
    ifuse
    libimobiledevice
    scrcpy
    usbutils
  ];
}
