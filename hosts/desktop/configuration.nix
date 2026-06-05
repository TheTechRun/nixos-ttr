{ config, pkgs, lib, ... }:

# Paths are defined in ../../modules/paths.nix
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
(paths.system + "/unfree.nix")
(paths.system + "/moto.nix")
(paths.system + "/audio.nix")
(paths.system + "/cron.nix")
# (paths.cups + "/cups-canon-zebra.nix")
(paths.system + "/firewall.nix")
(paths.system + "/prune-system-generations.nix")
(paths.networkShare + "/network-share.nix")
(paths.system + "/samba.nix")
# (paths.system + "/cloudflared/cloudflared-desktop.nix")
(paths.system + "/services.nix")
(paths.system + "/ssh.nix")
(paths.system + "/virtualization.nix")
(paths.system + "/fonts.nix")
(paths.system + "/zram.nix")
(paths.keyboard + "/xmodmap.nix")


# OTHER IMPORTS START HERE -----------------------------
# Filesystem & LUKS Drives
# ./mounts.nix
# (paths.system + "/rclone-mount.nix")

# Kernel
(paths.kernels + "/latest.nix")

# Users
(paths.users + "/global-users.nix")

];
  
# Home Manager
home-manager.users.ttr = import (paths.users + "/home-ttr.nix");

# Enable flakes
nix.settings.experimental-features = [ "nix-command" "flakes" ];
nix.settings.extra-substituters = [
  "https://nix-community.cachix.org"
];
nix.settings.extra-trusted-public-keys = [
  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
];

# Set buffer size
#nix.settings.download-buffer-size = 52428800; # 50mb
nix.settings.download-buffer-size = 104857600; # 100mb
  
# Define your hostname
networking.hostName = "desktop"; 

# Define your nixos version - NEVER CHANGE THIS
system.stateVersion = "24.05";  

# Enable networking
networking.networkmanager.enable = true;
services.dbus.implementation = "dbus";

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

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}