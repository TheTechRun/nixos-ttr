{ config, hostName, lib, pkgs, ... }:

let
  username = "ttr";
  userHome = config.users.users.${username}.home;
  cleanupMount = pkgs.writeShellScript "rclone-gdrive-cleanup" ''
    /run/wrappers/bin/fusermount3 -u /mnt/rclone/gdrive 2>/dev/null || \
      /run/wrappers/bin/fusermount3 -uz /mnt/rclone/gdrive 2>/dev/null || true
  '';
in
lib.mkIf (hostName == "desktop") {
  programs.fuse.userAllowOther = true;

  systemd.tmpfiles.rules = [
    "d /mnt/rclone             0755 ${username} ${username} -"
    "d /mnt/rclone/gdrive      0755 ${username} ${username} -"
    "d /mnt/rclone/cache       0755 ${username} ${username} -"
    "d /mnt/rclone/cache/gdrive 0755 ${username} ${username} -"
  ];

  systemd.services."rclone-gdrive" = {
    description = "rclone mount for Google Drive";
    after = [ "NetworkManager-wait-online.service" "network-online.target" "resolvconf.service" ];
    wants = [ "NetworkManager-wait-online.service" "network-online.target" "resolvconf.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.rclone pkgs.fuse3 ];

    serviceConfig = {
      Type = "notify";
      User = username;
      Group = username;
      Environment = [
        "PATH=/run/wrappers/bin:${lib.makeBinPath [ pkgs.coreutils pkgs.findutils pkgs.gnugrep pkgs.gnused pkgs.systemd pkgs.rclone pkgs.fuse3 ]}"
      ];
      NoNewPrivileges = false;
      ExecStartPre = cleanupMount;
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount gdrive: /mnt/rclone/gdrive \
          --config ${userHome}/.config/rclone/rclone.conf \
          --vfs-cache-mode writes \
          --vfs-cache-max-age 1d \
          --vfs-cache-max-size 400G \
          --cache-dir /mnt/rclone/cache/gdrive \
          --uid 5000 \
          --gid 5000 \
          --dir-perms 0775 \
          --file-perms 0664 \
          --umask 0002 \
          --allow-other
      '';
      ExecStop = "/run/wrappers/bin/fusermount3 -u /mnt/rclone/gdrive";
      ExecStopPost = cleanupMount;
      RestartSec = "5s";
    };
  };
}
