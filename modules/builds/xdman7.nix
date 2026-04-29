{ lib
, stdenv
, fetchurl
, makeWrapper
, jdk11
, ffmpeg
, python3
, yt-dlp
}:

stdenv.mkDerivation rec {
  pname = "xdman";
  version = "7.2.11";

  src = fetchurl {
    url = "https://github.com/subhra74/xdm/releases/download/${version}/xdman.jar";
    hash = "sha256-gRfyhvneHlf0VRZ22PCrPi6ZBER0S1lffMTLngH1HHw=";
  };

  nativeBuildInputs = [ makeWrapper ];
  
  buildInputs = [ 
    jdk11
    ffmpeg 
    python3
    yt-dlp 
  ];

  dontBuild = true;
  dontConfigure = true;
  dontStrip = true;
  dontPatchELF = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/{bin,share/java/xdman}
    cp $src $out/share/java/xdman/xdman.jar

    # Create symlinks to ffmpeg and yt-dlp in the same directory as the jar
    ln -s ${ffmpeg}/bin/ffmpeg $out/share/java/xdman/ffmpeg
    ln -s ${yt-dlp}/bin/yt-dlp $out/share/java/xdman/yt-dlp
    ln -s ${yt-dlp}/bin/yt-dlp $out/share/java/xdman/youtube-dl

    makeWrapper ${jdk11}/bin/java $out/bin/xdman \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg yt-dlp ]} \
      --add-flags "-jar $out/share/java/xdman/xdman.jar"
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Xtreme Download Manager: download manager with multiple browser integrations";
    homepage = "https://xtremedownloadmanager.com/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}