{ config, lib, pkgs, ... }: {
  # Enable Samba services
  services = {
    samba = {
      enable = true;
      package = pkgs.samba;  # Changed from samba4Full to samba
      openFirewall = true;
      
      # Global settings
      settings = {
        global = {
          "server string" = "desktop Samba Server";
          "server role" = "standalone server";
          "workgroup" = "WORKGROUP";
          "security" = "user";
        };

        # Share definitions
        tv = {
          path = "/mnt/12tb/data/media/tv";
          comment = "CF TV Series";
          "read only" = "no";
          "browseable" = "yes";
        };

        movies = {
          path = "/mnt/12tb/data/media/movies";
          comment = "CF Movies";
          "read only" = "no";
          "browseable" = "yes";
        };

        jellyfin = {
          path = "/mnt/12tb/Jellyfin_Media";
          comment = "Jellyfin Videos";
          "read only" = "no";
          "browseable" = "yes";
        };

        roughdrafts = {
          path = "/mnt/12tb/Rough_Drafts";
          comment = "Rough Drafts";
          "read only" = "no";
          "browseable" = "yes";
        };

        "my-pics" = {
          path = "/mnt/12tb/my-pics";
          comment = "My Pics";
          "read only" = "no";
          "browseable" = "yes";
        };
      };
    };
  };

  # Enable necessary firewall ports
  networking.firewall = {
    allowedTCPPorts = [ 
      445   # SMB
      139   # NetBIOS
    ];
    allowedUDPPorts = [
      137 138  # NetBIOS
    ];
  };

  # Add systemd service dependencies
  systemd.services.samba-smbd = lib.mkIf config.services.samba.enable {
    after = [ "network.target" ];
    requires = [ "network.target" ];
    restartTriggers = [ config.environment.etc."samba/smb.conf".text ];
  };
}

# To enable user: sudo smbpasswd -a ttr
# To check status:  sudo systemctl status samba-smbd
