{ hostName, lib, pkgs, ... }:

let
  initrdSshHostKeyDir = "/var/lib/initrd-ssh";
  initrdSshHostKeyPath = "${initrdSshHostKeyDir}/ssh_host_ed25519_key";
  initrdSshHostKeySetupScript = ''
    install -d -m 0711 -o root -g root ${initrdSshHostKeyDir}

    if [ ! -e ${initrdSshHostKeyPath} ]; then
      umask 077
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -f ${initrdSshHostKeyPath}
    fi

    chown root:root ${initrdSshHostKeyPath}
    chmod 600 ${initrdSshHostKeyPath}
  '';
  cfg = {
# add pubkeys from other hosts
    initrdAuthorizedKeys = [
      # Desktop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINebR+PPa/2rinXFLbIe6nXDhSuc9MvdL6b91v0PWH9m git@cloudlive.us"

      # Laptop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPL32Vg6wQabLVD5bFB1IGIFssC6FMGJBQoQEUupBP1b git@cloudlive.us"

      # Moto Stylus 2025
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOZAhLmZIEbdwuQ+w8B2jm0uGiy/sB+++0Idq5+SkVbg ssh@cloudlive.us"

      # Moto Stylus 2024
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAedWWtUKU5HijVeFMeJ2nfcS4zL8L9b57w7LCjjzWQy ssh@cloudlive.us"
    ];
# explicitely state a local ip address (change this in the future if it gets reassigned to another device)
    initrdAddress = "192.168.1.131/24";
    initrdGateway = "192.168.1.1";
    initrdKernelModules = [ "e1000e" ];
  };
in
lib.mkIf (hostName == "server") {
  systemd.tmpfiles.rules = [
    "d ${initrdSshHostKeyDir} 0711 root root -"
    "z ${initrdSshHostKeyDir} 0711 root root -"
  ];

  system.activationScripts.initrd-ssh-host-key.text = initrdSshHostKeySetupScript;

  systemd.services.initrd-ssh-host-key = {
    description = "Generate initrd SSH host key";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = initrdSshHostKeySetupScript;
  };

  boot.initrd.kernelModules = cfg.initrdKernelModules;
  boot.initrd.systemd.enable = true;
  boot.initrd.network.enable = true;
  boot.initrd.systemd.network.enable = true;
  boot.initrd.network.udhcpc.enable = false;
  boot.initrd.systemd.network.networks."10-wired" = {
    matchConfig.Type = "ether";
    networkConfig = {
      IPv6AcceptRA = false;
    };
    address = [ cfg.initrdAddress ];
    gateway = [ cfg.initrdGateway ];
    linkConfig.RequiredForOnline = "routable";
  };
  boot.initrd.network.ssh = {
    enable = true;
    port = 2222;
    hostKeys = [ initrdSshHostKeyPath ];
    authorizedKeys = cfg.initrdAuthorizedKeys;
  };
}