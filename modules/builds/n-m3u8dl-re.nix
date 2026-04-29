{ lib
, stdenv
, fetchurl
, makeWrapper
, icu
, openssl
, zlib
}:

stdenv.mkDerivation rec {
  pname = "n-m3u8dl-re";
  version = "0.2.1-beta";
  _time = "20240828";

  src = fetchurl {
    url = "https://github.com/nilaoda/N_m3u8DL-RE/releases/download/v${version}/N_m3u8DL-RE_Beta_linux-x64_${_time}.tar.gz";
    hash = "sha256-TOpIWhelu5GjSzELtaXThaI7ac7JcHUwU9g7JbRmuuo=";
  };

  nativeBuildInputs = [ makeWrapper ];
  
  buildInputs = [ 
    icu 
    openssl 
    zlib 
  ];

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    tar xvzf $src
  '';

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    cp N_m3u8DL-RE_Beta_linux-x64/N_m3u8DL-RE $out/bin/n-m3u8dl-re
    ln -s $out/bin/n-m3u8dl-re $out/bin/N_m3u8DL-RE
    chmod +x $out/bin/n-m3u8dl-re

    wrapProgram $out/bin/n-m3u8dl-re \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath buildInputs} \
      --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 0
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-Platform, beautiful and powerful stream downloader for DASH/HLS";
    homepage = "https://github.com/nilaoda/N_m3u8DL-RE";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}