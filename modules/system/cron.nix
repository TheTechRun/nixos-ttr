{ config, hostName, lib, pkgs, ... }:

let
  usernameByHost = {
    desktop = "ttr";
    laptop = "ttr";
    server = "ttr-server";
  };
  username = usernameByHost.${hostName} or (throw "Unsupported hostName for cron.nix: ${hostName}");
  userHome = config.users.users.${username}.home;
  jobsByHost = {
    desktop = [
      # "0 2,7,14,19 * * * ${username} ${userHome}/.scripts/media-renamer/master.sh"
      # "*/5 * * * * ${username} ${userHome}/serve/rclone-serve/ultimate-start.sh"
      # "45 0 * * * ${username} ${userHome}/.scripts/logs/clear-all-logs.sh"
      # "*/10 * * * * ${username} bash -l -c 'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/\\$(id -u)/bus ${userHome}/dev/cli-tools/git/git-watcher/git-watcher.sh'"
      "0 1 * * * ${username} ${userHome}/cli-tools/restic/repos/home/home-backup.sh"
      # "0 21 * * * ${username} ${userHome}/docker/baikal/backup-sqlite.sh"
    ];
    laptop = [
      # "* * * * * ${username} bash -l -c 'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/\\$(id -u)/bus ${userHome}/dev/cli-tools/git/git-watcher/git-watcher.sh'"
    ];
    server = [
      "0 2,7,14,19 * * * ${username} ${userHome}/.scripts/media-renamer/master.sh"
      "*/5 * * * * ${username} ${userHome}/serve/rclone-serve/ultimate-start.sh"
      "45 0 * * * ${username} ${userHome}/.scripts/logs/clear-all-logs.sh"
      # "0 1 * * * ${username} ${userHome}/cli-tools/restic/repos/home/home-backup.s"
      "0 21 * * * ${username} ${userHome}/docker/baikal/backup-sqlite.sh"
    ];
  };
in
{
  services.cron = {
    enable = true;
    systemCronJobs = jobsByHost.${hostName} or [ ];
  };
}