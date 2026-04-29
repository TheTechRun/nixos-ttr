{ config, lib, pkgs, ... }:

let
username = "ttr";  # Define the username here for easy changing
userHome = config.users.users.${username}.home;
in
{
services.cron = {
enable = true;
systemCronJobs = [

# Master Script  2am, 7am, 2pm, 7pm
"0 2,7,14,19 * * * ${username} ${userHome}/.scripts/media-renamer/master.sh"

# Serve Ultimate Drive rclone every 5 minutes
"*/5 * * * * ${username} ${userHome}/serve/rclone-serve/ultimate-start.sh"

# Serve Port TV every 5 minutes       
# "* * * * * ${username} bash -l -c '${userHome}/serve/py-serve/port-tv/port-tv.sh start'"

# Clear Log files daily at 12:45 AM
"45 0 * * * ${username} ${userHome}/.scripts/logs/clear-all-logs.sh"

# Git repo sync watcher - every 1 minute
"*/10 * * * * ${username} bash -l -c 'DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/\$(id -u)/bus ${userHome}/dev/cli-tools/git/git-watcher/git-watcher.sh'"

# ------------ Backup Schedule - Daily Pipeline Starts Here ---------

# Home Backup Restic  - 1:00 AM Daily
"0 1 * * * ${username} ${userHome}/.scripts/restic-scripts/home/home-backup.sh"

# Baikal Backup - 9:00 PM Daily
"0 21 * * * ${username} ${userHome}/docker/baikal/backup-sqlite.sh"

# Docker-data Backup - 1:00 AM Daily (as root for permissions)
# "0 1 * * * root bash /mnt/12tb/Backups/backup-scripts/docker-data.sh"

# Copy/Sync Operations - 3:00 AM Daily
# "0 3 * * * ${username} bash /mnt/12tb/Backups/backup-scripts/copy-sync.sh"

# Upload to Encrypted Cloud - 5:00 AM Daily
# "0 5 * * * ${username} bash /mnt/12tb/Backups/backup-scripts/encrypted-upload.sh"


# UNUSED -------------------------------------------------------
# i3 config gitpush script at 1 AM
#"0 1 * * * ${username} ${userHome}/.config/i3/scripts/gitpush.sh"

#Testing 
# "* * * * * ${username} ${pkgs.bashInteractive}/bin/bash /mnt/12tb/TestStuff/cron/test.sh" # For Testing

];
};
}