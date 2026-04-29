# modules/builds/expert.nix
{ lib, stdenv, writeText, xorg }:

let
  configText = ''
    Section "InputClass"
      Identifier "Kensington Expert Wireless TB Mouse"
      MatchProduct "Kensington Expert Wireless TB Mouse"
      MatchDevicePath "/dev/input/event*"
      Driver "evdev"
      
      # Enable the scroll wheel/ring
      Option "EmulateWheel" "true"
      Option "EmulateWheelButton" "8"
      
      # Scroll wheel/ring sensitivity
      Option "XAxisMapping" "6 7"
      Option "YAxisMapping" "4 5"
      Option "EmulateWheelInertia" "10"
      
      # Button mapping
      Option "ButtonMapping" "1 2 3 4 5 6 7 8 9"
      
      # Pointer acceleration
      Option "AccelSpeed" "0.5"
    EndSection
  '';
in
stdenv.mkDerivation {
  name = "kensington-expert-config";
  version = "1.0.0";

  unpackPhase = "mkdir -p $out";
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/etc/X11/xorg.conf.d
    echo "${configText}" > $out/etc/X11/xorg.conf.d/10-expert-mouse.conf
  '';

  meta = with lib; {
    description = "X11 configuration for Kensington Expert Wireless TB Mouse using evdev";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}