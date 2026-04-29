{ lib }:

let
  mountRoot = "/srv/nfs";

  mkMountPoint = name: "${mountRoot}/${name}";

  mkBindMount =
    { name
    , path
    , depends ? [ ]
    , readOnly ? false
    , ...
    }:
    {
      fileSystems.${mkMountPoint name} = {
        device = path;
        fsType = "none";
        options = [ "bind" "nofail" ] ++ lib.optionals readOnly [ "ro" ];
        inherit depends;
        neededForBoot = false;
      };
    };

  mkExportLine =
    { name
    , clients
    , readOnly ? false
    , extraOptions ? [ ]
    , ...
    }:
    let
      options =
        [
          (if readOnly then "ro" else "rw")
          "sync"
          "no_subtree_check"
        ]
        ++ extraOptions;
    in
    "${mkMountPoint name} ${clients}(${lib.concatStringsSep "," options})";

  mkShareModule =
    { shares
    , clients ? "192.168.1.0/24"
    }:
    lib.mkMerge (
      [
        {
          services.nfs.server = {
            enable = true;
            mountdPort = 4002;
            statdPort = 4000;
            lockdPort = 4001;
            exports = lib.concatLines (map (share: mkExportLine (share // { inherit clients; })) shares);
          };

          systemd.tmpfiles.rules =
            [ "d ${mountRoot} 0755 root root -" ]
            ++ map (share: "d ${mkMountPoint share.name} 0755 root root -") shares;

          networking.firewall = {
            allowedTCPPorts = [ 111 2049 4000 4001 4002 ];
            allowedUDPPorts = [ 111 2049 4000 4001 4002 ];
          };
        }
      ]
      ++ map (share: mkBindMount share) shares
    );
in
{
  inherit mkShareModule;
}
