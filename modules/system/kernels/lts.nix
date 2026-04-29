{ config, pkgs, lib, ... }:

{
  # Use the default LTS kernel
  boot.kernelPackages = pkgs.linuxPackages;
  
  # Add some metadata to indicate which kernel is being used
  system.nixos.tags = [ "lts-kernel" ];
}
