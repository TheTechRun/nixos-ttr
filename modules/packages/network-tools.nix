{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    apacheHttpd
    curlftpfs
    dnslookup
    fuse3
    megacmd
    nicotine-plus
    ntfs3g
    obs-studio
    proton-vpn
    rclone
    rsync
    sshfs
    yt-dlp
    xdman7
  ];
}