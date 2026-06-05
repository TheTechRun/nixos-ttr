{ config, lib, pkgs, ... }:

{
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;
  zramSwap.algorithm = "lz4";
}
