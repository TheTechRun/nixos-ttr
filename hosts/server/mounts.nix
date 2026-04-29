{ config, lib, pkgs, ... }:

{
  # Replace the UUID placeholders below with values from your machine.
  # Run: sudo lsblk -o NAME,SIZE,MOUNTPOINT,UUID
  # External encrypted drives LUKS configuration
  # These are not needed for boot, so they won't block the boot process

  # # 12TB - External drive encryption (9.9TB partition, sda1)
  # boot.initrd.luks.devices."crypted-external1" = {
  #   device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-12TB-LUKS-UUID";
  #   preLVM = false;
  #   allowDiscards = true;
  # };

  # # HOME 1TB - External drive encryption (1TB partition, sda2)
  # boot.initrd.luks.devices."crypted-external2" = {
  #   device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-OLD-HOME-LUKS-UUID";
  #   preLVM = false;
  #   allowDiscards = true;
  # };

  # # Backup Drive 1TB - WD BLUE (sdb1)
  # boot.initrd.luks.devices."crypted-external3" = {
  #   device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-BACKUP-LUKS-UUID";
  #   preLVM = false;
  #   allowDiscards = true;
  # };

  # Filesystem mounts for decrypted drives

  # 12TB - Mount point for 9.9TB partition (filesystem inside crypted-external1)
  fileSystems."/mnt/12tb" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-12TB-FILESYSTEM-UUID";
    fsType = "btrfs";
    options = [ "defaults" "noatime" ];
    neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
  };

  # HOME 1TB - Mount the encrypted 1TB partition as /home (filesystem inside crypted-external2)
  fileSystems."/mnt/old-home" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-OLD-HOME-FILESYSTEM-UUID";
    fsType = "btrfs";
    options = [ "defaults" "noatime" ];
    neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
  };

  # # Backup Drive 1TB - WD BLUE mount point
  # fileSystems."/mnt/1tb" = {
  #   device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-BACKUP-FILESYSTEM-UUID";
  #   fsType = "btrfs";
  #   options = [ "defaults" "noatime" ];
  #   neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
  # };
}
