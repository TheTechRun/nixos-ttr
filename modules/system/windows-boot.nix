# Windows Boot Entry Module
# Adds Windows to systemd-boot menu
{ config, lib, pkgs, ... }:

{
  # Add Windows entry to systemd-boot
  boot.loader.systemd-boot.extraEntries = {
    "windows.conf" = ''
      title Windows 11
      efi /EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  # Optional: Set Windows as default (uncomment if desired)
  # boot.loader.systemd-boot.default = "windows.conf";
  
  # Optional: Set boot timeout for menu selection
  boot.loader.timeout = 15;
}
