{ lib, pkgs, hostName, ... }:

lib.mkIf (hostName == "desktop") {
  networking.wireguard.enable = true;

  environment.systemPackages = with pkgs; [
    wireguard-tools
    qrencode
    zbar
  ];

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
}
