{ config, lib, pkgs, ... }:

{
  # Run: sudo lsblk -o NAME,SIZE,MOUNTPOINT,UUID
  # External encrypted drives LUKS configuration
  # These are not needed for boot, so they won't block the boot process
  
  # Luks Prompt at boot: --------------------------------------------------------
  
  # 12TB - External drive encryption (9.9TB partition, sda1)
  boot.initrd.luks.devices."crypted-external1" = {
    device = "/dev/disk/by-uuid/0674756e-8ec6-4e69-a3a4-e7c3c30f3a08";
    preLVM = false;
    allowDiscards = true;
  };

  # HOME 1TB - External drive encryption (1TB partition, sda2)
  boot.initrd.luks.devices."crypted-external2" = {
    device = "/dev/disk/by-uuid/ec5ed926-d10c-4a2a-8641-cf2a02e6a7d4";
    preLVM = false;
    allowDiscards = true;
  };

  # # Backup Drive 1TB - WD BLUE (sdb1)
  # boot.initrd.luks.devices."crypted-external3" = {
    # device = "/dev/disk/by-uuid/dce8d2d4-19d9-4412-be88-a65243b4a483";
    # preLVM = false;
    # allowDiscards = true;
  # };

  # Filesystem mounts for decrypted LUKS drives -------------------------------
  
  # 12TB - Mount point for 9.9TB partition (filesystem inside crypted-external1)
  fileSystems."/mnt/12tb" = {
    device = "/dev/disk/by-uuid/281b8602-4a78-4c24-b49e-bc2c040e8c8f";
    fsType = "btrfs";
    options = [ "defaults" "noatime" ];
    neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
  };

  # HOME 1TB - Mount the encrypted 1TB partition as /home (filesystem inside crypted-external2)
  fileSystems."/mnt/old-home" = {
    device = "/dev/disk/by-uuid/acc16176-82bf-4982-afb3-7ca3b10f461c";
    fsType = "btrfs";
    options = [ "defaults" "noatime" ];
    neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
  };

  # # Backup Drive 1TB - WD BLUE mount point
  # fileSystems."/mnt/1tb" = {
    # device = "/dev/disk/by-uuid/3a041146-d1bf-4db4-9bb6-a1e2cc02540f";
    # fsType = "btrfs";
    # options = [ "defaults" "noatime" ];
    # neededForBoot = false;  # Critical: Don't block boot if drive isn't connected
  # };
}