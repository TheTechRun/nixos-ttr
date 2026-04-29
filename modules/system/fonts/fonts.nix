{ config, pkgs, lib, ... }:

{
  # Enable fontconfig to properly manage and cache fonts
  fonts = {
    # Enable font management with fontconfig
    fontconfig.enable = true;
    
    # Install fonts system-wide
    packages = with pkgs; [
      # Basic font collection
      dejavu_fonts
      liberation_ttf
      noto-fonts
      noto-fonts-color-emoji
      
      # Nerd Fonts (new format)
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      
      # Additional fonts
      font-awesome
      ubuntu-classic
      
      # Custom fonts from fonts directory - Method 2
      (pkgs.stdenv.mkDerivation {
        name = "ttr-custom-fonts";
        src = ./.;  # Points to the fonts directory itself (current directory)
        
        installPhase = ''
          mkdir -p $out/share/fonts/opentype
          mkdir -p $out/share/fonts/truetype
          
          # Install specific custom fonts
          cp BREVESC.otf $out/share/fonts/opentype/
          cp foo.ttf $out/share/fonts/truetype/
          
          # Alternative: Install all OTF and TTF files automatically
          # find . -name "*.otf" -exec cp {} $out/share/fonts/opentype/ \;
          # find . -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;
        '';
        
        meta = with lib; {
          description = "TTR's custom fonts collection";
          license = licenses.unfree;  # Adjust based on your font licenses
        };
      })
    ];
    
    # Optional: Enable default fonts
    enableDefaultPackages = true;
    
    # Optional: Configure font defaults
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
      sansSerif = [ "Noto Sans" "DejaVu Sans" ];
      serif = [ "Noto Serif" "DejaVu Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}