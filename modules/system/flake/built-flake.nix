{ final, prev }:
{
  # Built from source
  n-m3u8dl-re = final.callPackage ../../builds/n-m3u8dl-re.nix {};
  xdman7 = final.callPackage ../../builds/xdman7.nix {};
  xdman8 = final.callPackage ../../builds/xdman8.nix {};
  kak-connect = final.callPackage ../../builds/kak-connect.nix {};
  cryptomator-cli = final.callPackage ../../builds/cryptomator-cli.nix {};

  # Nixpkgs places libffmpeg.so in opt/vivaldi/, but the binary searches
  # opt/vivaldi/lib/. Mirror the codec into the searched directory.
  vivaldi = (prev.vivaldi.override {
    proprietaryCodecs = true;
    enableWidevine = true;
  }).overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      mkdir -p "$out/opt/vivaldi/lib"
      ln -sf ../libffmpeg.so "$out/opt/vivaldi/lib/libffmpeg.so"
    '';
  });
}
