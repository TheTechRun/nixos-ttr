{ config, pkgs, ... }:

{
  services = {
    #customCups.enable = true; # Enable CUPS to print documents defined in cups.nix.
    libinput.enable = true;  # Enable touchpad support
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
    flatpak.enable = true;
    usbmuxd.enable = true;
    
    # Enable locate service for fast file searching
    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "hourly"; # Update database hourly instead of daily
    };
    # Commented out services
    # prowlarr.enable = true;
    # sonarr.enable = true;
    # jellyfin.enable = true;
    # jackett.enable = true;

    # udev rules for vial
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666"
      # Specific rules for keyboard vendors if needed
      # SUBSYSTEM=="usb", ATTR{idVendor}=="feed", MODE="0666"
    '';
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  # XFCE desktop manager (for Thunar preferences)
  services.xserver.desktopManager.xfce = {
    enable = true;
    noDesktop = true;
  };
}
