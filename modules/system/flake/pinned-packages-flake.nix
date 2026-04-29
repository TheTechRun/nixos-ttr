{ final, prev }:
{
  pinnedPkgs = import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/a73246e2eef4c6ed172979932bc80e1404ba2d56.tar.gz";
    sha256 = "sha256-463SNPWmz46iLzJKRzO3Q2b0Aurff3U1n0nYItxq7jU=";
  }) { system = final.stdenv.hostPlatform.system; };

  # Pinned packages
  normcap = final.pinnedPkgs.normcap;
  localsend = final.pinnedPkgs.localsend;
  gpick = final.pinnedPkgs.gpick;
  lmms = final.pinnedPkgs.lmms;
  rofi = final.pinnedPkgs.rofi;
}
