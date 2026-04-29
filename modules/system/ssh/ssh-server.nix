{ config, lib, pkgs, ... }:

{
  # Server-side SSH configuration
  services.openssh = {
    enable = true;
    
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Enable SFTP subsystem
      Subsystem = "sftp internal-sftp";
    };
    
    # Listen on all IPv4 interfaces - we'll use firewall to control access
    listenAddresses = [
      { addr = "0.0.0.0"; port = 22; }
    ];
  };

  # Enable FUSE
  boot.kernelModules = [ "fuse" ];

  # Install SSHFS and other useful SSH-related tools
  environment.systemPackages = with pkgs; [
    sshfs
    openssh
    fuse
  ];

  # Set up SSH keys for your user
  users.users.ttr-server = {
    openssh.authorizedKeys.keys = [
      # Desktop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINebR+PPa/2rinXFLbIe6nXDhSuc9MvdL6b91v0PWH9m you@example.com"
  
      # Laptop
     "ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX you@example.com"

     # Termux (Moto G Stylus 2025):
     "ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX you@example.com"

     # Termux (Moto G Stylus 2024):
     "ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX you@example.com"
    ];
  };

  # SSH client configuration for remote PC
  environment.etc."ssh/ssh_config".text = ''
    Host remote
      HostName remote
      User ttr
      Port 22
      ForwardX11 yes
      IdentityFile ~/.ssh/id_ed25519
      ServerAliveInterval 60
      ServerAliveCountMax 3
      Compression yes
  '';

  # Enable X11 forwarding
  services.xserver.enable = true;

  # Allow users in the "fuse" group to use FUSE
  users.groups.fuse = {};
  users.users.ttr-server.extraGroups = [ "fuse" ];

  # LUKS Remote Unlock via initrd SSH
  boot.kernelParams = [ "ip=192.168.1.131::192.168.1.1:255.255.255.0::eno1:none" ];

  boot.initrd.network.enable = true;

  boot.initrd.network.ssh = {
    enable = true;
    port = 2222;
    hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINebR+PPa/2rinXFLbIe6nXDhSuc9MvdL6b91v0PWH9m you@example.com"
    ];
  };
# Do this on the server before rebuilding:                                                          
# sudo mkdir -p /etc/secrets/initrd                                                                                  
# sudo ssh-keygen -t ed25519 -N "" -f /etc/secrets/initrd/ssh_host_ed25519_key                                       
# sudo chmod 600 /etc/secrets/initrd/ssh_host_ed25519_key 

  # Add firewall rules to only allow SSH from Tailscale IPs
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    extraCommands = ''
      # Allow SSH only from Tailscale IPs
      iptables -A INPUT -p tcp --dport 22 -s 100.64.0.0/10 -j ACCEPT
      iptables -A INPUT -p tcp --dport 22 -j DROP
    '';
  };
}