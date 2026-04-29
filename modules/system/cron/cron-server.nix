{ config, lib, pkgs, ... }:

let
  username = "ttr-server";  # Define the username here for easy changing
  userHome = config.users.users.${username}.home;
in
{
  services.cron = {
    enable = true;
    systemCronJobs = [
      # Master Script  1am, 6am, 1pm, 6pm
      "0 1,6,13,18 * * * ${username} ${userHome}/.scripts/cronjobs/master.sh"

      # Flake Update every Monday at 12:30am
      "30 0 * * 1 ${username} ${userHome}/nixos-config/modules/scripts/desktop-flake-update.sh >> ${userHome}/.scripts/logs/flakes_updates.log 2>&1"

      # Serve Port TV every 5 minutes       
      "*/5 * * * * ${username} bash -l -c '${userHome}/serve/py-serve/port-tv/port-tv.sh start'"

      # Clear Log files daily at 12:45 AM
      "45 0 * * * ${username} ${userHome}/.scripts/logs/clear-all-logs.sh"

      # Home Backup - Runs at 2 AM every Monday
      #"0 2 * * 1 ${username} ${userHome}/.scripts/backups/HOME.sh"

      # Music Backup - Runs daily at 3 AM
      #"0 3 * * * ${username} ${userHome}/.scripts/backups/music.sh"

      # Docker Backup - Runs daily at 4 AM
      #"0 4 * * * ${username} ${userHome}/.scripts/backups/docker.sh"

      # Pictures Backup - Runs daily at 5 AM
      #"0 5 * * * ${username} ${userHome}/.scripts/backups/my-pics.sh"

      #Testing
      # "* * * * * ${username} ${pkgs.bashInteractive}/bin/bash /mnt/12tb/TestStuff/cron/test.sh" # For Testing
    ];
  };
}
