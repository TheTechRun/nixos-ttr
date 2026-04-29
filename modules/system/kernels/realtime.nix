{ config, pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_rt_latest;
    
    # Real-time kernel specific parameters for audio and low-latency work
    kernelParams = [
      "quiet"
      "threadirqs"            # Thread IRQs for better latency
      "preempt=full"          # Enable full preemption
      "acpi_irq_nobalance"    # Don't balance IRQs across CPUs
      "processor.max_cstate=1" # Prevent CPU sleep states for lower latency
      "intel_pstate=disable"   # Disable intel_pstate for consistent performance
    ];
    
    kernelModules = [ ];
  };
  
  # Real-time audio settings
  security.rtkit.enable = true;
  
  # Audio system configuration optimized for real-time
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;  # Enable JACK support for pro audio
  };
  
  # Set CPU performance for audio work
  powerManagement = {
    cpuFreqGovernor = "performance";
  };
  
  # Set high priority for audio group
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
    { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
  ];
  
  # Add some metadata to indicate which kernel is being used
  system.nixos.tags = [ "realtime-kernel" ];
}
