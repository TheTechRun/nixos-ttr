{ config, lib, pkgs, ... }:

{

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

 # Samba Mounts ---------------------------------------------------------------------
    ## Create the credentials file locally at /etc/nixos/smb-secrets with:
    ## username=...
    ## password=...

    ## shared-files
    fileSystems."/mnt/samba/shared-files" = {
        device = "//server/shared-files";
        fsType = "cifs";
        options = [
          "credentials=/etc/nixos/smb-secrets"
          "uid=5000"
          "gid=5001"
          "file_mode=0660"
          "dir_mode=0770"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "x-systemd.requires=tailscaled.service"
          "x-systemd.after=tailscaled.service"
          "noauto"
        ];
      };

    ## watch-media
    fileSystems."/mnt/samba/watch-media" = {
        device = "//server/watch-media";
        fsType = "cifs";
        options = [
          "guest"
          "uid=5000"
          "gid=5001"
          "file_mode=0660"
          "dir_mode=0770"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "x-systemd.requires=tailscaled.service"
          "x-systemd.after=tailscaled.service"
          "noauto"
        ];
      };

    ## watch-media-2
    fileSystems."/mnt/samba/watch-media-2" = {
        device = "//server/watch-media-2";
        fsType = "cifs";
        options = [
          "credentials=/etc/nixos/smb-secrets"
          "uid=5000"
          "gid=5001"
          "file_mode=0660"
          "dir_mode=0770"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "x-systemd.requires=tailscaled.service"
          "x-systemd.after=tailscaled.service"
          "noauto"
        ];
      };

    ## draft-notes
    fileSystems."/mnt/samba/draft-notes" = {
        device = "//server/draft-notes";
        fsType = "cifs";
        options = [
          "credentials=/etc/nixos/smb-secrets"
          "uid=5000"
          "gid=5000"
          "file_mode=0660"
          "dir_mode=0770"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "x-systemd.requires=tailscaled.service"
          "x-systemd.after=tailscaled.service"
          "noauto"
        ];
      };

    ## user-files
    fileSystems."/mnt/samba/user-files" = {
        device = "//server/user-files";
        fsType = "cifs";
        options = [
          "credentials=/etc/nixos/smb-secrets"
          "uid=5000"
          "gid=5000"
          "file_mode=0660"
          "dir_mode=0770"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "x-systemd.requires=tailscaled.service"
          "x-systemd.after=tailscaled.service"
          "noauto"
        ];
      };

    ## pic-favorites
    fileSystems."/mnt/samba/pic-favorites" = {
        device = "//server/pic-favorites";
        fsType = "cifs";
        options = [
          "credentials=/etc/nixos/smb-secrets"
          "uid=5000"
          "gid=5000"
          "file_mode=0660"
          "dir_mode=0770"
          "_netdev"
          "nofail"
          "x-systemd.automount"
          "x-systemd.requires=tailscaled.service"
          "x-systemd.after=tailscaled.service"
          "noauto"
        ];
      };

}
