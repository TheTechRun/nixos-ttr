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

       # public

        tv = {
          path = "/mnt/12tb/data/media/tv";
          comment = "CF TV Series";
          "read only" = "yes";
          "browseable" = "yes";
          "public" = "yes"; # makes it passwordless
        };


        movies = {
          path = "/mnt/12tb/data/media/movies";
          comment = "CF Movies";
          "read only" = "yes";
          "browseable" = "yes";
          "public" = "yes";
        };

        music = {
          path = "/mnt/12tb/data/media/music";
          comment = "Music";
          "read only" = "yes";
          "browseable" = "yes";
          "public" = "yes";
        };

        jellyfin = {
          path = "/mnt/12tb/data/media/other/Jellyfin/";
          comment = "Jellyfin Videos";
          "read only" = "yes";
          "browseable" = "yes";
          "public" = "yes";
        };

         watchlist = {
          path = "/mnt/12tb/data/media/other/watchlist/";
          comment = "watchlist";
          "read only" = "yes";
          "browseable" = "yes";
          "public" = "yes";
        };

        roughdrafts = {
          path = "/mnt/12tb/Rough_Drafts";
          comment = "Rough Drafts";
          "read only" = "no";
          "browseable" = "yes";
          "public" = "yes";
        };

    # private

        home = {
          path = "/home/ttr/";
          comment = "Home directory";
          "read only" = "no";
          "browseable" = "yes";
          "public" = "no"; # makes it have a password
        };

        skate = {
          path = "/home/ttr/gits/github/my-programs/classick-skates";
          comment = "Skate Website Devices Directory";
          "read only" = "no";
          "browseable" = "yes";
          "public" = "no"; # makes it have a password
        };

        shared = {
          path = "/home/ttr/shared/";
          comment = "Shared Devices Directory";
          "read only" = "no";
          "browseable" = "yes";
          "public" = "no"; # makes it have a password
        };

         my-pics = {
          path = "/mnt/12tb/Backups/my-pics";
          comment = "my pics";
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