{ config, pkgs, lib, ... }:

{
  # Enable fontconfig to properly manage and cache fonts
  fonts = {
    fontconfig.enable = true;
    
    packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      font-awesome
      ubuntu-classic
      
      (pkgs.stdenv.mkDerivation {
        name = "ttr-custom-fonts";
        src = ./fonts;
        
        installPhase = ''
          mkdir -p $out/share/fonts/opentype
          mkdir -p $out/share/fonts/truetype
          cp BREVESC.otf $out/share/fonts/opentype/
          cp foo.ttf $out/share/fonts/truetype/
        '';
        
        meta = with lib; {
          description = "TTR's custom fonts collection";
          license = licenses.unfree;
        };
      })
    ];
    
    enableDefaultPackages = true;
    
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
      sansSerif = [ "Noto Sans" "DejaVu Sans" ];
      serif = [ "Noto Serif" "DejaVu Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
