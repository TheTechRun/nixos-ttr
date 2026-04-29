# to organize and sort programs alphabetically run: ~/nixos-config/scripts/line-alphabetical-sort.sh

{ config, pkgs, ... }:
{
imports = [
#./builds/xdman7.nix
#./builds/n-m3u8dl-re.nix
../dependencies/flatpak.nix    
../dependencies/lsp.nix    
../dependencies/development.nix
../dependencies/cli-tools.nix
#./bashrc.nix
#...other imports
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
apacheHttpd # for htpasswd
#alsa-lib
alsa-lib-with-plugins
apksigner
# audacity  # Temporarily removed due to build issues
# autokey
bashmount
bat
bfg-repo-cleaner
bitwarden-desktop
bubblewrap #unpriviledged sandboxing tool for codex (bwrap)
cargo-tauri
chafa
cryptomator
cryptomator-cli
curlftpfs
deno        # Deno runtime
devbox      # Development environments
distrobox
dnslookup
docker-compose
dragon-drop
dust          # Disk usage
eog # image viewer
evtest #event debugging
eza # ls replacement
fasd
fastfetch
figlet      # ASCII art text
file
font-awesome
fzf
gdb # debugger
gImageReader
# gimp  # removed due to build issues
git-filter-repo
glow
highlight
imagemagick
imv  # Wayland-native image viewer alternative
kak-tree-sitter
kakoune
kakoune-lsp
kitty
lazydocker
lazygit
# libreoffice-fresh
# lmms
megacmd
n-m3u8dl-re
neofetch
# neovim
nicotine-plus
nodejs_24   # Node.js slim npm
obs-studio
piper-tts
# polybarFull
protonvpn-gui
ps
python313Packages.shtab       # Shell completions
restic #backups
# rustup
scrcpy
starship
# stremio # Temporarily removed due to build issues
swayimg
satty # screenshots
telegram-desktop
tesseract
timg
tmux
util-linux
vial
virt-manager
viu
vivaldi
# wineWowPackages.stable
# wineWow64Packages.stable
winetricks
wl-color-picker
wtype
xdman7
#xdman8
xdotool
xmlstarlet
yt-dlp
zsh
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
settings.user.name = "ttr";
settings.user.email = "you@example.com";
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