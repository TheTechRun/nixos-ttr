{ hostName, lib, pkgs, ... }:

let
  hostSettings = {
    desktop = {
      user = "ttr";
      authorizedKeys = [
# Laptop
"ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA git@your-domain.com"

# Server 
"ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA git@your-domain.com"

# Moto Stylus 2025 (Termux)
"ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA git@your-domain.com"

# Moto Stylus 2024 (Termux)
"ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA git@your-domain.com"
      ];
    };
    laptop = {
      user = "ttr";
      authorizedKeys = [ ];
    };
    server = {
      user = "ttr-server";
      authorizedKeys = [
# Laptop
"ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA git@your-domain.com"

# Desktop 
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINebR+PPa/2rinXFLbIe6nXDhSuc9MvdL6b91v0PWH9m git@your-domain.com"

# Moto Stylus 2025
"ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA git@your-domain.com"

# Moto Stylus 2024
"ssh-ed25519 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA git@your-domain.com"
      ];
    };
  };
  cfg = hostSettings.${hostName} or (throw "Unsupported hostName for ssh.nix: ${hostName}");
in
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      Subsystem = "sftp internal-sftp";
    };
    listenAddresses = [
      { addr = "0.0.0.0"; port = 22; }
    ];
  };

  boot.kernelModules = [ "fuse" ];

  environment.systemPackages = with pkgs; [
    sshfs
    openssh
    fuse
  ];

  users.groups.fuse = {};
  users.users.${cfg.user} = {
    openssh.authorizedKeys.keys = cfg.authorizedKeys;
    extraGroups = [ "fuse" ];
  };

  environment.etc."ssh/ssh_config".text = ''
    Host server
      HostName server
      User ttr
      Port 22
      ForwardX11 yes
      IdentityFile ~/.ssh/id_ed25519
      ServerAliveInterval 60
      ServerAliveCountMax 3
      Compression yes
  '';

  services.xserver.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    extraCommands = ''
      iptables -A INPUT -p tcp --dport 22 -s 100.64.0.0/10 -j ACCEPT
      iptables -A INPUT -p tcp --dport 22 -j DROP
    '';
  };
}