{ mkNixosSystem }:
{
  nixosConfigurations =
    builtins.mapAttrs
      (hostName: _:
        mkNixosSystem {
          inherit hostName;
        })
      {
        desktop = { };
        laptop = { };
        server = { };
        minimal = { };
      };
}
