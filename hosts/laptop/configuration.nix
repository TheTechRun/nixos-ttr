{ config, pkgs, lib, inputs, ... }:

{
  imports =
[ 
inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3


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
../../modules/system/boot/windows-boot.nix
../../modules/system/audio/audio-laptop.nix
../../modules/system/swap/16gb-swap.nix
../../modules/system/cron/cron-laptop.nix
../../modules/system/cups/cups.nix
../../modules/system/firewall/firewall-laptop.nix
../../modules/system/generations/prune-system-generations-laptop.nix
../../modules/system/network-share/network-share-laptop.nix
../../modules/system/samba/samba-laptop.nix
../../modules/system/services/services-laptop.nix
../../modules/system/ssh/ssh-laptop.nix
../../modules/system/virtualization/virtualization-laptop.nix
# ../../modules/system/keyboard/xdomap.nix
../../modules/system/fonts/fonts.nix
../../modules/system/keyboard/thinkpad-T14.nix
../../modules/system/power/amd.nix
../../modules/system/power/lid-closed.nix

# OTHER IMPORTS START HERE -----------------------------
# Kernel
./../../modules/system/kernels/lts.nix
      
# Users
../../modules/users/ttr/specific-users.nix

];
  
home-manager.users.ttr = import ../../modules/users/ttr/home-ttr.nix;
  
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

environment.sessionVariables = {
PATH = ["${pkgs.pyload-ng}/bin"];
};

# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";  

}
