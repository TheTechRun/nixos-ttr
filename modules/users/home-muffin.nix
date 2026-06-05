{ config, pkgs, ... }:
let
  paths = import ../paths.nix;
in
{
  imports = [
    (paths.packages + "/essentials.nix")
  ];

  home.username = "muffin";
  home.homeDirectory = "/home/muffin";

  # Cursor and DPI settings
  xresources.properties = {
    "Xcursor.size" = 22;
    # "Xft.dpi" = 172;  # Uncomment if using a 4K monitor
  };

  # Packages for the family user
  home.packages = with pkgs; [
libreoffice-fresh
# vscodium  # Uncomment if needed
  ];

  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
