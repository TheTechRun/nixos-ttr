{ config, pkgs, ... }:

{
  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

}
