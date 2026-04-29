# Configuration for both Canon MF620C and Zebra LP2844
{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    services.customCups = {
      enable = mkEnableOption "Enable custom CUPS printing configuration";
    };
  };

  config = mkIf config.services.customCups.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };

    services.printing = {
      enable = true;
      browsing = true;
      defaultShared = true;
      # Include drivers for both printers
      drivers = with pkgs; [ 
        canon-cups-ufr2
        gutenprint    # Contains Zebra drivers
        cups-filters
      ];
      logLevel = "debug2";
      # Add configuration specific to Zebra printer
      extraConf = ''
        LogLevel debug2
        
        # Allow raw printing for Zebra
        FileDevice Yes
        
        # Shorter timeout for label printer
        JobKillDelay 30
        
        # Important for Zebra printer
        <Location />
          Order allow,deny
          Allow from all
        </Location>
        
        <Location /admin>
          Order allow,deny
          Allow from all
        </Location>
      '';
      browsedConf = ''
        BrowseDNSSDSubTypes _cups,_print
        BrowseLocalProtocols all
        BrowseRemoteProtocols all
        CreateIPPPrinterQueues All
        BrowseTimeout 15
      '';
    };

    # Required packages for both printers
    environment.systemPackages = with pkgs; [
      cups-filters
      gutenprint
      ghostscript
      foomatic-filters
      cups-pk-helper
      system-config-printer
    ];

    # Configure systemd service
    systemd.services.cups = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    # Required for proper operation
    services.dbus.enable = true;
    security.polkit.enable = true;

    # Open necessary ports
    networking.firewall = {
      allowedTCPPorts = [ 631 9100 ];
      allowedUDPPorts = [ 631 5353 ];
    };
  };
}