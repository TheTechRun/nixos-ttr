{ final, prev }:
  let
    # other packages
    pinnedPkgs = import (fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/a73246e2eef4c6ed172979932bc80e1404ba2d56.tar.gz";
      sha256 = "sha256-463SNPWmz46iLzJKRzO3Q2b0Aurff3U1n0nYItxq7jU=";
    }) {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  in
  {
    # normcap = pinnedPkgs.normcap;
    # localsend = pinnedPkgs.localsend;
    # rofi = pinnedPkgs.rofi;
  }