{ config, pkgs, lib, ... }:

let
  paths = import ../../modules/paths.nix;
in
{
  imports =
      [ 

# Login Manager
# (paths.wayland + "/display-manager/greetd/tuigreet-swayfx.nix")
(paths.wayland + "/display-manager/greetd/tuigreet-scroll.nix")
# (paths.x11 + "/display-manager/light-dm/lightdm.nix")
# (paths.wayland + "/display-manager/greetd/tuigreet-niri.nix")

# Desktop Environment
# (paths.x11 + "/i3.nix")
# (paths.wayland + "/swayfx.nix")
(paths.wayland + "/scroll-flake/scroll.nix")
# (paths.wayland + "/niri.nix")
          
# System
./hardware-configuration.nix
(paths.system + "/cron.nix")
(paths.system + "/firewall.nix")
(paths.networkShare + "/network-share.nix")
(paths.system + "/services.nix")
(paths.system + "/ssh.nix")
(paths.system + "/virtualization.nix")
(paths.system + "/zram.nix")
(paths.system + "/ssh-initrd.nix")
(paths.system + "/fonts.nix")
(paths.system + "/samba.nix")
(paths.system + "/cloudflared/cloudflared-server.nix")
# OTHER IMPORTS START HERE -----------------------------

# Users
(paths.users + "/global-users.nix")
# LUKS External Drives
# ./mounts.nix

# Kernel
# (paths.kernels + "/latest.nix")

];

# home manager
home-manager.users.ttr-server = import (paths.users + "/home-ttr-server.nix");
  
# Enable flakes.
nix.settings.experimental-features = [ "nix-command""flakes" ];

# Set buffer size
#nix.settings.download-buffer-size = 52428800; # 50mb
nix.settings.download-buffer-size = 104857600; # 100mb

# Define your hostname.
networking.hostName = "server"; 

# Define your nixos version.
system.stateVersion = "24.05"; 


# Enable networking
networking.networkmanager.enable = false;
networking.useNetworkd = true;
systemd.network.enable = true;
networking.useDHCP = false;
networking.nameservers = [ "192.0.2.1" "198.51.100.53" "203.0.113.53" ];
systemd.network.networks."10-eno1" = {
  matchConfig.Name = "eno1";
  address = [ "192.0.2.10/24" ];
  routes = [
    { Gateway = "192.0.2.1"; }
  ];
  networkConfig = {
    DHCP = "no";
    IPv6AcceptRA = false;
    DNS = [ "192.0.2.1" "198.51.100.53" "203.0.113.53" ];
  };
  linkConfig.RequiredForOnline = "routable";
};
services.dbus.implementation = "dbus";

# Set terminator as the default terminal
environment.variables = {
XDG_TERMINAL = "kitty";
};     

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
programs.gnupg.agent = {
enable = true;
enableSSHSupport = true;
};

#Enable Sudo
security.sudo.enable = true;

# Bootloader.
boot.loader.systemd-boot.enable = true;
boot.loader.systemd-boot.configurationLimit = 5; 
boot.loader.efi.canTouchEfiVariables = true;

# Bootloader. (Use this for grub instead especially if you're on a VM)
#boot.loader.grub.enable = true;
#boot.loader.grub.device = "/dev/vda";
#boot.loader.grub.useOSProber = true;

# Garbage Collection
nix.gc = {
automatic = true;
dates = "weekly";        # Or another systemd calendar expression
options = "--delete-older-than 15d";
}; 
 
# Enable bin files to run
programs.nix-ld.enable = true;

# Set your time zone.
time.timeZone = "America/New_York";

# Select internationa localisation properties.
i18n.defaultLocale = "en_US.UTF-8";
i18n.extraLocaleSettings = {
LC_ADDRESS = "en_US.UTF-8";
LC_IDENTIFICATION = "en_US.UTF-8";
LC_MEASUREMENT = "en_US.UTF-8";
LC_MONETARY = "en_US.UTF-8";
LC_NAME = "en_US.UTF-8";
LC_NUMERIC = "en_US.UTF-8";
LC_PAPER = "en_US.UTF-8";
LC_TELEPHONE = "en_US.UTF-8";
LC_TIME = "en_US.UTF-8";
}; 

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

}
