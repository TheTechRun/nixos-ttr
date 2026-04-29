{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    
    # Zen kernel specific parameters for desktop performance
    kernelParams = [
      # Better desktop responsiveness
      "quiet"
      "mitigations=off"  # Better performance but less security
      "nowatchdog"       # Disable the watchdog for better latency
      "threadirqs"       # Thread IRQs for better latency
      "elevator=none"    # Let the kernel pick the best I/O scheduler
    ];
    
    kernelModules = [ ];
  };
  
  # Additional performance settings
  powerManagement = {
    cpuFreqGovernor = "performance";  # Set CPU governor to performance
    powertop.enable = false;  # Disable powertop auto-tuning
  };
  
  # IO schedulers optimized for desktop usage
  services.udev.extraRules = ''
    # Set scheduler for NVMe
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
    # Set scheduler for SSD and eMMC
    ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
    # Set scheduler for rotating disks
    ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
  '';
  
  # Add some metadata to indicate which kernel is being used
  system.nixos.tags = [ "zen-kernel" ];
}
