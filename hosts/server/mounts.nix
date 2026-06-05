{ config, lib, pkgs, ... }:

{
  # Run: sudo lsblk -o NAME,SIZE,MOUNTPOINT,UUID
  # External encrypted drives LUKS configuration
  # These are not needed for boot, so they won't block the boot process
  
  # Luks Prompt at boot: --------------------------------------------------------
  
  # 12TB - External drive encryption (9.9TB partition, sda1)
  boot.initrd.luks.devices."crypted-external1" = {
    device = "/dev/disk/by-uuid/99999999-0000-8888-1111-222222222222";
    allowDiscards = true;
    crypttabExtraOpts = [ "tries=0" ];
  };

  # HOME 1TB - External drive encryption (1TB partition, sda2)
  boot.initrd.luks.devices."crypted-external2" = {
    device = "/dev/disk/by-uuid/99999999-0000-8888-1111-222222222222";
    allowDiscards = true;
    crypttabExtraOpts = [ "tries=0" ];
  };

  # # Backup Drive 1TB - WD BLUE (sdb1)
  # boot.initrd.luks.devices."crypted-external3" = {
    # device = "/dev/disk/by-uuid/99999999-0000-8888-1111-222222222222";
    # allowDiscards = true;
  # };

  # Filesystem mounts for decrypted LUKS drives -------------------------------
  
 # 12TB - Mount point for 9.9TB partition (filesystem inside crypted-external1)
 fileSystems."/mnt/12tb" = {
   device = "/dev/disk/by-uuid/88888888-1111-7777-2222-333333333333";
   fsType = "btrfs";
   options = [ "defaults" "noatime" ];
   neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
 };

 # HOME 1TB - Mount the encrypted 1TB partition as /home (filesystem inside crypted-external2)
 fileSystems."/mnt/old-home" = {
   device = "/dev/disk/by-uuid/77777777-2222-7777-3333-444444444444";
   fsType = "btrfs";
   options = [ "defaults" "noatime" ];
   neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
 };

  # # Backup Drive 1TB - WD BLUE mount point
  # fileSystems."/mnt/1tb" = {
    # device = "/dev/disk/by-uuid/77777777-3333-5555-4444-555555555555";
    # fsType = "btrfs";
    # options = [ "defaults" "noatime" ];
    # neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
  # };
}