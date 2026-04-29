# intel.nix - Intel laptop power management optimizations
# Optimized for Intel processors and integrated graphics
{ config, pkgs, lib, ... }:

{
  # Enable power management with Intel optimizations
  powerManagement = {
    enable = true;
    powertop.enable = true;  # Works well with Intel systems
  };

  # Intel-specific kernel parameters
  boot.kernelParams = [
    # Intel sleep management
    "mem_sleep_default=deep"           # Force deep sleep
    "intel_pstate=active"              # Use Intel P-state driver
    
    # Intel graphics optimizations
    "i915.enable_rc6=1"                # Enable render context 6 (power saving)
    "i915.enable_fbc=1"                # Enable framebuffer compression
    "i915.enable_psr=1"                # Enable panel self refresh
    "i915.disable_power_well=0"        # Keep power wells enabled for stability
    
    # Memory and thermal management
    "transparent_hugepage=madvise"      # Better memory management
    
    # Intel idle optimizations
    "intel_idle.max_cstate=2"          # Limit C-states for stability
    
    # PCIe power management (usually works better on Intel)
    "pcie_aspm=force"                  # Force PCIe power saving
    
    # General optimizations
    "processor.max_cstate=2"           # Conservative processor sleep states
  ];

  # Intel-specific services
  services = {
    # Thermald works excellently with Intel
    thermald.enable = true;
    
    # TLP with Intel optimizations
    tlp = {
      enable = true;
      settings = {
        # Intel P-state configuration
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        
        # Intel energy performance policy
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        
        # Intel graphics power management
        INTEL_GPU_MIN_FREQ_ON_AC = 300;
        INTEL_GPU_MIN_FREQ_ON_BAT = 300;
        INTEL_GPU_MAX_FREQ_ON_AC = 1200;
        INTEL_GPU_MAX_FREQ_ON_BAT = 800;
        INTEL_GPU_BOOST_FREQ_ON_AC = 1200;
        INTEL_GPU_BOOST_FREQ_ON_BAT = 800;
        
        # PCIe power management (Intel usually handles this well)
        PCIE_ASPM_ON_AC = "performance";
        PCIE_ASPM_ON_BAT = "powersupersave";
        
        # USB power management
        USB_AUTOSUSPEND = 1;  # Intel systems usually handle this well
        USB_EXCLUDE_WWAN = 1;
        
        # WiFi power management
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
        
        # SATA power management
        SATA_LINKPWR_ON_AC = "max_performance";
        SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
        
        # Runtime power management
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
        
        # Battery charge thresholds (if supported by laptop)
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };

  # Install Intel-specific utilities
  environment.systemPackages = with pkgs; [
    acpi                    # ACPI utilities
    powertop               # Power consumption analysis (great for Intel)
    tlp                    # Advanced power management
    lm_sensors             # Hardware monitoring
    intel-gpu-tools        # Intel GPU utilities
    turbostat              # Intel CPU monitoring
  ];

  # Systemd sleep configuration optimized for Intel
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1800
    SuspendState=mem
    HibernateState=disk
  '';

  # Intel microcode updates
  hardware.cpu.intel.updateMicrocode = true;
  
  # Intel-specific module configurations
  boot.extraModprobeConfig = ''
    # Intel graphics optimizations
    options i915 enable_rc6=1 enable_fbc=1 enable_psr=1 disable_power_well=0
    
    # Intel audio power management
    options snd_hda_intel power_save=1 power_save_controller=Y
    
    # USB power management (Intel systems usually handle this well)
    options usbcore autosuspend=1
    
    # Intel WiFi power management
    options iwlwifi power_save=1 d0i3_disable=0 uapsd_disable=0
    options iwldvm force_cam=0
  '';

  # Enable Intel hardware acceleration
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver   # For newer Intel GPUs (Broadwell+)
      vaapiIntel          # For older Intel GPUs
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
