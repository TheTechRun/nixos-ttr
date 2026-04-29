{ lib
, stdenv
, fetchzip
, makeWrapper
, jdk21
, fuse3
, autoPatchelfHook
, zlib
}:

stdenv.mkDerivation rec {
  pname = "cryptomator-cli";
  version = "0.6.2";

  src = fetchzip {
    url = "https://github.com/cryptomator/cli/releases/download/${version}/cryptomator-cli-${version}-linux-x64.zip";
    hash = "sha256-x9BzJJ/5Z+Zz6KCRgZbz0gn36cljWJtQcTTS2AW1WOk=";    
    stripRoot = false;
  };

  nativeBuildInputs = [ 
    makeWrapper 
    autoPatchelfHook 
  ];
  
  buildInputs = [ 
    jdk21 
    fuse3 
    stdenv.cc.cc.lib
    zlib
  ];

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    mkdir -p $out/lib/cryptomator-cli
    
    # Copy all files to lib directory
    cp -r cryptomator-cli/* $out/lib/cryptomator-cli/
    
    # The executable is in bin/cryptomator-cli
    chmod +x $out/lib/cryptomator-cli/bin/cryptomator-cli
    
    # Create wrapper script that sets up environment properly
    makeWrapper $out/lib/cryptomator-cli/bin/cryptomator-cli $out/bin/cryptomator-cli \
      --prefix PATH : ${lib.makeBinPath [ jdk21 fuse3 ]} \
      --set JAVA_HOME ${jdk21} \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ fuse3 stdenv.cc.cc.lib ]}
    
    runHook postInstall
  '';

  # Enable patchelf for any native libraries
  dontStrip = true;

  meta = with lib; {
    description = "Command-Line Interface for Cryptomator";
    longDescription = ''
      This is a minimal command-line application that unlocks a single vault 
      of vault format 8 and mounts it into the system.
    '';
    homepage = "https://github.com/cryptomator/cli";
    changelog = "https://github.com/cryptomator/cli/releases/tag/${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "cryptomator-cli";
  };
}
