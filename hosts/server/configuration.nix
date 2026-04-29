{ config, pkgs, lib, ... }:

{
  imports =
      [ 

# Login Manager
# ../../modules/desktop-environment/wayland/display-manager/greetd/tuigreet-swayfx.nix
../../modules/desktop-environment/wayland/display-manager/greetd/tuigreet-scroll.nix
# ../../modules/desktop-environment/x11/display-manager/light-dm/lightdm.nix
# ../../modules/desktop-environment/wayland/display-manager/greetd/tuigreet-niri.nix

# Desktop Environment
# ../../modules/desktop-environment/x11/i3.nix
# ../../modules/desktop-environment/wayland/swayfx.nix
../../modules/desktop-environment/wayland/scroll-flake/scroll.nix
# ../../modules/desktop-environment/wayland/niri.nix
          
# System
./hardware-configuration.nix
../../modules/system/cron/cron-server.nix
../../modules/system/firewall/firewall-server.nix
../../modules/system/network-share/network-share-server.nix
../../modules/system/services/services-server.nix
../../modules/system/ssh/ssh-server.nix
../../modules/system/fonts/fonts.nix
../../modules/system/samba/samba-server.nix
# OTHER IMPORTS START HERE -----------------------------

# Users
../../modules/users/ttr-server/specific-users.nix
# LUKS External Drives
./mounts.nix

# Kernel
#../../modules/system/kernels/latest.nix

];
  
  
# Enable flakes.
nix.settings.experimental-features = [ "nix-command""flakes" ];

# Set buffer size
#nix.settings.download-buffer-size = 52428800; # 50mb
nix.settings.download-buffer-size = 104857600; # 100mb

# Define your hostname.
networking.hostName = "server"; 

# Define your nixos version.
system.stateVersion = "24.05"; 

home-manager.users.ttr-server = import ../../modules/users/ttr-server/home-ttr-server.nix;

# Enable networking
networking.networkmanager.enable = true;

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
