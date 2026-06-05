{ lib, hostName, ... }:

let
  nfsExportTree = import ./nfs-export-tree.nix { inherit lib; };
  hostSettings = {
    desktop = {
      exports = true;
      userHome = "/home/ttr";
      sharedName = "shared-files";
    };
    laptop = {
      exports = false;
    };
    server = {
      exports = true;
      userHome = "/home/ttr";
      sharedName = "shared-files";
    };
  };
  cfg = hostSettings.${hostName} or (throw "Unsupported hostName for network-share.nix: ${hostName}");
in
if cfg.exports then
  nfsExportTree.mkShareModule {
    shares = [
      {
        name = "file-data";
        path = "/mnt/12tb/file-data";
        readOnly = false;
        depends = [ "/mnt/12tb" ];
      }
      {
        name = "draft-notes";
        path = "/mnt/12tb/Draft_Notes";
        readOnly = false;
        depends = [ "/mnt/12tb" ];
      }
      {
        name = cfg.sharedName;
        path = "${cfg.userHome}/shared-files";
        readOnly = false;
      }
      {
        name = "pic-favorites";
        path = "/mnt/12tb/Backups/pic-favorites";
        readOnly = false;
        depends = [ "/mnt/12tb" ];
      }
    ];
  }
else
  {
    # Laptop is a client for manual NFS mounts, so it does not export shares.
  }
