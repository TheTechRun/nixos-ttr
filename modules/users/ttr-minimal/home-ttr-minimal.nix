{ config, pkgs, ... }:

{
  # Basic user settings
  home.username = "ttr-minimal";
  home.homeDirectory = "/home/ttr";

  # Minimal environment variables
  home.sessionVariables = {
    EDITOR = "nano";  # Use nano instead of micro for minimal
  };

  # Only essential packages for minimal system
  home.packages = with pkgs; [
    # Just the basics
    curl
    wget
    git
    vim
    htop
    tree
  ];

  # Basic git configuration
  programs.git = {
    enable = true;
    settings.user.name = "Classerton";
    settings.user.email = "you@example.com";
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}