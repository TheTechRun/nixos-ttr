{ config, lib, pkgs, ... }:

let
  username = "ttr";  # Define the username here for easy changing
  userHome = config.users.users.${username}.home;
in
{
  services.cron = {
    enable = true;
    systemCronJobs = [

      # Git repo sync watcher - every 1 minute
      "* * * * * ${username} bash -l -c 'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/\$(id -u)/bus ${userHome}/dev/cli-tools/git/git-watcher/git-watcher.sh'"

      # Daily nixos-config gitpush script at 2 AM
      #"0 2 * * * ${username} ${userHome}/nixos-config/modules/scripts/other/gitpush.sh"

      # Pictures Backup - Runs daily at 5 AM
      #"0 5 * * * ${username} ${userHome}/.scripts/backups/my-pics.sh"

      #Testing
      # "* * * * * ${username} ${pkgs.bashInteractive}/bin/bash /mnt/12tb/TestStuff/cron/test.sh" # For Testing
    ];
  };
}