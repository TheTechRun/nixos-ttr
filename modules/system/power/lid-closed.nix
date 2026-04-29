{ config, pkgs, lib, ... }:

{
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "poweroff";
    IdleAction = "suspend";
    IdleActionSec = "30min";
    InhibitDelayMaxSec = "5s";
    HoldoffTimeoutSec = "30s";
  };
}
