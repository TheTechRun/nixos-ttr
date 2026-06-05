# sudo systemctl enable sshd
# sudo smbpasswd -a <username>
# systemctl status sshd

{ config, hostName, lib, pkgs, ... }:

let
  globalSettings = {
    "server string" = "${hostName} Samba Server";
    "server role" = "standalone server";
    "workgroup" = "WORKGROUP";
    "security" = "user";
    "map to guest" = "Bad User";
  };

  sharesByHost = {
    desktop = { };
   
    laptop = { };

    server = {
      media = {
        path = "/mnt/12tb/data/media";
        comment = "CF Media";
        "read only" = "yes";
        "browseable" = "yes";
        "guest ok" = "yes";
        "guest only" = "yes";
      };
      media2 = {
        path = "/mnt/12tb/data/media2";
        comment = "CF Media 2";
        "read only" = "no";
        "browseable" = "yes";
      };
      roughdrafts = {
        path = "/mnt/12tb/Rough_Drafts";
        comment = "Rough Drafts";
        "read only" = "no";
        "browseable" = "yes";
        "guest ok"= "yes";
        "guest only" = "yes";
      };
      home = {
        path = "~/";
        comment = "Home directory";
        "read only" = "no";
        "browseable" = "yes";
        "public" = "no";
      };
      share = {
        path = "~/share/";
        comment = "Shared Devices Directory";
        "read only" = "no";
        "browseable" = "yes";
        "public" = "no";
      };
      my-pics = {
        path = "/mnt/12tb/Backups/my-pics";
        comment = "my pics";
        "read only" = "no";
        "browseable" = "yes";
      };
    };
  };

  shares = sharesByHost.${hostName} or (throw "Unsupported hostName for samba.nix: ${hostName}");
in
{
  services.samba = {
    enable = true;
    package = pkgs.samba;
    openFirewall = true;
    settings = {
      global = globalSettings;
    } // shares;
  };

  networking.firewall = {
    allowedTCPPorts = [ 445 139 ];
    allowedUDPPorts = [ 137 138 ];
  };

  systemd.services.samba-smbd = lib.mkIf config.services.samba.enable {
    after = [ "network.target" ];
    requires = [ "network.target" ];
    restartTriggers = [ config.environment.etc."samba/smb.conf".text ];
  };
}
