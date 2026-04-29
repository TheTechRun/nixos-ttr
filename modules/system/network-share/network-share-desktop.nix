{ config, lib, ... }:

let
  nfsExportTree = import ./nfs-export-tree.nix { inherit lib; };
  userHome = "/home/ttr";
in
nfsExportTree.mkShareModule {
  shares = [
    {
      name = "tv";
      path = "/mnt/12tb/data/media/tv";
      readOnly = true;
      depends = [ "/mnt/12tb" ];
    }
    {
      name = "movies";
      path = "/mnt/12tb/data/media/movies";
      readOnly = true;
      depends = [ "/mnt/12tb" ];
    }
    {
      name = "music";
      path = "/mnt/12tb/data/media/music";
      readOnly = true;
      depends = [ "/mnt/12tb" ];
    }
    {
      name = "jellyfin";
      path = "/mnt/12tb/data/media/other/Jellyfin";
      readOnly = true;
      depends = [ "/mnt/12tb" ];
    }
    {
      name = "watchlist";
      path = "/mnt/12tb/data/media/other/watchlist";
      readOnly = true;
      depends = [ "/mnt/12tb" ];
    }
    {
      name = "roughdrafts";
      path = "/mnt/12tb/Rough_Drafts";
      readOnly = false;
      depends = [ "/mnt/12tb" ];
    }
    {
      name = "home";
      path = userHome;
      readOnly = false;
    }
    {
      name = "skate";
      path = "${userHome}/gits/github/my-programs/classick-skates";
      readOnly = false;
    }
    {
      name = "shared";
      path = "${userHome}/shared";
      readOnly = false;
    }
    {
      name = "my-pics";
      path = "/mnt/12tb/Backups/my-pics";
      readOnly = false;
      depends = [ "/mnt/12tb" ];
    }
  ];
}
