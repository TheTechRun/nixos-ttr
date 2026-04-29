# amd-fixed.nix - Fixed AMD power management for ThinkPad T14
# Addresses CPU frequency and brightness issues
{ config, pkgs, lib, ... }:

{
  # Enable power management with better defaults
  powerManagement = {
    enable = true;
    powertop.enable = false;  # Keep disabled for now
  };


  # Fixed kernel parameters - less aggressive
  boot.kernelParams = [
    # Use s2idle for better compatibility
    "mem_sleep_default=s2idle"
    
    # AMD settings - less aggressive
    "amd_pstate=active"                # Use active instead of guided/passive
    
    # REMOVE overly restrictive C-state limits
    # "processor.max_cstate=1"         # This was causing CPU to stay slow!
    
    # ThinkPad-specific brightness fix
    "acpi_backlight=native"            # Use native backlight control
    "video.use_native_backlight=1"     # Force native backlight
    
    # Memory management
    "transparent_hugepage=madvise"
    
    # Keep PCIe management reasonable
    "pcie_aspm=default"                # Don't force off
  ];

  # Fixed services configuration
  services = {
    # Disable thermald since it's not compatible with your AMD CPU
    thermald.enable = false;           # THIS WAS CAUSING ISSUES
    
    # TLP with corrected settings
    tlp = {
      enable = true;
      settings = {
        # Fix CPU scaling - don't lock to powersave
        CPU_SCALING_GOVERNOR_ON_AC = "schedutil";     # Better than performance
        CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";    # Better than powersave
        
        # AMD energy performance
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        
        # CPU frequency scaling - allow full range
        CPU_MIN_PERF_ON_AC = 10;       # Allow CPU to go low when idle
        CPU_MAX_PERF_ON_AC = 100;      # Allow full performance
        CPU_MIN_PERF_ON_BAT = 5;       # Allow very low on battery
        CPU_MAX_PERF_ON_BAT = 80;      # Limit max on battery
        
        # Disable problematic USB autosuspend
        USB_AUTOSUSPEND = 0;
        
        # WiFi power management
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
        
        # Battery charge thresholds
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };

  # Essential packages
  environment.systemPackages = with pkgs; [
    acpi
    lm_sensors
    brightnessctl                      # For brightness control
    cpufrequtils                       # For CPU frequency monitoring
  ];

  # Sleep configuration
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=3600
    SuspendState=mem
    HibernateState=disk
  '';

  # Enable AMD microcode
  hardware.cpu.amd.updateMicrocode = true;
  
  # Fixed module configuration
  boot.extraModprobeConfig = ''
    # AMD GPU - allow runtime power management but be conservative
    options amdgpu dpm=1 runpm=1
    
    # ThinkPad ACPI for proper brightness control
    options thinkpad_acpi brightness_mode=1 force_brightness_support=1
    
    # Keep USB autosuspend disabled
    options usbcore autosuspend=-1
  '';

  # Systemd service to fix brightness on boot
  systemd.services.fix-brightness = {
    description = "Fix ThinkPad brightness on boot";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    unitConfig = {
      ConditionPathExists = "/sys/class/backlight/thinkpad_screen/brightness";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 12 > /sys/class/backlight/thinkpad_screen/brightness'";
      RemainAfterExit = true;
    };
  };

  # Systemd service to ensure CPU scaling works properly
  systemd.services.fix-cpu-scaling = {
    description = "Ensure CPU scaling is working properly";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo performance > $cpu 2>/dev/null || true; done'";
      RemainAfterExit = true;
    };
  };
}