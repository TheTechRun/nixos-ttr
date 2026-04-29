{ lib
, stdenv
, fetchurl
, makeWrapper
, gtk3
, ffmpeg
, rpmextract
, openssl
, gsettings-desktop-schemas
, adwaita-icon-theme
, hicolor-icon-theme
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "xdman8";
  version = "8.0.29";

  src = fetchurl {
    url = "https://github.com/subhra74/xdm/releases/download/${version}/xdman_gtk-${version}-1.fc36.x86_64.rpm";
    hash = "sha256-27R+f70DzIKqRniIYAPVbh1SIuy0pSqD4OZGH63CfqM=";
  };

  nativeBuildInputs = [ 
    makeWrapper 
    rpmextract
  ];
  
  buildInputs = [ 
    gtk3
    ffmpeg
    openssl
    gsettings-desktop-schemas
    adwaita-icon-theme
    hicolor-icon-theme
    shared-mime-info
  ];

  unpackPhase = ''
    rpmextract $src
  '';

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    # Create the directory structure
    mkdir -p $out/{bin,opt/xdman,share/applications,share/icons/hicolor/scalable/apps}
    
    # Copy the main application files
    cp -r opt/xdman/* $out/opt/xdman/
    
    # Install icon
    install -Dm644 opt/xdman/xdm-logo.svg $out/share/icons/hicolor/scalable/apps/
    
    # Create wrapper
    makeWrapper $out/opt/xdman/xdm-app $out/bin/xdman8 \
      --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}" \
      --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1 \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:${shared-mime-info}/share:$out/share:$XDG_DATA_DIRS" \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ 
        stdenv.cc.cc.lib 
        gtk3 
        openssl
      ]}" \
      --set GTK_THEME "Adwaita" \
      --set GTK3_MODULES "${gtk3}/lib/gtk-3.0"

    # Install desktop file
    install -Dm644 usr/share/applications/xdm-app.desktop $out/share/applications/xdman8.desktop
    
    # Patch the desktop file
    substituteInPlace $out/share/applications/xdman8.desktop \
      --replace "Exec=xdman" "Exec=xdman8" \
      --replace "Icon=xdm-app" "Icon=xdm-logo"
    
    # Make binary executable and link libraries
    chmod +x $out/opt/xdman/xdm-app
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath "${lib.makeLibraryPath [ 
               stdenv.cc.cc.lib 
               gtk3 
               openssl
             ]}" \
             $out/opt/xdman/xdm-app
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "Powerful download accelerator and video downloader";
    homepage = "https://github.com/subhra74/xdm";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
  };
}