{ config, pkgs, lib, inputs, ... }:

let
  paths = import ../../modules/paths.nix;
in
{
  imports =
[ 
inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3


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
(paths.system + "/moto.nix")
(paths.system + "/windows-boot.nix")
(paths.system + "/audio.nix")
(paths.system + "/cron.nix")
(paths.cups + "/cups.nix")
(paths.system + "/firewall.nix")
(paths.system + "/prune-system-generations.nix")
(paths.networkShare + "/network-share.nix")
# (paths.system + "/samba.nix")
(paths.system + "/services.nix")
(paths.system + "/ssh.nix")
(paths.system + "/virtualization.nix")
# (paths.keyboard + "/xdomap.nix")
(paths.system + "/fonts.nix")
(paths.keyboard + "/thinkpad-T14.nix")
(paths.power + "/amd.nix")
(paths.power + "/lid-closed.nix")

# OTHER IMPORTS START HERE -----------------------------
# Filesystem & NFS mounts
# ./mounts.nix

# Kernel
(paths.kernels + "/lts.nix")
      
# Users
(paths.users + "/global-users.nix")

];
  
home-manager.users.ttr = import (paths.users + "/home-ttr.nix");
  
# Enable flakes
nix.settings.experimental-features = [ "nix-command" "flakes" ];

  
# Set buffer size
#nix.settings.download-buffer-size = 52428800; # 50mb
nix.settings.download-buffer-size = 104857600; # 100mb
  
# Define your hostname.
networking.hostName = "laptop"; 

# Define your nixos version.
system.stateVersion = "24.05"; 

# Enable networking
networking.networkmanager.enable = true;
services.dbus.implementation = "dbus";

# Set terminator as the default terminal
environment.variables = {
XDG_TERMINAL = "terminator";
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

# Trackpad configuration with natural scrolling
services.libinput = {
  enable = true;
  touchpad = {
    naturalScrolling = true;
    tapping = true;
    clickMethod = "clickfinger";
    disableWhileTyping = true;
  };
};

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