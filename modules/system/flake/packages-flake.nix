{ system }:
{
# PACKAGES SECTION ---------------------------
commonPackages = pkgs: with pkgs; [
bash bottom coreutils cups curl dmenu fd ffmpeg findutils folder-color-switcher fuse3 gawk gcc git gnugrep gnumake gnused gnutar gtk4 gthumb gzip haskellPackages.greenclip home-manager htop ifuse jdk jq killall less libiconv libimobiledevice libnotify lsof lynx man maven micro ncurses netcat nodejs ntfs3g openssl p7zip pandoc pcmanfm perl pkg-config playerctl plocate moreutils networkmanagerapplet nomacs rclone rename ripgrep rofi rsync scrot solaar sshfs strace trash-cli tree unifont unixtools.top unrar unzip usbutils uutils-coreutils-noprefix vlc wget which wgo xarchiver xed-editor libxcb setxkbmap xmodmap xinit yq zip
];

desktopPackages = pkgs: with pkgs; [
# Add desktop-specific packages here
android-tools firefox chromium micro lf alacritty
# xfce.thunar xfce.thunar-archive-plugin
#terminator #vscodium

];

laptopPackages = pkgs: with pkgs; [
# Add laptop-specific packages here
android-tools firefox chromium micro lf alacritty libinput libinput-gestures 
# xfce.thunar xfce.thunar-archive-plugin
#terminator #vscodium
];

minimalPackages = pkgs: with pkgs; [
# Add minimal-specific packages here
firefox micro libinput libinput-gestures
#terminator #vscodium
#xfce.thunar xfce.thunar-archive-plugin 
];

serverPackages = pkgs: with pkgs; [
# Add server-specific packages here
];
}
