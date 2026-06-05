{ hostName, lib, ... }:

let
  mkHostScopedAttrs = defs:
    lib.mapAttrs
      (_: def:
        let
          base = builtins.removeAttrs def [ "hosts" "hostOverrides" ];
          hostOverride = def.hostOverrides.${hostName} or { };
        in
        base // hostOverride)
      (lib.filterAttrs (_: def: builtins.elem hostName def.hosts) defs);

  userDefs = {
    ttr = {
      hosts = [ "desktop" "laptop" ];
      isNormalUser = true;
      group = "ttr";
      extraGroups = [ "ttr-minimal" "ttr-server" "plugdev" "wheel" "cups" "networkmanager" "scanner" "lp" "libvirtd" "libvirt" "docker" "ttr" "adbusers" "kvm" "plocate" ];
      uid = 5000;
    };

    ttr-server = {
      hosts = [ "server" ];
      isNormalUser = true;
      group = "ttr-server";
      home = "/home/ttr";
      extraGroups = [ "plugdev" "wheel" "cups" "networkmanager" "scanner" "lp" "libvirtd" "libvirt" "docker" "ttr" "adbusers" "kvm" "plocate" "media" ];
      uid = 6000;
    };

    ttr-minimal = {
      hosts = [ "minimal" ];
      isNormalUser = true;
      group = "ttr-minimal";
      extraGroups = [ "plugdev" "wheel" "cups" "networkmanager" "scanner" "lp" "libvirtd" "libvirt" "docker" "ttr" "adbusers" "kvm" "plocate" ];
      uid = 7000;
    };

    muffin = {
      hosts = [ ];
      isNormalUser = true;
      group = "muffin";
      extraGroups = [ "cups" ];
      uid = 8000;
    };

    family = {
      hosts = [ ];
      isNormalUser = true;
      group = "family";
      extraGroups = [ "cups" ];
      uid = 9000;
    };
  };

  groupDefs = {
    ttr = {
      hosts = [ "desktop" "laptop" "server" ];
      gid = 5000;
    };

    media = {
      hosts = [ "desktop" "laptop" "server" ];
      gid = 5001;
      hostOverrides = {
        desktop = {
          members = [ "ttr" "hotio" ];
        };
        laptop = {
          members = [ "ttr" "hotio" ];
        };
        server = {
          members = [ "ttr" "ttr-server" "hotio" ];
        };
      };
    };

    ttr-server = {
      hosts = [ "desktop" "laptop" "server" ];
      gid = 6000;
      hostOverrides = {
        desktop = {
          members = [ "ttr" "media" ];
        };
        laptop = {
          members = [ "ttr" "media" ];
        };
        server = {
          members = [ "ttr" "hotio" ];
        };
      };
    };

    ttr-minimal = {
      hosts = [ "minimal" ];
      gid = 7000;
    };

    muffin = {
      hosts = [ ];
      gid = 8000;
    };

    family = {
      hosts = [ ];
      gid = 9000;
    };

    adbusers = {
      hosts = [ "desktop" "laptop" "server" ];
    };
  };
in
{
  users.users = mkHostScopedAttrs userDefs;
  users.groups = mkHostScopedAttrs groupDefs;
}
