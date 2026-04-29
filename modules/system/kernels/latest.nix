{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Optional: Kernel parameters for latest kernel
    kernelParams = [
      # Add any kernel parameters here
      "quiet"
      "mitigations=auto"
    ];
    
    kernelModules = [ ];
  };
  
  # Add some metadata to indicate which kernel is being used
  system.nixos.tags = [ "latest-kernel" ];
}
