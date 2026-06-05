{ hostName, lib, pkgs, ... }:

let
  isDesktop = hostName == "desktop";
  isLaptop = hostName == "laptop";
  isServer = hostName == "server";
in
{
  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
  }
  // lib.optionalAttrs (!isServer) {
    flatpak.enable = true;
    usbmuxd.enable = true;
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666"
      # Specific rules for keyboard vendors if needed
      # SUBSYSTEM=="usb", ATTR{idVendor}=="feed", MODE="0666"
    '';
  }
  // lib.optionalAttrs isDesktop {
    mpd.enable = true;
  }
  // lib.optionalAttrs isLaptop {
    libinput.enable = true;
    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "hourly";
    };
    xserver.desktopManager.xfce = {
      enable = true;
      noDesktop = true;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
