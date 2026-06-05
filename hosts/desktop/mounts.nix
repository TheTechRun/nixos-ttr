{ config, lib, pkgs, ... }:

{
  # Run: sudo lsblk -o NAME,SIZE,MOUNTPOINT,UUID
  
  # Luks Prompt at boot: --------------------------------------------------------
  
  # # 12TB - External drive encryption (9.9TB partition, sda1)
  # boot.initrd.luks.devices."crypted-external1" = {
    # device = "/dev/disk/by-uuid/99999999-0000-8888-1111-222222222222";
    # allowDiscards = true;
    # crypttabExtraOpts = [ "tries=0" ];
  # };

  # # HOME 1TB - External drive encryption (1TB partition, sda2)
  # boot.initrd.luks.devices."crypted-external2" = {
    # device = "/dev/disk/by-uuid/99999999-0000-8888-1111-222222222222";
    # allowDiscards = true;
    # crypttabExtraOpts = [ "tries=0" ];
  # };

  # Backup Drive 1TB - WD BLUE (sdb1)
  boot.initrd.luks.devices."crypted-external3" = {
    device = "/dev/disk/by-uuid/99999999-0000-8888-1111-222222222222";
    allowDiscards = true;
  };

# Filesystem mounts for decrypted LUKS drives -------------------------------
 # run these 2 commands to get Encrypted Luks uuid
 # sudo cryptsetup open /dev/disk/by-uuid/99999999-0000-8888-1111-222222222222 crypted-external3 
 # sudo blkid /dev/mapper/crypted-external3
 # 12TB - Mount point for 9.9TB partition (filesystem inside crypted-external1)
 # fileSystems."/mnt/12tb" = {
   # device = "/dev/disk/by-uuid/281b8602-4a78-4c24-b49e-bc2c040e8c8f";
   # fsType = "btrfs";
   # options = [ "defaults" "noatime" ];
   # neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
 # };

 # # HOME 1TB - Mount the encrypted 1TB partition as /home (filesystem inside crypted-external2)
 # fileSystems."/mnt/old-home" = {
   # device = "/dev/disk/by-uuid/acc16176-82bf-4982-afb3-7ca3b10f461c";
   # fsType = "btrfs";
   # options = [ "defaults" "noatime" ];
   # neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
 # };

  # Backup Drive 1TB - WD BLUE mount point
  fileSystems."/mnt/1tb" = {
    device = "/dev/disk/by-uuid/8cb7f8f0-7d1e-4fc8-9102-890f24ca6c42";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
    neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
  };


 # NFS Mounts -----------------------------------------------------------------------
    ## shared-files
    fileSystems."/mnt/nfs/shared-files" = {
        device = "192.0.2.10:/srv/nfs/shared-files";
        fsType = "nfs";
        options = [
          "vers=3"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "noauto"
        ];
      };

    ## file-data
    fileSystems."/mnt/nfs/file-data" = {
        device = "192.0.2.10:/srv/nfs/file-data";
        fsType = "nfs";
        options = [
          "vers=3"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "noauto"
        ];
      };

    ## draft-notes
    fileSystems."/mnt/nfs/draft-notes" = {
        device = "192.0.2.10:/srv/nfs/draft-notes";
        fsType = "nfs";
        options = [
          "vers=3"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "noauto"
        ];
      };

    ## pic-favorites
    fileSystems."/mnt/nfs/pic-favorites" = {
        device = "192.0.2.10:/srv/nfs/pic-favorites";
        fsType = "nfs";
        options = [
          "vers=3"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "noauto"
        ];
      };
}
