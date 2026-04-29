{ config, pkgs, ... }:

{
  # Note: android-tools is installed via Home Manager in home-ttr.nix
  # Note: adbusers group and user membership is handled in users.nix

  # Add additional udev rules for Motorola devices specifically
  services.udev.extraRules = ''
    # Motorola devices
    SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", MODE="0666", GROUP="adbusers"
    
    # General Android devices in fastboot mode
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee0", MODE="0666", GROUP="adbusers"
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee1", MODE="0666", GROUP="adbusers"
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee2", MODE="0666", GROUP="adbusers"
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee7", MODE="0666", GROUP="adbusers"
    
    # Additional Motorola vendor IDs and common fastboot product IDs
    SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", ATTR{idProduct}=="2e76", MODE="0666", GROUP="adbusers"
    SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", ATTR{idProduct}=="2e81", MODE="0666", GROUP="adbusers"
    SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", ATTR{idProduct}=="2e82", MODE="0666", GROUP="adbusers"
    
    # Motorola in fastboot mode (common product IDs)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="22b8", ATTRS{idProduct}=="*", MODE="0666", GROUP="adbusers"
  '';
}
