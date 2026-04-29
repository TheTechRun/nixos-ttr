{ mkNixosSystem, desktopPackages, laptopPackages, serverPackages, minimalPackages }:
let
  hostPackageSets = {
    desktop = desktopPackages;
    laptop = laptopPackages;
    server = serverPackages;
    minimal = minimalPackages;
  };
in {
  nixosConfigurations =
    builtins.mapAttrs
      (hostName: extraPackages:
        mkNixosSystem {
          inherit hostName extraPackages;
        })
      hostPackageSets;
}
