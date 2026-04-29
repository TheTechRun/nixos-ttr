{ config, lib, pkgs, ... }:

{
zramSwap.enable = true;
zramSwap.memoryPercent = 50;  # good default
# zramSwap.algorithm = "zstd";  # or "lz4" for faster, less compression
zramSwap.algorithm = "lz4";
swapDevices = [ ];

}