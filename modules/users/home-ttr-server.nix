{ config, pkgs, ... }:
let
  paths = import ../paths.nix;
in
{
  # Basic user settings
imports = [
(paths.packages + "/lsp.nix")
(paths.packages + "/server.nix")
# (paths.packages + "/dev-tools.nix")
#...other imports
];

  home.username = "ttr-server";
  home.homeDirectory = "/home/ttr";

  # Minimal environment variables
  home.sessionVariables = {
    EDITOR = "tt";  # Use nano instead of micro for minimal
  };

  # Only essential packages for minimal system
home.packages = with pkgs; [
vivaldi
];

  # Basic git configuration
  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings.user.name = "ttr";
    settings.user.email = "git@cloudlive.us";
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
