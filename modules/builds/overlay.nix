# Built packages overlay for home-manager standalone use
# This provides the same built packages as the system flake

{ final, prev }:
{
  # Built from source packages
  # n-m3u8dl-re = final.callPackage ./n-m3u8dl-re.nix {};
  xdman7 = final.callPackage ./xdman7.nix {};
  # xdman8 = final.callPackage ./xdman8.nix {};
  # expert = final.callPackage ./expert.nix {};
}