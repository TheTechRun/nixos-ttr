{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_6_6;
    
    # Kernel 6.6 specific parameters
    kernelParams = [
      "quiet"
      "mitigations=auto"
    ];
    
    kernelModules = [ ];
  };
  
  # Add some metadata to indicate which kernel is being used
  system.nixos.tags = [ "kernel-6.6" ];
}
