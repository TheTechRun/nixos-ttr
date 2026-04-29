{ config, pkgs, ... }:

{
  home.username = "family";
  home.homeDirectory = "/home/family";

  # Cursor and DPI settings
  xresources.properties = {
    "Xcursor.size" = 22;
    # "Xft.dpi" = 172;  # Uncomment if using a 4K monitor
  };

  # Packages for the family user
  home.packages = with pkgs; [
libreoffice-fresh
# vscodium  # Uncomment if needed

# Fonts
#font-awesome
#nerdfonts
#unifont
  ];

  # Example of how to configure a program (uncomment and modify as needed)
  # programs.git = {
  #   enable = true;
  #   userName = "Family User";
  #   userEmail = "family@example.com";
  # };

  # This value determines the Home Manager release that your
  # configuration is compatible with. It's recommended to keep this up to date.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}