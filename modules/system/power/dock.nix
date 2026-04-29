# dock.nix - Aggressive docked mode that ignores lid and sleep events
{ config, pkgs, lib, ... }:

{
  # Completely disable all lid and power management
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    powerKey = "ignore";
    suspendKey = "ignore";
    hibernateKey = "ignore";
    rebootKey = "ignore";
    killUserProcesses = false;
    extraConfig = ''
      HandleSuspendKey=ignore
      HandleHibernateKey=ignore
      HandleLidSwitch=ignore
      HandleLidSwitchDocked=ignore
      HandleLidSwitchExternalPower=ignore
      HandlePowerKey=ignore
      HandleRebootKey=ignore
      IdleAction=ignore
      IdleActionSec=infinity
      InhibitDelayMaxSec=infinity
      HoldoffTimeoutSec=0
      RuntimeDirectorySize=25%
      RemoveIPC=false
    '';
  };

  powerManagement = {
    enable = false;
    powertop.enable = false;
    scsiLinkPolicy = null;
    cpuFreqGovernor = null;
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  systemd.services.systemd-suspend.enable = false;
  systemd.services.systemd-hibernate.enable = false;
  systemd.services.systemd-hybrid-sleep.enable = false;

  environment.systemPackages = with pkgs; [
    acpi
    xorg.xset
  ];

  boot.kernelParams = [
    "button.lid_init_state=open"
    "acpi_sleep=off"
    "noapic"
  ];
}
