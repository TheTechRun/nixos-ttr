# to organize and sort programs alphabetically run: ~/nixos-config/scripts/line-alphabetical-sort.sh

{ config, pkgs, ... }:

# Paths are defined in ../paths.nix
let
  paths = import ../paths.nix;
in
{
  imports =
[
(paths.packages + "/flatpak.nix")
(paths.packages + "/lsp.nix")
(paths.packages + "/cli-tools.nix")
(paths.packages + "/essentials.nix")
(paths.packages + "/dev-tools.nix")
(paths.packages + "/network-tools.nix")
(paths.packages + "/media-tools.nix")
(paths.packages + "/desktop-apps.nix")
(paths.packages + "/desktop-tools.nix")
(paths.packages + "/backup-sync.nix")
(paths.packages + "/android-mobile.nix")
(paths.packages + "/creator-tools.nix")
(paths.packages + "/x11-tools.nix")
];
#  change the username & home directory to your own
home.username = "ttr";
home.homeDirectory = "/home/ttr";

# Set cursor size and dpi for 4k monitor
xresources.properties = {
"Xcursor.size" = 22;
# "Xft.dpi" = 172;
};

# Packages that should be installed to the user profile.
# Window Manager Specific programs are located at ~/nixos-config/modules/desktop-environment/wm/wayland
home.packages = with pkgs; [
vivaldi
];


# basic configuration of programs, please change to your own:
#Git
programs.bat = {
enable = true;
config = {
theme = "GitHub";
italic-text = "always";
};    
};

programs.git = {
enable = true;
signing.format = "openpgp";
settings.user.name = "ttr";
settings.user.email = "git@cloudlive.us";
};

# npm global install (defined in .bashrc instead)
# home.file.".npmrc".text = "prefix=/home/ttr/.npm-global\n";
# home.sessionPath = [ "/home/ttr/.npm-global/bin" ];

home.file.".bash_profile".text = ''
  [[ -f ~/.bashrc ]] && source ~/.bashrc
'';

home.stateVersion = "24.05";
programs.home-manager.enable = true;
}
