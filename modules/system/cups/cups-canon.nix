# Works for Canon MF620C but makes Zebra spit out endless labels 

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
      drivers = [ pkgs.canon-cups-ufr2 ];
      logLevel = "debug2";
      browsedConf = ''
        BrowseDNSSDSubTypes _cups,_print
        BrowseLocalProtocols all
        BrowseRemoteProtocols all
        CreateIPPPrinterQueues All
      '';
    };

    # Ensure these packages are installed for driverless printing support
    environment.systemPackages = with pkgs; [
      cups-filters
      gutenprint
      ghostscript
      foomatic-filters
      cups-pk-helper # For PolicyKit integration
      system-config-printer # GUI tool for printer management
    ];

    # Open necessary ports for network printing (already defined in firewall.nix)
    #networking.firewall = {
    #  enable = true;
    #  allowedTCPPorts = [ 631 9100 ];
    #  allowedUDPPorts = [ 631 5353 ];
    #};
  };
}