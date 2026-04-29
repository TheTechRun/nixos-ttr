{ final, prev }:
{
  # Built from source
  n-m3u8dl-re = final.callPackage ../../builds/n-m3u8dl-re.nix {};
  xdman7 = final.callPackage ../../builds/xdman7.nix {};
  xdman8 = final.callPackage ../../builds/xdman8.nix {};
  kak-connect = final.callPackage ../../builds/kak-connect.nix {};
  cryptomator-cli = final.callPackage ../../builds/cryptomator-cli.nix {};
}
