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
../../modules/system/android/moto.nix
../../modules/system/audio/audio-desktop.nix
../../modules/system/cron/cron-desktop.nix
#../../modules/system/cups/cups-canon-zebra.nix
../../modules/system/firewall/firewall-desktop.nix
../../modules/system/generations/prune-system-generations-desktop.nix
../../modules/system/network-share/network-share-desktop.nix
../../modules/system/samba/samba-desktop.nix
../../modules/system/services/cloudflared-desktop.nix
../../modules/system/services/services-desktop.nix
../../modules/system/ssh/ssh-desktop.nix
../../modules/system/virtualization/virtualization-desktop.nix
../../modules/system/fonts/fonts.nix
../../modules/system/zram/50-zram.nix 
../../modules/system/keyboard/xmodmap.nix


# OTHER IMPORTS START HERE -----------------------------
# Filesystem & LUKS Drives
./mounts.nix
../../modules/system/systemd/rclone-mount-desktop.nix

# Kernel
../../modules/system/kernels/latest.nix

# Users
../../modules/users/ttr/specific-users.nix

];
  
home-manager.users.ttr = import ../../modules/users/ttr/home-ttr.nix;

# Enable flakes
nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Set buffer size
#nix.settings.download-buffer-size = 52428800; # 50mb
nix.settings.download-buffer-size = 104857600; # 100mb
  
# Define your hostname
networking.hostName = "desktop"; 

# Define your nixos version - NEVER CHANGE THIS
system.stateVersion = "24.05";  

# Enable networking
networking.networkmanager.enable = true;

# Auto mount usb-devices
services.udisks2.enable = true;

# Set the default terminal
environment.variables = {
XDG_TERMINAL = "kitty";
};     

# Some programs need SUID wrappers, can be configuredfurther or are
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
boot.loader.systemd-boot.configurationLimit = 15; 
boot.loader.efi.canTouchEfiVariables = true;

# Bootloader. (Use this for grub instead, especially if you're on a VM)
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

# Select international localisation properties.
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

environment.sessionVariables = {
PATH = ["${pkgs.pyload-ng}/bin"];
};

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
