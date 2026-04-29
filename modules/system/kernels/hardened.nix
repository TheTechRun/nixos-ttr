{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_hardened;
    
    # Hardened kernel specific parameters
    kernelParams = [
      # Kernel hardening parameters
      "slab_nomerge"
      "slub_debug=FZP"
      "page_poison=1"
      "pti=on"
      "spectre_v2=on"
      "l1tf=full,force"
      "mds=full,nosmt"
      "tsx=off"
      "tsx_async_abort=full,nosmt"
      "kvm.nx_huge_pages=force"
      "random.trust_cpu=off"
      "init_on_alloc=1"
      "init_on_free=1"
    ];
    
    kernelModules = [ ];
  };
  
  # Additional security settings that complement the hardened kernel
  security = {
    lockKernelModules = false;  # Set to true to prevent loading new kernel modules
    protectKernelImage = true;
    
    # Additional security hardening
    allowSimultaneousMultithreading = false;  # Disables SMT/Hyperthreading for security
  };
  
  # Add some metadata to indicate which kernel is being used
  system.nixos.tags = [ "hardened-kernel" ];
}
