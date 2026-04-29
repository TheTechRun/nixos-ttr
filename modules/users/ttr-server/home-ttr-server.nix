{ config, pkgs, ... }:

{
  # Basic user settings
imports = [
../dependencies/lsp.nix    
#...other imports
];

  home.username = "ttr-server";
  home.homeDirectory = "/home/ttr";

  # Minimal environment variables
  home.sessionVariables = {
    EDITOR = "tt";  # Use nano instead of micro for minimal
  };

  # Only essential packages for minimal system
  home.packages = with pkgs; [ apksigner bfg-repo-cleaner bottom cargo-tauri cmatrix curl curlftpfs deno
devbox dnslookup docker-compose eog
alacritty fasd fastfetch figlet file
fzf gdb git glow
htop kitty lazydocker lazygit megacmd
n-m3u8dl-re neofetch nodejs_24 ntfs3g
openssl restic ripgrep rustup
scrcpy sshfs starship tesseract
timg tmux tree unifont
unrar usbutils vim wget
wl-color-picker xarchiver xclip xvfb-run
yt-dlp
  ];

  # Basic git configuration
  programs.git = {
    enable = true;
    settings.user.name = "ttr";
    settings.user.email = "you@example.com";
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}