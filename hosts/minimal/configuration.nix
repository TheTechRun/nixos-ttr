{ config, pkgs, lib, ... }:

{
imports = [
# Hardware configuration (you'll need to generate this)
./hardware-configuration.nix

# Just the essential system modules
../../modules/system/fonts/fonts.nix


# Desktop Environment
../../modules/desktop-environment/x11/display-manager/light-dm/lightdm.nix
#../../modules/desktop-environment/x11/i3.nix

# Users
../../modules/users/ttr-minimal/specific-users.nix

];

# Home Manager
home-manager.users.ttr-minimal = import ../../modules/users/ttr-minimal/home-ttr-minimal.nix;

# Enable flakes
nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Set buffer size for faster downloads
nix.settings.download-buffer-size = 104857600; # 100mb

# Define hostname
networking.hostName = "minimal";

# Define NixOS version
system.stateVersion = "24.05";

# Enable networking
networking.networkmanager.enable = true;

# Enable mutable users
users.mutableUsers = true;

# Enable sudo
security.sudo.enable = true;

# Bootloader
boot.loader.systemd-boot.enable = true;
boot.loader.systemd-boot.configurationLimit = 15;
boot.loader.efi.canTouchEfiVariables = true;

# Garbage collection
nix.gc = {
automatic = true;
dates = "weekly";
options = "--delete-older-than 15d";
};

# Enable bin files to run
programs.nix-ld.enable = true;

# Set time zone
time.timeZone = "America/New_York";

# Locale settings
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

# Basic packages for installation and system switching
environment.systemPackages = with pkgs; [
# Essential tools
curl wget git vim nano
# Network tools
networkmanager
# System tools
htop tree
# Build tools (needed for nixos-rebuild)
gcc gnumake
];

# Enable SSH for remote management
services.openssh = {
enable = true;
settings = {
PermitRootLogin = "yes";
PasswordAuthentication = true;
};
};

# Basic firewall
networking.firewall = {
enable = true;
allowedTCPPorts = [ 22 ]; # SSH
};
}
