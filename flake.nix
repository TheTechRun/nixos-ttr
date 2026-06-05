{
description = "NixOS configuration with Home Manager package modules and allowUnfree";

# INPUTS SECTION ---------------------------------------------

inputs = {
# Stable input (24.05)
#nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

# Unstable input
nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

# Pinned nixpkgs for Scroll until its wlroots/libinput build catches up
scroll-nixpkgs.url = "github:nixos/nixpkgs/1c3fe55ad329cbcb28471bb30f05c9827f724c76";

# Home Manager input (now system-wide again)
home-manager = {
  url = "github:nix-community/home-manager/master";
  inputs.nixpkgs.follows = "nixpkgs";
};

# Scroll WM input
scroll-flake = {
  url = "path:./modules/desktop-environment/wayland/scroll-flake";
  inputs.nixpkgs.follows = "scroll-nixpkgs";
};

# Nix-Flatpak input
nix-flatpak.url = "github:gmodena/nix-flatpak";

# Hardware-specific NixOS modules
nixos-hardware = {
  url = "github:NixOS/nixos-hardware/master";
};

};

# OUTPUTS SECTION (Edit these in the ./modules/system/flake directory)------------------------------------------------

outputs = { self, nixpkgs, home-manager, nix-flatpak, scroll-flake, ... }@inputs:
let
system = "x86_64-linux";

# MODULAR Import components
# Overlay imports
builtPackagesOverlay = import ./modules/system/flake/built-flake.nix;
pinnedPackagesOverlay = import ./modules/system/flake/pinned-packages-flake.nix;

overlay = final: prev:
  (builtPackagesOverlay { inherit final prev; }) //
  (pinnedPackagesOverlay { inherit final prev; });

mkPkgs = import nixpkgs {
inherit system;
config.allowUnfree = true;
overlays = [ overlay ];
};

mkNixosSystem = { hostName, extraModules ? [] }:
let
pkgs = mkPkgs;
in
nixpkgs.lib.nixosSystem {
inherit system;
specialArgs = { inherit nixpkgs nix-flatpak inputs hostName; };
modules = [
{ nixpkgs.overlays = [
  overlay
  (final: prev: {
    libsForQt5 = prev.libsForQt5 // {
      fcitx5-with-addons = (prev.kdePackages.fcitx5-with-addons or prev.fcitx5-with-addons);
    };
  })
]; }
inputs.scroll-flake.nixosModules.default
./hosts/${hostName}/configuration.nix
{ nixpkgs.config.allowUnfree = true; }
{ environment.systemPackages = [ ]; }
# Add Home Manager as a NixOS module
home-manager.nixosModules.home-manager
{
home-manager.useGlobalPkgs = true;
home-manager.useUserPackages = true;
home-manager.extraSpecialArgs = { inherit nix-flatpak; };
}
] ++ extraModules;
};

# HOST Import configurations
hostConfigs = import ./modules/system/flake/host-flake.nix {
inherit mkNixosSystem;
};

in {
nixosConfigurations = hostConfigs.nixosConfigurations;
};
}
